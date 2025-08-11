variable "dynamic_config" {
  type = string
}

variable "static_config" {
  type = string
}

job "traefik" {
  type        = "system"
  region      = "global"
  datacenters = ["*"]

  update {
    max_parallel = 1
    stagger      = "1m"
    auto_revert  = true
  }

  group "traefik" {
    network {
      port "http" {
        static = 80
      }

      port "https" {
        static = 443
      }

      port "traefik" {
        static = 8080
      }
    }

    service {
      name = "traefik"
      port = "https"
      tags = [
        # "traefik.enable=true",
        # "traefik.http.routers.api.rule=Host(`api.hardwood.cloud`)",
        # "traefik.http.routers.api.service=api@internal",
      ]

      check {
        name     = "alive"
        type     = "http"
        port     = "traefik"
        path     = "/ping"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "traefik" {
      driver = "docker"

      config {
        image = "traefik:3"

        args = [
        ]

        ports = [
          "http",
          "https",
          "traefik",
        ]

        mount {
          type   = "bind"
          source = "local/traefik"
          target = "/etc/traefik"
        }
      }

      template {
        destination     = "local/traefik/traefik.yml"
        left_delimiter  = "{$"
        right_delimiter = "$}"
        data            = var.static_config
      }

      template {
        destination = "local/traefik/dynamic/traefik.yml"
        data        = var.dynamic_config
      }

      template {
        destination   = "local/traefik/certs/traefik.key"
        change_mode   = "signal"
        change_signal = "SIGHUP"

        data = <<-EOH
        {{ with nomadVar "certs/traefik" }}{{ .KEY }}{{ end }}
        EOH
      }

      template {
        destination   = "local/traefik/certs/traefik.crt"
        change_mode   = "signal"
        change_signal = "SIGHUP"

        data = <<-EOH
        {{ with nomadVar "certs/traefik" }}{{ .CERTIFICATE }}{{ end }}
        EOH
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
