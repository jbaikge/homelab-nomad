# https://github.com/democratic-csi/democratic-csi/blob/master/docs/Nomad/examples/democratic-csi-iscsi-controller.hcl
job "democratic-csi-iscsi-controller" {
  datacenters = ["*"]

  group "controller" {
    task "plugin" {
      driver = "docker"

      config {
        image = "docker.io/democraticcsi/democratic-csi:next"

        args = [
          "--csi-version=1.9.0",
          "--csi-name=org.democratic-csi.iscsi",
          "--driver-config-file=$${NOMAD_TASK_DIR}/driver-config.yml",
          "--log-level=verbose",
          "--csi-mode=controller",
          "--server-socket=/csi/csi.sock",
        ]
      }

      csi_plugin {
        id        = "org.democratic-csi.iscsi"
        type      = "controller"
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
