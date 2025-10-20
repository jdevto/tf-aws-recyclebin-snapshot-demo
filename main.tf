# ----------------------------
# Demo EBS volume and snapshot (tagged for protection)
# ----------------------------
resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_ebs_volume" "demo" {
  availability_zone = var.availability_zone
  size              = 8
  type              = "gp3"

  tags = merge(local.tags, {
    Name = "demo-vol-${random_id.suffix.hex}"
  })
}

# This snapshot is tagged with the key/value that the Recycle Bin rule will match
resource "aws_ebs_snapshot" "demo" {
  volume_id = aws_ebs_volume.demo.id
  tags = merge(local.tags, {
    Name                   = "demo-snap-${random_id.suffix.hex}"
    (var.snapshot_tag_key) = var.snapshot_tag_value
  })
}

# ----------------------------
# Recycle Bin rule for EBS snapshots with matching tags
# Any future snapshot deletion with these tags goes to Recycle Bin
# ----------------------------
resource "aws_rbin_rule" "snapshots_by_tag" {
  description   = "Protect EBS snapshots tagged ${var.snapshot_tag_key}=${var.snapshot_tag_value}"
  resource_type = "EBS_SNAPSHOT"

  # Match snapshots by tag key/value
  resource_tags {
    resource_tag_key   = var.snapshot_tag_key
    resource_tag_value = var.snapshot_tag_value
  }

  retention_period {
    retention_period_value = var.retention_days
    retention_period_unit  = "DAYS"
  }

  # Optional: lock the rule so it cannot be changed for a while
  lock_configuration {
    unlock_delay {
      unlock_delay_value = 7
      unlock_delay_unit  = "DAYS"
    }
  }

  tags = local.tags
}
