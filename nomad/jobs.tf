resource "nomad_job" "democratic_csi_iscsi_controller" {
  jobspec = file("${path.module}/jobs/democratic-csi-iscsi-controller.hcl")

  hcl2 {
    vars = {
      "driver_config" = data.sops_file.democratic_csi_iscsi.raw
    }
  }
}

resource "nomad_job" "democratic_csi_iscsi_node" {
  jobspec = file("${path.module}/jobs/democratic-csi-iscsi-node.hcl")

  hcl2 {
    vars = {
      "driver_config" = data.sops_file.democratic_csi_iscsi.raw
    }
  }
}

resource "nomad_job" "traefik" {
  jobspec = file("${path.module}/jobs/traefik.hcl")
}

resource "nomad_job" "hello_world" {
  jobspec = file("${path.module}/jobs/hello-world.hcl")
}

resource "nomad_job" "demo_webapp" {
  jobspec = file("${path.module}/jobs/demo-webapp.hcl")
}
