#   ⡇⠄⣿⣿⣿⣿⡇⠄⣿⣿⠄⠙⢿⣿⣿⠟⠉⠄⣿⣿⠄⢀⣀⣀⣀⡀⠙⣿
#   ⡇⠄⣿⣿⣿⣿⡇⠄⣿⣿⠄⢠⡀⠙⠋⢀⡄⠄⣿⣿⠄⠈⠉⠉⠉⠁⠄⣿
#   ⣧⠄⠙⠻⠿⠛⠁⣠⣿⣿⠄⢸⣿⣦⣴⣿⡇⠄⣿⣿⠄⠘⠛⠛⠛⠛⠄⣼
#   ⣿⣿⣶⣶⣶⣶⣾⣿⣿⣿⣶⣾⣿⣿⣿⣿⣷⣶⣿⣿⣶⣶⣶⣶⣶⣶⣾⣿
#   ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄


# Relevant Variables to change:
#------------------------------------------------------------------------------------------------------


#-[azureTenant]---------------------------------------
# (String) Azure Tenant ID
# default Value: no value
azureTenant = ""


#-[azureSubscription]---------------------------------------
# (String) Azure Subscription ID
# default Value: no value
azureSubscription = ""


#-[rgAddition]---------------------------------------
# (Number) Ressource Group Name Addition | example: rg-stz-chn-k8s-0 <-- last digit
# default Value: no value
rgAddition = 0

#-[vmType]---------------------------------------
# (String) Azure virtual machine resource type | example: Standard_B1s
# default Value: Standard_B2s
#vmType = ""


#-[diskType]---------------------------------------
# (String) Azure virtual machine disk | example: Premium_LRS
# default Value: StandardSSD_LRS
#diskType = ""


# Other Variables to maybe change:
#------------------------------------------------------------------------------------------------------


#-[azregion]---------------------------------------
# (String) default Region to lable Resources in Azure | example: rg-stz-chn-k8s-0 (chn)
# default Value: chn
#azregion = ""


#-[location]---------------------------------------
# (String) default Location for Resources | example: Switzerland North
# default Value: Switzerland North
#location = ""


#-[cShortName]---------------------------------------
# (String) Contraction of Customer- or personal Name | example: rg-stz-chn-k8s-0 (stz)
# default Value: no value
cShortName = ""


#-[servicename]---------------------------------------
# (String) short Description of Service Name | example: rg-stz-chn-k8s-0 (k8s)
# default Value: k8s
servicename = "ops-test"


# Variables for Ubuntu:
#------------------------------------------------------------------------------------------------------
#-[UbuntuVMname]---------------------------------------
# (String) Virtual Machine Kubernetes Master Name | example: k8s-master-0
# default Value: k8s-master-
UbuntuVMname = "ubt-test-"

#-[UbuntuNodeCount]--------------------------------------
# (Number) Kubernetes Master Node Count | example: 2 --> 2 Ubuntu Nodes will be created
# default Value: no value
UbuntuNodeCount = 1


# Variables for RedHat Linux Enterprise:
#------------------------------------------------------------------------------------------------------
#-[RHELVMname]---------------------------------------
# (String) Virtual Machine Kubernetes Master Name | example: k8s-master-0
# default Value: k8s-master-
RHELVMname = "rhel-test-"

#-[RHELNodeCount]--------------------------------------
# (Number) Kubernetes Master Node Count | example: 2 --> 2 RHEL Nodes will be created
# default Value: no value
RHELNodeCount = 1
