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
          "--accesslog=true",
          "--api=true",
          "--api.dashboard=true",
          "--api.insecure=true",
          "--entryPoints.web.address=:80",
          "--entrypoints.web.http.redirections.entryPoint.permanent=true",
          "--entrypoints.web.http.redirections.entryPoint.scheme=https",
          "--entrypoints.web.http.redirections.entryPoint.to=websecure",
          "--entryPoints.websecure.address=:443",
          "--entryPoints.websecure.http.tls=true",
          "--log.level=INFO",
          "--metrics=true",
          "--metrics.prometheus.entryPoint=traefik",
          "--metrics.prometheus.manualrouting=true",
          "--metrics.prometheus=true",
          "--ping=true",
          "--ping.entryPoint=traefik",
          "--providers.consulcatalog=true",
          "--providers.consulcatalog.defaultRule=Host(`{{ .Name }}.hardwood.cloud`)",
          "--providers.consulcatalog.endpoint.address=http://172.17.0.1:8500",
          "--providers.consulcatalog.exposedByDefault=false",
          "--providers.consulcatalog.prefix=traefik",
        ]

        ports = [
          "http",
          "https",
          "traefik",
        ]
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
