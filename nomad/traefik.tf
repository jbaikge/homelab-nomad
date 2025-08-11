resource "nomad_job" "traefik" {
  jobspec = file("${path.module}/jobs/traefik.hcl")

  hcl2 {
    vars = {
      dynamic_config = file("${path.module}/config/traefik-dynamic.yml")
      static_config = templatefile("${path.module}/config/traefik-static.yml", {
        domain = "hardwood.cloud"
      })
    }
  }
}
