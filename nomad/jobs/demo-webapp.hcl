job "demo-webapp" {
  datacenters = ["*"]

  group "demo" {
    count = 1

    network {
      port "http" {
        to = -1
      }
    }

    service {
      name     = "demo-webapp"
      provider = "nomad"
      port     = "http"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.http.rule=Path(`/myapp`)",
      ]

      check {
        type     = "http"
        path     = "/"
        interval = "2s"
        timeout  = "2s"
      }
    }

    task "server" {
      driver = "docker"

      config {
        image = "hashicorp/demo-webapp-lb-guide"
        ports = ["http"]
      }

      env {
        PORT    = NOMAD_PORT_http
        NODE_IP = NOMAD_IP_http
      }
    }
  }
}
