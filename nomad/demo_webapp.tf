resource "nomad_job" "demo_webapp" {
  jobspec = file("${path.module}/jobs/demo-webapp.hcl")
}
