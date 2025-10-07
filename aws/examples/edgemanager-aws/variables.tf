variable "app_version" {
  description = "The application version to be deployed."
  type        = string
}

variable "ami_owner" {
  description = "The AWS account ID that owns the AMI."
  type        = string
}

variable "key_name" {
  description = "The name of the SSH key pair used for VM access."
  type        = string
}

variable "name" {
  description = "The identifier assigned to resources for easier management."
  type        = string
}

variable "oem_name" {
  description = "The OEM name associated with the virtual machine."
  type        = string
  default     = "edgemanager"
}

variable "ssh_pub_key" {
  description = "The user-defined public SSH key added to the virtual machine for access."
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "The ID of the target subnet where the virtual machine will be deployed."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the target VPC where the virtual machine will be deployed."
  type        = string
}
