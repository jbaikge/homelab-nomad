variable "volume_id" {
  type = string
}

variable "attachment_mode" {
  type = string
}

variable "access_mode" {
  type = string
}

variable "fs_type" {
  type = string
}

variable "domain" {
  type = string
}

variable "email" {
  type = string
}

variable "entrypoint_script" {
  type = string
}

variable "update_certs_script" {
  type = string
}

variable "secret_env_vars" {
  type = string
}

job "certbot" {
  type = "batch"

  periodic {
    time_zone        = "America/New_York"
    prohibit_overlap = true

    crons = [
      "0 12 */3 * *",
    ]
  }

  reschedule {
    attempts = 0
  }

  group "certbot" {
    restart {
      attempts = 0
      mode     = "fail"
    }

    volume "certs" {
      type            = "csi"
      source          = var.volume_id
      read_only       = false
      attachment_mode = var.attachment_mode
      access_mode     = var.access_mode
      per_alloc       = false

      mount_options {
        fs_type     = var.fs_type
        mount_flags = ["noatime"]
      }
    }

    task "certbot" {
      driver = "docker"

      config {
        image = "certbot/dns-route53:v4.2.0"

        entrypoint = [
          "sh",
          "/usr/local/bin/entrypoint.sh",
        ]

        extra_hosts = [
          "host.docker.internal:host-gateway",
        ]

        mount {
          type     = "bind"
          target   = "/host"
          source   = "/"
          readonly = true
        }

        mount {
          type   = "bind"
          source = "local/entrypoint.sh"
          target = "/usr/local/bin/entrypoint.sh"
        }

        mount {
          type   = "bind"
          source = "local/renewal-hooks"
          target = "/etc/letsencrypt/renewal-hooks"
        }
      }

      env {
        DOMAIN     = var.domain
        EMAIL      = var.email
        NOMAD_ADDR = "http://172.17.0.1:4646" # Docker router
      }

      template {
        destination = "secrets/file.env"
        data        = var.secret_env_vars
        env         = true
      }

      template {
        destination = "local/entrypoint.sh"
        data        = var.entrypoint_script
        perms       = 0755
      }

      template {
        destination = "local/renewal-hooks/deploy/update-certs.sh"
        data        = var.update_certs_script
        perms       = 0755
      }

      volume_mount {
        volume      = "certs"
        destination = "/etc/letsencrypt"
        read_only   = false
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
