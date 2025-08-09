locals {
  copyparty = {
    name            = "copyparty"
    volume_id       = "copyparty"
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
    fs_type         = "ext4"
  }
}
resource "nomad_csi_volume" "copyparty" {
  plugin_id    = local.csi_plugin
  volume_id    = local.copyparty.volume_id
  name         = local.copyparty.name
  capacity_min = "8GiB"
  capacity_max = "8GiB"

  capability {
    access_mode     = local.copyparty.access_mode
    attachment_mode = local.copyparty.attachment_mode
  }

  mount_options {
    fs_type = local.copyparty.fs_type
  }

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [
    data.nomad_plugin.csi
  ]
}

resource "nomad_job" "copyparty" {
  jobspec = file("${path.module}/jobs/copyparty.hcl")

  hcl2 {
    vars = {
      volume_id       = local.copyparty.volume_id
      access_mode     = local.copyparty.access_mode
      attachment_mode = local.copyparty.attachment_mode
      fs_type         = local.copyparty.fs_type
      config          = file("${path.module}/config/copyparty.conf")
    }
  }

  depends_on = [
    nomad_csi_volume.copyparty
  ]
}
