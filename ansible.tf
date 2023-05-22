#   ⡇⠄⣿⣿⣿⣿⡇⠄⣿⣿⠄⠙⢿⣿⣿⠟⠉⠄⣿⣿⠄⢀⣀⣀⣀⡀⠙⣿
#   ⡇⠄⣿⣿⣿⣿⡇⠄⣿⣿⠄⢠⡀⠙⠋⢀⡄⠄⣿⣿⠄⠈⠉⠉⠉⠁⠄⣿
#   ⣧⠄⠙⠻⠿⠛⠁⣠⣿⣿⠄⢸⣿⣦⣴⣿⡇⠄⣿⣿⠄⠘⠛⠛⠛⠛⠄⣼
#   ⣿⣿⣶⣶⣶⣶⣾⣿⣿⣿⣶⣾⣿⣿⣿⣿⣷⣶⣿⣿⣶⣶⣶⣶⣶⣶⣾⣿
#   ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄


#   Date:          2023.04.17
#   Creator:       Laurenz Ströbele, laurenz.stroebele@umb.ch | Team Linux Operations UMB AG
#   Filename:      ansible.tf
#   Description:   Ansible Configurations and triggering Ansible Automation
#   Contains:
#     - create local inventory file for Ansible hosts
#     - trigger Ansible Process

##############################################################################################

# Update Ansible inventory
resource "local_file" "ansible_host" {
    depends_on = [
      azurerm_linux_virtual_machine.azvm_ubuntu
    ]

    filename    = "inventory"
    content     = <<EOF
[ubuntu]
%{ for index, ip in azurerm_linux_virtual_machine.azvm_ubuntu ~}
${azurerm_linux_virtual_machine.azvm_ubuntu[index].name} ansible_host=${azurerm_linux_virtual_machine.azvm_ubuntu[index].public_ip_address} ansible_user=${azurerm_linux_virtual_machine.azvm_ubuntu[index].admin_username} ansible_ssh_private_key_file=./${local_file.local_keyfile.filename} ansible_become=true ansible_ssh_common_args='-o StrictHostKeyChecking=no' 
%{ endfor ~}

[rhel]
%{ for index, ip in azurerm_linux_virtual_machine.azvm_rhel ~}
${azurerm_linux_virtual_machine.azvm_rhel[index].name} ansible_host=${azurerm_linux_virtual_machine.azvm_rhel[index].public_ip_address} ansible_user=${azurerm_linux_virtual_machine.azvm_rhel[index].admin_username} ansible_ssh_private_key_file=./${local_file.local_keyfile.filename} ansible_become=true ansible_ssh_common_args='-o StrictHostKeyChecking=no' 
%{ endfor ~}
EOF
}
