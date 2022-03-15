resource "azurerm_windows_virtual_machine" "windows_vm" {
  count               = length(var.name)
  name                = var.name[count.index]
  location            = var.location
  resource_group_name = var.resource_group_name

  network_interface_ids = var.network_interface[count.index][*]
  size                  = var.vm_size

  availability_set_id = var.availability_set_id != "" ? var.availability_set_id : null

  # delete_os_disk_on_termination   = var.delete_os_disk_on_termination
  # delete_data_disk_on_termination = var.delete_data_disk_on_termination

  # when VM is created from Azure MarketPlace image
  dynamic "source_image_reference" {
    for_each = var.custom_image_id == "" ? [1] : []
    content {
      publisher = var.os_image.publisher
      offer     = var.os_image.offer
      sku       = var.os_image.sku
      version   = var.os_image.version
    }
  }

  dynamic "plan" {
    for_each = var.os_image.plan ? [1] : []
    content {
      publisher = var.os_image.publisher
      product   = var.os_image.offer
      name      = var.os_image.sku
    }
  }

  os_disk {
    name                 = var.name[count.index]
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
    disk_size_gb         = var.os_disk_size
  }

  computer_name  = var.name[count.index]
  admin_username = "adminuser"
  admin_password = var.password

  provision_vm_agent        = true
  patch_mode                = "Manual"
  enable_automatic_upgrades = false
  timezone                  = var.timezone

  license_type = var.hub_license_type != "" ? var.hub_license_type : null


  tags = local.vm_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disks" {
  count = length(local.vm_data_disks)

  managed_disk_id    = local.vm_data_disks[count.index].id
  virtual_machine_id = azurerm_windows_virtual_machine.windows_vm[local.vm_data_disks[count.index].vm_id].id
  lun                = local.vm_data_disks[count.index].disk_lun
  caching            = local.vm_data_disks[count.index].disk_caching
}
