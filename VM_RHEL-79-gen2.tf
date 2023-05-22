#   ⡇⠄⣿⣿⣿⣿⡇⠄⣿⣿⠄⠙⢿⣿⣿⠟⠉⠄⣿⣿⠄⢀⣀⣀⣀⡀⠙⣿
#   ⡇⠄⣿⣿⣿⣿⡇⠄⣿⣿⠄⢠⡀⠙⠋⢀⡄⠄⣿⣿⠄⠈⠉⠉⠉⠁⠄⣿
#   ⣧⠄⠙⠻⠿⠛⠁⣠⣿⣿⠄⢸⣿⣦⣴⣿⡇⠄⣿⣿⠄⠘⠛⠛⠛⠛⠄⣼
#   ⣿⣿⣶⣶⣶⣶⣾⣿⣿⣿⣶⣾⣿⣿⣿⣿⣷⣶⣿⣿⣶⣶⣶⣶⣶⣶⣾⣿
#   ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄


#   Date:          2023.04.17
#   Creator:       Laurenz Ströbele, laurenz.stroebele@umb.ch | Team Linux Operations UMB AG
#   Filename:      Ubuntu-22_04-tls-gen2.tf
#   Description:   Resource Creation for Azure Ubuntu Virtual Machine(s)
#   Contains:
#     - Public IPs 
#     - Network Interface 
#     - Network Security Group to Network Interface Connection 
#     - SSH key creation 
#     - local key creation
#     - Virtual Machine 

##############################################################################################

# Create public IPs 
resource "azurerm_public_ip" "pip_rhel" {
  count               = var.RHELNodeCount
  name                = "${var.RHELVMname}${count.index}-pip0"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  tags = {
        environment = "Public IP"
    }
}

# Create Network Interface
resource "azurerm_network_interface" "nic_rhel" {
    count               = var.RHELNodeCount
    name                = "${var.RHELVMname}${count.index}-nic0"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    ip_configuration {
        name                          = "nic_configuration"
        subnet_id                     = azurerm_subnet.snet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${element(azurerm_public_ip.pip_rhel.*.id, count.index)}"
    }
    tags = {
        environment = "NIC"
    }
    depends_on = [
        azurerm_public_ip.pip_rhel
    ]
}

# Connect the Security Group to the Network Interface
resource "azurerm_network_interface_security_group_association" "sga_rhel" {
    count                     = var.RHELNodeCount
    network_interface_id      = "${element(azurerm_network_interface.nic_rhel.*.id, count.index)}"
    network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create Virtual Machine for RHEL node
resource "azurerm_linux_virtual_machine" "azvm_rhel" {
    count                 = var.RHELNodeCount
    name                  = "${var.RHELVMname}${count.index}"
    location              = azurerm_resource_group.rg.location
    resource_group_name   = azurerm_resource_group.rg.name
    network_interface_ids  = ["${element(azurerm_network_interface.nic_rhel.*.id, count.index)}"]
    size                  = var.vmType
    os_disk {
        name              = "${var.RHELVMname}${count.index}-disk0"
        caching           = "ReadWrite"
        storage_account_type = var.diskType
    }
    source_image_reference {
       publisher = "RedHat"
       offer     = "RHEL"
       sku       = "79-gen2"
       version   = "latest"
    }
    computer_name  = "${var.RHELVMname}${count.index}"
    admin_username = "azureuser"
    disable_password_authentication = true
    admin_ssh_key {
        username       = "azureuser"
        public_key     = tls_private_key.ssh_keyfile.public_key_openssh
    }
    tags = {
        environment = "RHEL_Node"
    }
    depends_on = [
        tls_private_key.ssh_keyfile
    ]
}