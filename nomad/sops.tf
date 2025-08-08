data "sops_file" "democratic_csi_iscsi" {
  source_file = "${path.module}/config/democratic-csi-iscsi.yml"
}
