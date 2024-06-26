resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "aa"
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  location            = azurerm_resource_group.rg.location
  name                = "terraform-aks"
  resource_group_name = "aa"

  dns_prefix = "project-aks"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = var.node_count
  }

  linux_profile {
    admin_username = var.username

    ssh_key {
      key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
    }
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}
