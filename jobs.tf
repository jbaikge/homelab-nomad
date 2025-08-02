resource "nomad_job" "hello_world" {
  jobspec = file("${path.module}/nomad/jobs/hello-world.hcl")
}
