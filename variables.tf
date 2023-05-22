#   ⡇⠄⣿⣿⣿⣿⡇⠄⣿⣿⠄⠙⢿⣿⣿⠟⠉⠄⣿⣿⠄⢀⣀⣀⣀⡀⠙⣿
#   ⡇⠄⣿⣿⣿⣿⡇⠄⣿⣿⠄⢠⡀⠙⠋⢀⡄⠄⣿⣿⠄⠈⠉⠉⠉⠁⠄⣿
#   ⣧⠄⠙⠻⠿⠛⠁⣠⣿⣿⠄⢸⣿⣦⣴⣿⡇⠄⣿⣿⠄⠘⠛⠛⠛⠛⠄⣼
#   ⣿⣿⣶⣶⣶⣶⣾⣿⣿⣿⣶⣾⣿⣿⣿⣿⣷⣶⣿⣿⣶⣶⣶⣶⣶⣶⣾⣿
#   ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄


#   Date:          2023.04.17
#   Creator:       Laurenz Ströbele, laurenz.stroebele@umb.ch | Team Linux Operations UMB AG
#   Filename:      variables.tf
#   Description:   Variable File for Azure K8s Automation
#   Contains:
#     - Dynamic Variables, to change:                            
#       - Azure Tenant ID     
#       - Azure Subscription ID 
#       - Resource Group Name addition                               
#       - Azure virtual machine resource type
#       - Azure virtual machine disk
#     - Static Variables, maybe to change:
#       - naming azure region                               
#       - default location                                  
#       - CustomerShortName                                 
#       - Service name          

##############################################################################################

# Azure Tenant ID
variable "azureTenant" {
    type = string
    description = "Tenant ID of Azure Plattform"
}

# Azure Subscription ID
variable "azureSubscription" {
    type = string
    description = "Subscription ID of Azure Plattform"
}

# Resource Group Name addition
variable "rgAddition" {
    type        = string
    description = "Number of Kubernetes Cluster, to differentiate multiple Kubernetes Clusters"
}

# Azure virtual machine resource type
variable "vmType" {
    type        = string
    default     = "Standard_B2s"
    description = "Size for virtual machines in Azure"  
}

# Azure virtual machine disk
variable "diskType" {
    type        = string
    default     = "StandardSSD_LRS"
    description = "OS-disk type for virtual machines in Azure"  
}

###################################################

# naming azure region
variable "azregion" {
    type        = string
    description = "default region to lable resources in azure"
    default     = "chn"
}

# default location
variable "location" {
    type        = string
    description = "default location for resources"
    default     = "Switzerland North"
}

# CustomerShortName
variable "cShortName" {
    type        = string
    description = "contraction of customer name"
}

# Service Name
variable "servicename" {
    type        = string
    description = "short description of service"
    default     = "k8s"
}


###################################################
# Virtual Machine Ubuntu Name
variable "UbuntuVMname" {
    type        = string
    description = "Default Virtual Machine name"
    default     = "k8s-master-"
}

# Virtual Machine Quantity of Kubernetes Masters
variable "UbuntuNodeCount" {
    type        = number
    description = "Number of Ubuntu Nodes" 
}


###################################################
# Virtual Machine Ubuntu Name
variable "RHELVMname" {
    type        = string
    description = "Default Virtual Machine name"
    default     = "k8s-master-"
}

# Virtual Machine Quantity of Kubernetes Masters
variable "RHELNodeCount" {
    type        = number
    description = "Number of RHEL Nodes" 
}