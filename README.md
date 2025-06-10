## Terraform Edgemanager modules | AWS, AzureRM

#### About

- Modules deploy a virtual machine (VM) in a private subnet, ensuring isolation from the public network.
- Do not assign a public IP to the instance, enhancing security by restricting direct internet access.
- Modules assign a private IP to the instance, allowing communication within the VPC/VNet while maintaining internal networking.
- SSH access is disabled by default, reinforcing security by preventing unauthorized remote access.

### Deploying Edgemanager on AWS

#### Requirements

- Terraform >= v1.5.7
- AWS access configured

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
  ssh_pub_key             = "ssh-rsa xxxxxxxxxxxxxxxxx user@host"
  ingress_cidr_blocks     = ["0.0.0.0/0"]
  ingress_cidr_ssh_blocks = ["0.0.0.0/0"]
}

```

#### Inputs

| Name                      | Description                                       | Type         | Default       | Required |
| ------------------------- | ------------------------------------------------- | ------------ | ------------- | -------- |
| `name`                    | Name assigned to resources                        | string       | n/a           | yes      |
| `oem_name`                | OEM identifier for the deployment                 | string       | n/a           | yes      |
| `app_version`             | Application version to deploy                     | string       | n/a           | yes      |
| `vpc_id`                  | VPC ID where resources will be deployed           | string       | n/a           | yes      |
| `subnet_id`               | Subnet ID for EC2 instances                       | string       | n/a           | yes      |
| `key_name`                | Name of the AWS EC2 key pair                      | string       | n/a           | yes      |
| `ami_owner`               | AWS account ID owning the AMI                     | string       | n/a           | yes      |
| `ssh_pub_key`             | Custom SSH public key (will not override default) | string       | null          | no       |
| `ingress_cidr_blocks`     | List of CIDR blocks for application HTTP ingress  | list(string) | ["0.0.0.0/0"] | no       |
| `ingress_cidr_ssh_blocks` | List of CIDR blocks for SSH ingress               | list(string) | ["0.0.0.0/0"] | no       |

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
  location                  = "East US"
  resource_group_name       = "xxxxxxxxxxxxxxxxx"
  virtual_network_name      = "xxxxxxxxxxxxxxxxx"
  subnet_id                 = "xxxxxxxxxxxxxxxxx" # subnet name
  image_resource_group_name = "xxxxxxxxxxxxxxxxx"
  ssh_pub_key               = "ssh-rsa xxxxxxxxxxxxxxxxx user@host" # required custom ssh public key
}

```

#### Inputs

| Name                        | Description                                     | Type   | Default | Required |
| --------------------------- | ----------------------------------------------- | ------ | ------- | -------- |
| `name`                      | Name assigned to resources                      | string | n/a     | yes      |
| `oem_name`                  | OEM identifier for the deployment               | string | n/a     | yes      |
| `app_version`               | Application version to deploy                   | string | n/a     | yes      |
| `location`                  | Azure region where resources will be created    | string | n/a     | yes      |
| `resource_group_name`       | Name of the Azure resource group                | string | n/a     | yes      |
| `virtual_network_name`      | Name of the virtual network for the instance    | string | n/a     | yes      |
| `subnet_id`                 | Subnet name where the instance will be deployed | string | n/a     | yes      |
| `image_resource_group_name` | Name of the resource group hosting the image    | string | n/a     | yes      |
| `ssh_pub_key`               | Custom SSH public key for authentication        | string | n/a     | yes      |

#### Outputs

| Name                | Description                             |
| ------------------- | --------------------------------------- |
| APP_VERSION         | Edgemanager application version         |
| PRIVATE_IP          | Private IP of the VM                    |
| APP_HTTPS_URL       | Edgemanager application https URL       |
| ADMIN_APP_HTTPS_URL | Edgemanager Admin application https URL |

## License

Copyright (c) Litmus Automation Inc.
