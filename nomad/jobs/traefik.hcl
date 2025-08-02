job "traefik" {
  type        = "service"
  region      = "global"
  datacenters = ["*"]

  group "traefik" {
    count = 1

    network {
      port "http" {
        static = 8080
      }

      port "api" {
        static = 8081
      }
    }

    service {
      name     = "traefik"
      provider = "nomad"

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "traefik" {
      driver = "docker"

      config {
        image        = "traefik:v2.2"
        network_mode = "host"

        volumes = [
          "local/traefik.toml:/etc/traefik/traefik.toml",
        ]

        template {
          destination = "local/traefik.toml"
          data        = <<-EOF
            [entryPoints]
              [entryPoints.http]
                address = ":8080"
              [entryPoints.traefik]
                address = ":8081"

            [api]
              dashboard = true
              insecure = true

            [providers.consulCatalog]
              prefix = "traefik"
              exposedByDefault = false

              [providers.consulCatalog.endpoint]
                address = "127.0.0.1:8500"
                scheme = "http"
          EOF
        }

        resources {
          cpu    = 100
          memory = 128
        }
      }
    }
  }
}
