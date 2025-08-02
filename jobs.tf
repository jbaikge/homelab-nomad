resource "nomad_job" "traefik" {
  jobspec = file("${path.module}/nomad/jobs/traefik.hcl")
}
resource "nomad_job" "hello_world" {
  jobspec = file("${path.module}/nomad/jobs/hello-world.hcl")
}

resource "nomad_job" "demo_webapp" {
  jobspec = file("${path.module}/nomad/jobs/demo-webapp.hcl")
}
