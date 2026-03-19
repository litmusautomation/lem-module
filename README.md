## Terraform Edgemanager modules | AWS, AzureRM

#### About

These modules deploy the Litmus Edge Manager application on a virtual machine in either AWS or Azure. Both modules share the same security posture and configuration model:

- VM is deployed in a **private subnet** — no public IP is assigned
- Private IP only, with all communication staying within the VPC/VNet
- **SSH is permanently disabled** — this is enforced by the inner module and cannot be overridden via input variables
- Port access is fully configurable within defined constraints (see [Port Configuration](#port-configuration))

#### Security Model

**What is locked and cannot be changed:**
- SSH (port 22) is hard-locked off at the module level. Setting `ssh_enabled = true` will cause a Terraform validation error. This is by design — SSH access is not supported on Edge Manager deployments.
- Port 22 cannot be added to `ingress_tcp_ports` — a validation rule rejects it explicitly.
- Port 443 (HTTPS) must always be present in `ingress_tcp_ports` — it is required for Edge Manager functionality.
- Port 51820 (WireGuard VPN) must always be present in `ingress_udp_ports` — it is required for Edge Manager connectivity.

**What you can configure:**
- Which TCP and UDP ports are opened (within the constraints above)
- Which IP ranges (CIDR blocks) can access those ports
- The admin username on the VM
- The VM size/instance type
- SSH key material (Azure always requires it; AWS only uses it if you configure cloud-init separately)

> **Note on SSH-related optional parameters:** `ssh_enabled`, `ssh_pub_key`, and `ingress_cidr_ssh_blocks` are exposed as optional parameters but will have no functional effect — SSH access is permanently disabled at the module level and cannot be activated through input variables.

#### Port Configuration

Default TCP ports opened by the module:

| Port | Protocol | Purpose |
| ---- | -------- | ------- |
| 80   | TCP      | HTTP |
| 443  | TCP      | HTTPS — **required, cannot be removed** |
| 8446 | TCP      | HTTPS alternate |
| 8883 | TCP      | MQTT (IoT messaging) |
| 9092 | TCP      | Kafka (data streaming) |
| 9093 | TCP      | Kafka TLS |
| 8123 | TCP      | ClickHouse HTTP interface |
| 8543 | TCP      | ClickHouse HTTPS interface |
| 9000 | TCP      | ClickHouse native protocol |
| 9004 | TCP      | ClickHouse MySQL interface |
| 9090 | TCP      | Prometheus metrics |

Default UDP ports opened by the module:

| Port  | Protocol | Purpose |
| ----- | -------- | ------- |
| 51820 | UDP      | WireGuard VPN — **required, cannot be removed** |
| 123   | UDP      | NTP (time synchronization) |

**Customizing ports:**

You can replace the default port lists entirely by providing your own. Constraints that are always enforced:
- Port 22 must not be included in `ingress_tcp_ports`
- Port 443 must be included in `ingress_tcp_ports`
- Port 51820 must be included in `ingress_udp_ports`
- All ports must be in the range 1–65535

Example — minimal port configuration:
```hcl
ingress_tcp_ports = [443, 8883, 9092]   # only open what you need
ingress_udp_ports = [51820]             # only WireGuard required
```

**CIDR restrictions:**

By default, `ingress_cidr_blocks` is set to `["0.0.0.0/0"]` (open to all). In production, always restrict this to your organization's IP ranges:
```hcl
ingress_cidr_blocks = ["10.0.0.0/8", "192.168.1.0/24"]
```

#### State Management Configuration

Both AWS and Azure modules support remote state backends for team collaboration and state locking.

**AWS Backend (S3):**
```hcl
# aws/state.tf
terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "lem-module/aws/edgemanager/state"
    region = "us-east-1"
  }
}
```

**Azure Backend (Azure Storage):**
```hcl
# azure/state.tf
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-resource-group"
    storage_account_name = "yourterraformstate"
    container_name       = "tfstate"
    key                  = "lem-module/azure/edgemanager/state"
  }
}
```

**Configuration Files:**
- `state.tf` - Backend configuration (ignored by git)
- `secrets.auto.tfvars` - Deployment-specific values (ignored by git, automatically loaded)
- Both files are excluded from version control via `.gitignore`

**Important Notes:**
- State files contain sensitive data and should never be committed to version control
- Use remote backends (S3, Azure Storage) for team collaboration and state locking
- The `.auto.tfvars` extension ensures automatic loading without explicit `-var-file` flag

---

### Deploying Edgemanager on AWS

#### Requirements

- Terraform >= v1.5.7
- AWS access configured

#### Minimal Example

Required parameters only — uses all module defaults for ports, CIDR blocks, and VM size.

```hcl
module "edgemanager" {
  source      = "git@github.com:litmusautomation/lem-module//aws?ref=main"
  name        = "edgemanager-prod"
  app_version = "2.25.0"
  region      = "us-east-1"
  vpc_id      = "vpc-xxxxxxxxxxxxxxxxx"
  subnet_id   = "subnet-xxxxxxxxxxxxxxxxx"
  ami_owner   = "123456789012"
  key_name    = "my-ec2-keypair"
}
```

#### Full Example

All available parameters shown with example values. Parameters marked `# optional` have defaults and can be omitted.

See [Edgemanager AWS example](https://github.com/litmusautomation/lem-module/blob/main/aws/examples/edgemanager-aws/main.tf)

```hcl
module "edgemanager" {
  source      = "git@github.com:litmusautomation/lem-module//aws?ref=main"
  name        = "edgemanager-prod"
  app_version = "2.25.0"
  region      = "us-east-1"
  vpc_id      = "vpc-xxxxxxxxxxxxxxxxx"
  subnet_id   = "subnet-xxxxxxxxxxxxxxxxx"
  ami_owner   = "123456789012"
  key_name    = "my-ec2-keypair"

  # optional
  oem_name                = "edgemanager"
  admin_user_name         = "ubuntu"
  ssh_enabled             = false                    # must remain false — SSH is not supported
  ssh_pub_key             = "ssh-rsa AAAA... user@host"
  ingress_cidr_blocks     = ["10.0.0.0/8"]          # restrict to your network in production
  ingress_cidr_ssh_blocks = ["10.0.0.0/8"]
  ingress_tcp_ports       = [443, 8883, 9092]        # customize to only ports you need
  ingress_udp_ports       = [51820]                  # customize to only ports you need
}
```

#### Inputs

| Name                      | Description                                                                               | Type         | Default                                                            | Required |
| ------------------------- | ----------------------------------------------------------------------------------------- | ------------ | ------------------------------------------------------------------ | -------- |
| `name`                    | Name assigned to resources                                                                | string       | n/a                                                                | yes      |
| `app_version`             | Application version to deploy                                                             | string       | n/a                                                                | yes      |
| `region`                  | AWS region where resources will be deployed                                               | string       | n/a                                                                | yes      |
| `vpc_id`                  | VPC ID where resources will be deployed                                                   | string       | n/a                                                                | yes      |
| `subnet_id`               | Subnet ID for EC2 instances                                                               | string       | n/a                                                                | yes      |
| `ami_owner`               | AWS account ID owning the AMI                                                             | string       | n/a                                                                | yes      |
| `key_name`                | Name of the AWS EC2 key pair. Stored with the VM for future use                          | string       | n/a                                                                | yes      |
| `oem_name`                | OEM identifier for the deployment                                                         | string       | `"edgemanager"`                                                    | no       |
| `admin_user_name`         | Admin username created on the virtual machine                                             | string       | `"ubuntu"`                                                         | no       |
| `ssh_enabled`             | Must remain `false`. SSH is not supported on Edge Manager deployments                     | bool         | `false`                                                            | no       |
| `ssh_pub_key`             | SSH public key injected into the VM via cloud-init                                       | string       | `""`                                                               | no       |
| `ingress_cidr_blocks`     | CIDR blocks for application ingress. Restrict to your org's IP ranges in production      | list(string) | `["0.0.0.0/0"]`                                                    | no       |
| `ingress_cidr_ssh_blocks` | CIDR blocks for SSH ingress (reserved for future use when SSH is enabled)                 | list(string) | `["0.0.0.0/0"]`                                                    | no       |
| `ingress_tcp_ports`       | TCP ports to open. Must include 443. Must not include 22. See [Port Configuration](#port-configuration) | list(number) | `[80, 443, 8883, 9092, 8446, 9093, 8123, 8543, 9000, 9004, 9090]` | no       |
| `ingress_udp_ports`       | UDP ports to open. Must include 51820. See [Port Configuration](#port-configuration)     | list(number) | `[51820, 123]`                                                     | no       |

#### Outputs

| Name                | Description                             |
| ------------------- | --------------------------------------- |
| APP_VERSION         | Edgemanager application version         |
| PRIVATE_IP          | Private IP of the VM                    |
| APP_HTTPS_URL       | Edgemanager application https URL       |
| ADMIN_APP_HTTPS_URL | Edgemanager Admin application https URL |

---

### Deploying Edgemanager on Azure

#### Requirements

- Terraform >= v1.5.7
- Azure access configured with the following environment variables

| Name                | Description                                                                           |
| ------------------- | ------------------------------------------------------------------------------------- |
| ARM_CLIENT_ID       | The **client ID** of the Azure service principal used for authentication.             |
| ARM_CLIENT_SECRET   | The **client secret** associated with the Azure service principal for authentication. |
| ARM_SUBSCRIPTION_ID | The **Azure subscription ID** where Terraform will create and manage resources.       |
| ARM_TENANT_ID       | The **Azure tenant ID** linked to the subscription and service principal.             |

#### Minimal Example

Required parameters only — uses all module defaults for ports, CIDR blocks, and VM size.

> **Note:** `ssh_pub_key` is always required by the Azure provider to configure the VM, even when SSH access is disabled.

```hcl
module "edgemanager" {
  source                    = "git@github.com:litmusautomation/lem-module//azure?ref=main"
  name                      = "edgemanager-prod"
  oem_name                  = "edgemanager"
  app_version               = "2.25.0"
  subscription_id           = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  location                  = "East US"
  resource_group_name       = "my-resource-group"
  virtual_network_name      = "my-vnet"
  subnet_name               = "my-subnet"
  image_resource_group_name = "my-image-resource-group"
  ssh_pub_key               = "ssh-rsa AAAA... user@host"
}
```

#### Full Example

All available parameters shown with example values. Parameters marked `# optional` have defaults and can be omitted.

See [Edgemanager Azure example](https://github.com/litmusautomation/lem-module/blob/main/azure/examples/edgemanager-azure/main.tf)

```hcl
module "edgemanager" {
  source                    = "git@github.com:litmusautomation/lem-module//azure?ref=main"
  name                      = "edgemanager-prod"
  oem_name                  = "edgemanager"
  app_version               = "2.25.0"
  subscription_id           = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  location                  = "East US"
  resource_group_name       = "my-resource-group"
  virtual_network_name      = "my-vnet"
  subnet_name               = "my-subnet"
  image_resource_group_name = "my-image-resource-group"
  ssh_pub_key               = "ssh-rsa AAAA... user@host"  # required by Azure provider

  # optional
  admin_user_name         = "ubuntu"
  ssh_enabled             = false                    # must remain false — SSH is not supported
  ingress_cidr_blocks     = ["10.0.0.0/8"]          # restrict to your network in production
  ingress_cidr_ssh_blocks = ["10.0.0.0/8"]
  ingress_tcp_ports       = [443, 8883, 9092]        # customize to only ports you need
  ingress_udp_ports       = [51820]                  # customize to only ports you need
}
```

#### Inputs

| Name                        | Description                                                                               | Type         | Default                                                            | Required |
| --------------------------- | ----------------------------------------------------------------------------------------- | ------------ | ------------------------------------------------------------------ | -------- |
| `name`                      | Name assigned to resources                                                                | string       | n/a                                                                | yes      |
| `oem_name`                  | OEM identifier for the deployment                                                         | string       | n/a                                                                | yes      |
| `app_version`               | Application version to deploy                                                             | string       | n/a                                                                | yes      |
| `subscription_id`           | Azure subscription ID where resources will be deployed (sensitive)                        | string       | n/a                                                                | yes      |
| `location`                  | Azure region where resources will be created                                              | string       | n/a                                                                | yes      |
| `resource_group_name`       | Name of the Azure resource group                                                          | string       | n/a                                                                | yes      |
| `virtual_network_name`      | Name of the virtual network for the instance                                              | string       | n/a                                                                | yes      |
| `subnet_name`               | Name of the subnet where the instance will be deployed                                    | string       | n/a                                                                | yes      |
| `image_resource_group_name` | Name of the resource group hosting the VM image                                           | string       | n/a                                                                | yes      |
| `ssh_pub_key`               | SSH public key registered with the VM. Required by the Azure provider regardless of `ssh_enabled` | string | n/a                                                          | yes      |
| `admin_user_name`           | Admin username created on the virtual machine                                             | string       | `"ubuntu"`                                                         | no       |
| `ssh_enabled`               | Must remain `false`. SSH is not supported on Edge Manager deployments                     | bool         | `false`                                                            | no       |
| `ingress_cidr_blocks`       | CIDR blocks for application ingress. Restrict to your org's IP ranges in production      | list(string) | `["0.0.0.0/0"]`                                                    | no       |
| `ingress_cidr_ssh_blocks`   | CIDR blocks for SSH ingress (reserved for future use when SSH is enabled)                 | list(string) | `["0.0.0.0/0"]`                                                    | no       |
| `ingress_tcp_ports`         | TCP ports to open. Must include 443. Must not include 22. See [Port Configuration](#port-configuration) | list(number) | `[80, 443, 8883, 9092, 8446, 9093, 8123, 8543, 9000, 9004, 9090]` | no       |
| `ingress_udp_ports`         | UDP ports to open. Must include 51820. See [Port Configuration](#port-configuration)     | list(number) | `[51820, 123]`                                                     | no       |

#### Outputs

| Name                | Description                             |
| ------------------- | --------------------------------------- |
| APP_VERSION         | Edgemanager application version         |
| PRIVATE_IP          | Private IP of the VM                    |
| APP_HTTPS_URL       | Edgemanager application https URL       |
| ADMIN_APP_HTTPS_URL | Edgemanager Admin application https URL |

---

## License

Copyright (c) Litmus Automation Inc.
