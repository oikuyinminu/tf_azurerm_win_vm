locals {
  tags    = var.optional_tags != "" ? merge(var.required_tags, var.optional_tags) : var.required_tags
  vm_tags = var.power_management_tags.VM_StartTime != "" ? merge(local.tags, var.power_management_tags) : local.tags

  ########
  #Static Mapping of ENV and Regions
  ########
  env = {
    "production"    = "PRD"
    "preproduction" = "PPD"
    "development"   = "DEV"
    "test"          = "TST"
  }

  reg = {
    "eastus"  = "EUS1"
    "eastus2" = "EUS2"
  }

  vm_data_disks = flatten([for vms, disks in zipmap(range(length(var.data_disks)), var.data_disks) : [
    for disk in disks : {
      vm_id        = vms
      disk_id      = disk.id
      disk_caching = disk.caching
      disk_lun     = disk.lun
      disk_type    = disk.type
    }]
  ])

}
