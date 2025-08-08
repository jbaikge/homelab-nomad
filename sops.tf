data "sops_file" "democratic_csi_iscsi" {
  source_file = "${path.module}/nomad/config/democratic-csi-iscsi.yml"
}
