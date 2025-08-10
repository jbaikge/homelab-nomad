data "sops_file" "aws" {
  source_file = "${path.module}/config/aws.yml"
}

resource "nomad_variable" "aws_credentials" {
  path = "credentials/aws"

  items = {
    "ACCESS_KEY_ID"     = data.sops_file.aws.data["access_key_id"]
    "SECRET_ACCESS_KEY" = data.sops_file.aws.data["secret_access_key"]
  }
}

