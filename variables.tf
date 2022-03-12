variable "name" {
  description = "Name of the Virtual Machine."
  type        = string
}

variable "location" {
  description = "Region where the VM is deployed."
  type        = string
}

variable "resource_group_name" {
  description = "Name of resource group into which VM is deployed."
  type        = string
}

variable "vm_size" {
  description = "Size of VM to be deployed."
  type        = string
}

variable "network_interface" {
  description = "List of the network interface IDs to be attached VM."
  type        = list(string)
}

variable "required_tags" {
  description = "Optional - tags to apply on resource"
  type = object({
    Environment       = string
    Deployment        = string
    Environment_Owner = string
    RepositoryURL     = string
    Infrastructure    = string
    Division          = string
    CostCentre        = string
  })
}

######
## Other Variables
######

variable "availability_set_id" {
  description = "(Optional) The ID of the availablity set in which the VM should exist"
  type        = string
  default     = ""
}

variable "data_disk" {
  description = "(Optional) Details of the pre-created managed data disks attached to VM. A list of objects containing disk ID, lun, and caching settings."
  type = list(object({
    id      = string
    lun     = number
    caching = string
  }))
  default = []
}

variable "delete_os_disk_on_termination" {
  description = "Should the OS Disk be deleted when VM is destroyed? Default to false."
  type        = bool
  default     = false
}

variable "delete_data_disk_on_termination" {
  description = "Should this Data Disk to be deleted when VM is destroyed? Default to false."
  type        = bool
  default     = false
}

variable "custom_image_id" {
  description = "(Optional) Specifies custom image ID if VM is going to be created from a custom image."
  type        = string
  default     = ""
}

variable "os_disk_type" {
  description = "Operating System disk type. Defaults to Standard_LRS"
  type        = string
  default     = "Standard_LRS"
}

variable "os_disk_size" {
  description = "(Optional) Operating System disk Size. Defaults to null."
  type        = number
  default     = null
}

variable "os_image" {
  description = "Details of the image to be used to provision on the VM"
  type        = map(string)
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

variable "osdisk_create_option" {
  default = "FromImage"
}

variable "password" {
  description = "Password of the VM"
  type        = string
}

variable "timezone" {
  description = "Specifies the timezone of VM. Defaults to 'AEST'."
  type        = string
  default     = "AUS Eastern Standard Time"
}

variable "optional_tags" {
  description = "(Optional) List of additional tags to applied to VM."
  type        = map(string)
  default     = {}
}

variable "power_management_tags" {
  description = "(Optional) Power management tags for start-up and shutdown"
  type = object({
    VM_StartTime = string
    VM_StopTime  = string
  })
  default = {
    VM_StartTime = ""
    VM_StopTime  = ""
  }
}
