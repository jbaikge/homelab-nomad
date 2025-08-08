locals {
  csi_plugin = "org.democratic-csi.iscsi"
}

data "nomad_plugin" "csi" {
  plugin_id        = local.csi_plugin
  wait_for_healthy = true
}

resource "nomad_csi_volume" "test_volume" {
  plugin_id = local.csi_plugin
  volume_id = "test-volume"
  # Name can only contain lowercase alphanumeric charactersplus dot (.), dash (-), and colon (:)
  name         = "test-volume"
  capacity_min = "8GiB"
  capacity_max = "8GiB"

  capability {
    access_mode     = "multi-node-single-writer"
    attachment_mode = "file-system"
  }

  mount_options {
    fs_type = "ext4"
  }

  lifecycle {
    prevent_destroy = false
  }
  depends_on = [
    data.nomad_plugin.csi
  ]
}
