locals {
    tags = var.optional_tags != "" ? merge(var.required_tags, var.optional_tags) : var.required_tags
    vm_tags = var.power_management_tags.VM_StartTime != "" ? merge(local.tags, var.power_management_tags) : local.tags

  ########
  #Static Mapping of ENV and Regions
  ########
  env = {
      production = "PRD"
      preproduction = "PPD"
      development = "DEV"
      test = "TST"
  }

  region = {
      eastus = "EUS1"
      eastus2 = "EUS2"
  }

}
