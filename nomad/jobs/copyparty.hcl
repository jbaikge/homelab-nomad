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

variable "config" {
  type = string
}

job "copyparty" {
  datacenters = ["*"]

  group "copyparty" {
    count = 1

    network {
      port "http" {
        to = 3923
      }
    }

    service {
      name = "copyparty"
      port = "http"

      tags = [
        "traefik.enable=true",
      ]

      check {
        type     = "http"
        path     = "/?reset=/._"
        interval = "1m"
        timeout  = "2s"
      }
    }

    volume "copyparty" {
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

    task "server" {
      driver = "docker"

      config {
        image = "ghcr.io/9001/copyparty-ac"
        args  = ["-c", "${NOMAD_TASK_DIR}/copyparty.conf"]
        ports = ["http"]
      }

      volume_mount {
        volume      = "copyparty"
        destination = "/w"
        read_only   = false
      }


      template {
        destination = "${NOMAD_TASK_DIR}/copyparty.conf"
        data        = var.config
      }

      resources {
        cpu    = 100
        memory = 256
      }
    }
  }
}
