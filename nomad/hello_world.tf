resource "nomad_job" "hello_world" {
  jobspec = file("${path.module}/jobs/hello-world.hcl")
}
