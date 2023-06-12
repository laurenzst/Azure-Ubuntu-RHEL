#   ⡇⠄⣿⣿⣿⣿⡇⠄⣿⣿⠄⠙⢿⣿⣿⠟⠉⠄⣿⣿⠄⢀⣀⣀⣀⡀⠙⣿
#   ⡇⠄⣿⣿⣿⣿⡇⠄⣿⣿⠄⢠⡀⠙⠋⢀⡄⠄⣿⣿⠄⠈⠉⠉⠉⠁⠄⣿
#   ⣧⠄⠙⠻⠿⠛⠁⣠⣿⣿⠄⢸⣿⣦⣴⣿⡇⠄⣿⣿⠄⠘⠛⠛⠛⠛⠄⣼
#   ⣿⣿⣶⣶⣶⣶⣾⣿⣿⣿⣶⣾⣿⣿⣿⣿⣷⣶⣿⣿⣶⣶⣶⣶⣶⣶⣾⣿
#   ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄


#   Date:          2023.05.22
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
resource "azurerm_public_ip" "pip_ubuntu" {
  count               = var.UbuntuNodeCount
  name                = "${var.UbuntuVMname}${count.index}-pip0"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  tags = {
        environment = "Public IP"
    }
}

# Create Network Interface
resource "azurerm_network_interface" "nic_ubuntu" {
    count               = var.UbuntuNodeCount
    name                = "${var.UbuntuVMname}${count.index}-nic0"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    ip_configuration {
        name                          = "nic_configuration"
        subnet_id                     = azurerm_subnet.snet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${element(azurerm_public_ip.pip_ubuntu.*.id, count.index)}"
    }
    tags = {
        environment = "NIC"
    }
    depends_on = [
        azurerm_public_ip.pip_ubuntu
    ]
}

# Connect the Security Group to the Network Interface
resource "azurerm_network_interface_security_group_association" "sga_ubuntu" {
    count                     = var.UbuntuNodeCount
    network_interface_id      = "${element(azurerm_network_interface.nic_ubuntu.*.id, count.index)}"
    network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create Virtual Machine for Ubuntu node
resource "azurerm_linux_virtual_machine" "azvm_ubuntu" {
    count                 = var.UbuntuNodeCount
    name                  = "${var.UbuntuVMname}${count.index}"
    location              = azurerm_resource_group.rg.location
    resource_group_name   = azurerm_resource_group.rg.name
    network_interface_ids  = ["${element(azurerm_network_interface.nic_ubuntu.*.id, count.index)}"]
    size                  = var.vmType
    os_disk {
        name              = "${var.UbuntuVMname}${count.index}-disk0"
        caching           = "ReadWrite"
        storage_account_type = var.diskType
    }
    source_image_reference {
       publisher = "Canonical"
       offer     = "0001-com-ubuntu-server-jammy"
       sku       = "22_04-lts-gen2"
       version   = "latest"
    }
    computer_name  = "${var.UbuntuVMname}${count.index}"
    admin_username = "azureuser"
    disable_password_authentication = true
    admin_ssh_key {
        username       = "azureuser"
        public_key     = tls_private_key.ssh_keyfile.public_key_openssh
    }
    tags = {
        environment = "Ubuntu_Node"
    }
    depends_on = [
        tls_private_key.ssh_keyfile
    ]
}