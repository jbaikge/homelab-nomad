# https://github.com/democratic-csi/democratic-csi/blob/master/docs/Nomad/examples/democratic-csi-iscsi-controller.hcl
variable "csi_plugin" {
  type = string
}

variable "driver_config" {
  type = string
}

job "democratic-csi-iscsi-controller" {
  datacenters = ["*"]

  group "controller" {
    task "plugin" {
      driver = "docker"

      config {
        image = "docker.io/democraticcsi/democratic-csi:next"

        args = [
          "--csi-version=1.9.0",
          "--csi-name=${var.csi_plugin}",
          "--driver-config-file=${NOMAD_TASK_DIR}/driver-config.yml",
          "--log-level=debug",
          "--csi-mode=controller",
          "--server-socket=/csi/csi.sock",
        ]
      }

      csi_plugin {
        id        = var.csi_plugin
        type      = "controller"
        mount_dir = "/csi"
      }

      template {
        destination = "${NOMAD_TASK_DIR}/driver-config.yml"
        data        = var.driver_config
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
