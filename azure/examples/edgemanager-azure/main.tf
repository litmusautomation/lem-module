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
