provider "azurerm" {
  features {}
  subscription_id = "50818730-e898-4bc4-bc35-d998af53d719"
}

resource "azurerm_resource_group" "myRG" {
  name     = "myResourceGroup"
  location = "East US"
}

resource "azurerm_virtual_network" "myVNet" {
  name                = "myVNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myRG.location
  resource_group_name = azurerm_resource_group.myRG.name
}

resource "azurerm_subnet" "mySubnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.myRG.name
  virtual_network_name = azurerm_virtual_network.myVNet.name
  address_prefixes     = ["10.0.1.0/24"]        
}

resource "azurerm_network_interface" "myNIC" {
  name                = "myNIC"
  location            = azurerm_resource_group.myRG.location
  resource_group_name = azurerm_resource_group.myRG.name

  ip_configuration {
    name                          = "myIPConfig"
    subnet_id                     = azurerm_subnet.mySubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "myVM" {
  name                = "myServer"
  resource_group_name = azurerm_resource_group.myRG.name
  location            = azurerm_resource_group.myRG.location
  size                = "Standard_DS1_v2"
  admin_username      = "atul"
  admin_password      = "Password@1234"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.myNIC.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}


