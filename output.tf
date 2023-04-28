output "vm_ip" {
    value = azurerm_linux_virtual_machine.sap_demo_bastion.public_ip_address
}