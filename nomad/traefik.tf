resource "nomad_job" "traefik" {
  jobspec = file("${path.module}/jobs/traefik.hcl")
}
