## Terraform Edgemanager modules | AWS, AzureRM

#### About

- Modules deploy a virtual machine (VM) in a private subnet, ensuring isolation from the public network.
- Do not assign a public IP to the instance, enhancing security by restricting direct internet access.
- Modules assign a private IP to the instance, allowing communication within the VPC/VNet while maintaining internal networking.
- SSH access is disabled by default, reinforcing security by preventing unauthorized remote access.

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

### Deploying Edgemanager on AWS

#### Requirements

- Terraform >= v1.5.7
- AWS access configured

#### Security

**SSH Access:**
- SSH (port 22) is **explicitly disabled** for security reasons
- Attempting to include port 22 in `ingress_tcp_ports` will result in a validation error
- Azure deployments have an explicit deny rule for SSH traffic
- AWS deployments omit SSH from security group rules

**Network Security Best Practices:**
- Always restrict `ingress_cidr_blocks` to your organization's IP ranges
- Never use `0.0.0.0/0` in production environments
- Use minimal port configuration for reduced attack surface
- Minimum required ports: **443/tcp** (HTTPS) and **51820/udp** (WireGuard VPN)

**Port Configuration:**
- All port variables include validation to ensure required ports are present
- Port 22 is automatically rejected if specified
- Valid port range: 1-65535

#### Usage

See [Edgemanager AWS example](https://github.com/litmusautomation/lem-module/blob/main/aws/examples/edgemanager-aws/main.tf)

```
module "edgemanager-example" {
  source                  = "git@github.com:litmusautomation/lem-module//aws?ref=main"
  name                    = "edgemanager-example-aws"
  oem_name                = "edgemanager"
  app_version             = "2.25.0"
  vpc_id                  = "vpc-xxxxxxxxxxxxxxxxx"
  subnet_id               = "subnet-xxxxxxxxxxxxxxxxx"
  key_name                = "xxxxxxxxxxxxxxxxx"
  ami_owner               = "xxxxxxxxxxxxxxxxx"

  # Optional parameters
  region                  = "us-west-2"
  ssh_pub_key             = "ssh-rsa xxxxxxxxxxxxxxxxx user@host" # optional: injected via cloud-init
  ingress_cidr_blocks     = ["0.0.0.0/0"]
  ingress_tcp_ports       = [443, 8883, 9092]  # Customize TCP ports
  ingress_udp_ports       = [51820]            # Customize UDP ports
}

```

#### Inputs

| Name                      | Description                                                         | Type         | Default                                                     | Required |
| ------------------------- | ------------------------------------------------------------------- | ------------ | ----------------------------------------------------------- | -------- |
| `name`                    | Name assigned to resources                                          | string       | n/a                                                         | yes      |
| `oem_name`                | OEM identifier for the deployment                                   | string       | `"edgemanager"`                                             | no       |
| `app_version`             | Application version to deploy                                       | string       | n/a                                                         | yes      |
| `vpc_id`                  | VPC ID where resources will be deployed                             | string       | n/a                                                         | yes      |
| `subnet_id`               | Subnet ID for EC2 instances                                         | string       | n/a                                                         | yes      |
| `key_name`                | Name of the AWS EC2 key pair                                        | string       | n/a                                                         | yes      |
| `ami_owner`               | AWS account ID owning the AMI                                       | string       | n/a                                                         | yes      |
| `region`                  | AWS region where resources will be deployed                         | string       | `us-east-1`                                                 | no       |
| `admin_user_name`         | Admin username created on the virtual machine                       | string       | `"ubuntu"`                                                  | no       |
| `ssh_pub_key`             | Custom SSH public key appended to the VM via cloud-init             | string       | `""`                                                        | no       |
| `ingress_cidr_blocks`     | List of CIDR blocks for application HTTP ingress                    | list(string) | `["0.0.0.0/0"]`                                             | no       |
| `ingress_cidr_ssh_blocks` | List of CIDR blocks for SSH ingress                                 | list(string) | `["0.0.0.0/0"]`                                             | no       |
| `ingress_tcp_ports`       | List of TCP ports to allow ingress traffic (minimum required: 443)  | list(number) | `[80, 443, 8883, 9092, 8446, 9093, 8123, 8543, 9000, 9004, 9090]` | no       |
| `ingress_udp_ports`       | List of UDP ports to allow ingress traffic (minimum required: 51820)| list(number) | `[51820, 123]`                                              | no       |

#### Outputs

| Name                | Description                             |
| ------------------- | --------------------------------------- |
| APP_VERSION         | Edgemanager application version         |
| PRIVATE_IP          | Private IP of the VM                    |
| APP_HTTPS_URL       | Edgemanager application https URL       |
| ADMIN_APP_HTTPS_URL | Edgemanager Admin application https URL |

### Deploying Edgemanager on Azure

#### Requirements

- Terraform >= v1.5.7
- Azure access configured with the following

| Name                | Description                                                                           |
| ------------------- | ------------------------------------------------------------------------------------- |
| ARM_CLIENT_ID       | The **client ID** of the Azure service principal used for authentication.             |
| ARM_CLIENT_SECRET   | The **client secret** associated with the Azure service principal for authentication. |
| ARM_SUBSCRIPTION_ID | The **Azure subscription ID** where Terraform will create and manage resources.       |
| ARM_TENANT_ID       | The **Azure tenant ID** linked to the subscription and service principal.             |

#### Usage

See [Edgemanager Azure example](https://github.com/litmusautomation/lem-module/blob/main/azure/examples/edgemanager-azure/main.tf)

```
module "edgemanager-example" {
  source                    = "git@github.com:litmusautomation/lem-module//azure?ref=main"
  name                      = "edgemanager-example-azure"
  oem_name                  = "edgemanager"
  app_version               = "2.25.0"
  subscription_id           = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  location                  = "East US"
  resource_group_name       = "xxxxxxxxxxxxxxxxx"
  virtual_network_name      = "xxxxxxxxxxxxxxxxx"
  subnet_id                 = "xxxxxxxxxxxxxxxxx" # subnet name
  image_resource_group_name = "xxxxxxxxxxxxxxxxx"
  ssh_pub_key               = "ssh-rsa xxxxxxxxxxxxxxxxx user@host" # required custom ssh public key

  # Optional parameters
  ingress_cidr_blocks     = ["0.0.0.0/0"]
  ingress_tcp_ports       = [443, 8883, 9092]  # Customize TCP ports
  ingress_udp_ports       = [51820]            # Customize UDP ports
}

```

#### Inputs

| Name                        | Description                                                          | Type         | Default                                                     | Required |
| --------------------------- | -------------------------------------------------------------------- | ------------ | ----------------------------------------------------------- | -------- |
| `name`                      | Name assigned to resources                                           | string       | n/a                                                         | yes      |
| `oem_name`                  | OEM identifier for the deployment                                    | string       | n/a                                                         | yes      |
| `app_version`               | Application version to deploy                                        | string       | n/a                                                         | yes      |
| `subscription_id`           | Azure subscription ID where resources will be deployed (sensitive)   | string       | n/a                                                         | yes      |
| `location`                  | Azure region where resources will be created                         | string       | n/a                                                         | yes      |
| `resource_group_name`       | Name of the Azure resource group                                     | string       | n/a                                                         | yes      |
| `virtual_network_name`      | Name of the virtual network for the instance                         | string       | n/a                                                         | yes      |
| `subnet_id`                 | Subnet name where the instance will be deployed                      | string       | n/a                                                         | yes      |
| `image_resource_group_name` | Name of the resource group hosting the image                         | string       | n/a                                                         | yes      |
| `ssh_pub_key`               | Custom SSH public key for authentication                             | string       | n/a                                                         | yes      |
| `admin_user_name`           | Admin username created on the virtual machine                        | string       | `"ubuntu"`                                                  | no       |
| `ingress_cidr_blocks`       | List of CIDR blocks for application HTTP ingress                     | list(string) | `["0.0.0.0/0"]`                                             | no       |
| `ingress_cidr_ssh_blocks`   | List of CIDR blocks for SSH ingress                                  | list(string) | `["0.0.0.0/0"]`                                             | no       |
| `ingress_tcp_ports`         | List of TCP ports to allow ingress traffic (minimum required: 443)   | list(number) | `[80, 443, 8883, 9092, 8446, 9093, 8123, 8543, 9000, 9004, 9090]` | no       |
| `ingress_udp_ports`         | List of UDP ports to allow ingress traffic (minimum required: 51820) | list(number) | `[51820, 123]`                                              | no       |

#### Outputs

| Name                | Description                             |
| ------------------- | --------------------------------------- |
| APP_VERSION         | Edgemanager application version         |
| PRIVATE_IP          | Private IP of the VM                    |
| APP_HTTPS_URL       | Edgemanager application https URL       |
| ADMIN_APP_HTTPS_URL | Edgemanager Admin application https URL |

## License

Copyright (c) Litmus Automation Inc.
