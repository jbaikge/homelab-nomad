# https://github.com/democratic-csi/democratic-csi/blob/master/docs/Nomad/examples/democratic-csi-iscsi-controller.hcl
job "democratic-csi-iscsi-controller" {
  datacenters = ["*"]

  group "controller" {
    task "plugin" {
      driver = "docker"

      config {
        image = "docker.io/democraticcsi/democratic-csi:latest"

        args = [
          "--csi-version=1.5.0",
          "--csi-name=org.democratic-csi.iscsi",
          "--driver-config-file=$${NOMAD_TASK_DIR}/driver-config.yml",
          "--log-level=debug",
          "--csi-mode=controller",
          "--server-socket=/csi-data/csi.sock",
        ]
      }

      csi_plugin {
        id        = "org.democratic-csi.iscsi"
        type      = "controller"
        mount_dir = "/csi"
      }

      template {
        destination = "$${NOMAD_TASK_DIR}/driver-config.yml"

        data = driver_config
      }

      resources {
        cpu    = 30
        memory = 50
      }
    }
  }
}
