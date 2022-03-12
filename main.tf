resource "azurerm_virtual_machine" "windows_vm" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group.name

  network_interface_ids        = var.network_interface[*]
  primary_network_interface_id = var.network_interface[0]

  vm_size = var.vm_size

  availability_set_id = var.availability_set_id != "" ? var.availability_set_id : null

  delete_os_disk_on_termination    = var.delete_os_disk_on_termination
  delete_data_disks_on_termination = var.delete_data_disks_on_termination

  # when VM is created from Azure MarketPlace image
  dynamic "storage_image_reference" {
    for_each = var.custom_image_id == "" ? [1] : []
    content {
      publisher = var.os_image.publisher
      offer     = var.os_image.offer
      sku       = var.os_image.sku
      version   = var.os_image.version
    }
  }
  
  storage_os_disk {
    name              = var.name
    caching           = "ReadWrite"
    create_option     = var.osdisk_create_option
    managed_disk_type = var.os_disk_type
    disk_size_gb      = var.os_disk_size
  }

  os_profile {
    computer_name  = var.name
    admin_username = "adminuser"
    admin_password = var.password
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false
    timezone                  = var.timezone
  }

  tags = local.vm_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk" {
  count = length(var.data_disk)

  managed_disk_id    = var.data_disk[count.index].id
  virtual_machine_id = azurerm_virtual_machine.windows_vm.id
  lun                = var.data_disk[count.index].lun
  caching            = var.data_disk[count.index].caching
}
