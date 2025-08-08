locals {
  csi_plugin = "org.democratic-csi.iscsi"
}

data "nomad_plugin" "csi" {
  plugin_id        = local.csi_plugin
  wait_for_healthy = true
}

resource "nomad_job" "democratic_csi_iscsi_controller" {
  jobspec = file("${path.module}/jobs/democratic-csi-iscsi-controller.hcl")

  hcl2 {
    vars = {
      csi_plugin    = local.csi_plugin
      driver_config = data.sops_file.democratic_csi_iscsi.raw
    }
  }
}

resource "nomad_job" "democratic_csi_iscsi_node" {
  jobspec = file("${path.module}/jobs/democratic-csi-iscsi-node.hcl")

  hcl2 {
    vars = {
      csi_plugin    = local.csi_plugin
      driver_config = data.sops_file.democratic_csi_iscsi.raw
    }
  }
}
