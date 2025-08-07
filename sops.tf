data "sops_file" "democratic_csi_iscsi_controller" {
  source_file = "${path.module}/nomad/config/democratic-csi-iscsi-controller.yml"
}
