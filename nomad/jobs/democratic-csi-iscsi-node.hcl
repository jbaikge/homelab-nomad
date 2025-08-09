# https://github.com/democratic-csi/democratic-csi/issues/111
#
# important parts:
# - ipc_mode = "host"
# - explicitly mounting / to /host
variable "csi_plugin" {
  type = string
}

variable "driver_config" {
  type = string
}

job "democratic-csi-iscsi-node" {
  datacenters = ["*"]
  type        = "system"

  group "node" {
    task "node" {
      driver = "docker"

      config {
        image        = "democraticcsi/democratic-csi:next"
        privileged   = true
        network_mode = "host"
        ipc_mode     = "host"

        args = [
          "--csi-version=1.9.0",
          "--csi-name=${var.csi_plugin}",
          "--driver-config-file=${NOMAD_TASK_DIR}/driver-config.yml",
          "--log-level=debug",
          "--csi-mode=node",
          "--server-socket=/csi/csi.sock",
        ]

        mount {
          type     = "bind"
          target   = "/host"
          source   = "/"
          readonly = false
        }
      }

      csi_plugin {
        id        = var.csi_plugin
        type      = "node"
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
