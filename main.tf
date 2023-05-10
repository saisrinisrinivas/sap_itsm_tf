#Resource group for the virtual machine
resource "azurerm_resource_group" "sap_demo_tf_test" {
    name = "sap_demo"
    location = "South India" 
}
resource "azurerm_virtual_network" "sap_demo_tf_testnet" {
  name                = "sap_demo_tf_test_net"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.sap_demo_tf_test.location
  resource_group_name = azurerm_resource_group.sap_demo_tf_test.name
}

#Virtual machine subnet
resource "azurerm_subnet" "vm_subnet" {
  name                 = "sap_demo_vm_subnet"
  resource_group_name  = azurerm_resource_group.sap_demo_tf_test.name
  virtual_network_name = azurerm_virtual_network.sap_demo_tf_testnet.name
  address_prefixes     = ["10.1.0.0/16"]
}

#Virtual Machine in public ip
resource "azurerm_public_ip" "sap_demo_tf_vm_pip" {
  name                    = "tf_vm_pip"
  location                = azurerm_resource_group.sap_demo_tf_test.location
  resource_group_name     = azurerm_resource_group.sap_demo_tf_test.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}


#Network interface for the Virtual machine
resource "azurerm_network_interface" "sap_demo_tf_vm_if" {
  name                = "tf_test_if"
  location            = azurerm_resource_group.sap_demo_tf_test.location
  resource_group_name = azurerm_resource_group.sap_demo_tf_test.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.sap_demo_tf_vm_pip.id
  }
}

#Create virtual machine
resource "azurerm_linux_virtual_machine" "sap_demo_bastion" {
  name                = "bastion"
  resource_group_name = azurerm_resource_group.sap_demo_tf_test.name
  location            = azurerm_resource_group.sap_demo_tf_test.location
  size                = "Standard_B2s"
  admin_username      = "azureuser"
  admin_password      = "heyhi@123"
  disable_password_authentication = false
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
   

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

 network_interface_ids = [
    azurerm_network_interface.sap_demo_tf_vm_if.id,
  ]

  
#custom_data = filebase64("init_script.sh")
provisioner "remote-exec" {
  inline = [
    "chmod +x ./init_script.sh" ,
    "./init_script.sh"
  ]

} 

}

#Network security group for the Virtual Machine
resource "azurerm_network_security_group" "sap_demo_security_group" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.sap_demo_tf_test.location
  resource_group_name = azurerm_resource_group.sap_demo_tf_test.name
}

#Network Outbound security rule
resource "azurerm_network_security_rule" "sap_demo_outbound_network_security_rule" {
  name                        = "Outboundrule"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "8080"
  destination_port_range     = "9000"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.sap_demo_tf_test.name
  network_security_group_name = azurerm_network_security_group.sap_demo_security_group.name
}

/*resource "tls_private_key" "sap_demo_vm_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}*/
