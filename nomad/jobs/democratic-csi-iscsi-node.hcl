job "democratic-csi-iscsi-node" {
  datacenters = ["*"]
  type        = "system"

  group "node" {
    task "node" {
      driver = "docker"

      config {
        image      = "democraticcsi/democratic-csi:next"
        privileged = true

        args = [
          "--csi-version=1.9.0",
          "--csi-name=org.democratic-csi.iscsi",
          "--driver-config-file=$${NOMAD_TASK_DIR}/driver-config.yml",
          "--log-level=verbose",
          "--csi-mode=node",
          "--server-socket=/csi/csi.sock",
        ]
      }

      csi_plugin {
        id        = "org.democratic-csi.iscsi"
        type      = "node"
        mount_dir = "/csi"
      }

      template {
        destination = "$${NOMAD_TASK_DIR}/driver-config.yml"

        data = <<EOF
${driver_config}
EOF
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
