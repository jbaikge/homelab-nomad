resource "nomad_job" "democratic_csi_iscsi_controller" {
  jobspec = templatefile("${path.module}/nomad/jobs/democratic-csi-iscsi-controller.hcl", {
    driver_config = data.sops_file.democratic_csi_iscsi_controller.raw
  })
}

resource "nomad_job" "traefik" {
  jobspec = file("${path.module}/nomad/jobs/traefik.hcl")
}

resource "nomad_job" "hello_world" {
  jobspec = file("${path.module}/nomad/jobs/hello-world.hcl")
}

resource "nomad_job" "demo_webapp" {
  jobspec = file("${path.module}/nomad/jobs/demo-webapp.hcl")
}
