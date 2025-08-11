# https://valeriansaliou.name/blog/ssl-certificates-nomad-certbot/

locals {
  certs = {
    name            = "certs"
    volume_id       = "certs"
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
    fs_type         = "ext4"
    size            = "32MiB"
  }
}

data "sops_file" "certbot" {
  source_file = "${path.module}/config/certbot.yml"
}

resource "nomad_csi_volume" "certs" {
  plugin_id    = local.csi_plugin
  volume_id    = local.certs.volume_id
  name         = local.certs.name
  capacity_min = local.certs.size
  capacity_max = local.certs.size

  capability {
    access_mode     = local.certs.access_mode
    attachment_mode = local.certs.attachment_mode
  }

  mount_options {
    fs_type = local.certs.fs_type
  }

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [
    data.nomad_plugin.csi
  ]
}

# resource "nomad_acl_policy" "certs_certbot" {
#   name        = "certs-certbot"
#   description = "Write permissions to store the certificate from certbot"
#   rules_hcl   = file("${path.module}/policies/certs-certbot.hcl")
# }

# resource "nomad_acl_policy" "certs_user" {
#   name        = "certs-user"
#   description = "Read permissions to get the certificate from certbot"
#   rules_hcl   = file("${path.module}/policies/certs-user.hcl")
# }

# resource "nomad_acl_token" "letsencrypt" {
#   name = "LetsEncrypt (certbot)"
#   type = "client"

#   policies = [
#     "certs-certbot"
#   ]

#   depends_on = [
#     nomad_acl_policy.certs_certbot,
#   ]
# }

# resource "nomad_variable" "certbot_token" {
#   path = "nomad/jobs/certbot"

#   items = {
#     "NOMAD_TOKEN" = nomad_acl_token.letsencrypt.secret_id
#   }
# }

resource "nomad_job" "certbot" {
  jobspec = file("${path.module}/jobs/certbot.hcl")

  hcl2 {
    vars = {
      volume_id           = local.certs.volume_id
      access_mode         = local.certs.access_mode
      attachment_mode     = local.certs.attachment_mode
      fs_type             = local.certs.fs_type
      domain              = data.sops_file.certbot.data["domain"]
      email               = data.sops_file.certbot.data["email"]
      entrypoint_script   = file("${path.module}/scripts/certbot-entrypoint.sh")
      update_certs_script = file("${path.module}/scripts/certbot-update-certs.sh")
      secret_env_vars     = file("${path.module}/config/certbot-secrets.env")
    }
  }

  depends_on = [
    # nomad_acl_policy.certs_certbot,
    nomad_csi_volume.certs,
    # nomad_variable.certbot_token,
    nomad_variable.aws_credentials,
  ]
}

