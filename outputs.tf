output "demo_volume_id" {
  value = aws_ebs_volume.demo.id
}

output "demo_snapshot_id" {
  value = aws_ebs_snapshot.demo.id
}

output "recycle_bin_rule_arn" {
  value = aws_rbin_rule.snapshots_by_tag.arn
}
