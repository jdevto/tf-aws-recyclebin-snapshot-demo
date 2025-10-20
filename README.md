# AWS Recycle Bin EBS Snapshot Demo

This Terraform demo implements **option C**: tag EBS snapshots and apply an AWS Recycle Bin retention rule that catches any EBS snapshot with those tags so accidental deletes are retained for N days. No IAM changes required.

## What it creates

- **EBS Volume**: 8GB gp3 volume for demo purposes
- **EBS Snapshot**: Tagged with `Compliance=Daily` (configurable)
- **Recycle Bin Rule**: Retains deleted snapshots with matching tags for 35 days (configurable)

## Usage

1. **Initialize and apply**:

   ```bash
   terraform init
   terraform apply
   ```

2. **Test Recycle Bin protection**:

   ```bash
   # Delete the snapshot (it will be retained in Recycle Bin)
   terraform destroy -target=aws_ebs_snapshot.demo

   # Check AWS Console → Recycle Bin → Retained resources
   # The snapshot should appear there for the retention period
   ```

3. **Clean up**:

   ```bash
   terraform destroy
   # Note: Snapshots may still be retained in Recycle Bin until retention period expires
   # Manually purge from Recycle Bin console if needed
   ```

## Configuration

Override defaults via variables:

```bash
terraform apply \
  -var="region=ap-southeast-2" \
  -var="availability_zone=ap-southeast-2a" \
  -var="snapshot_tag_key=Backup" \
  -var="snapshot_tag_value=Daily" \
  -var="retention_days=7"
```

## Important Notes

- **Region-specific**: Recycle Bin rules only apply within the same AWS region
- **Tag matching**: Snapshots must have the exact tag key/value at deletion time
- **Propagation delay**: New rules may take a few minutes to become effective
- **Cleanup**: `terraform destroy` removes resources but retained snapshots persist in Recycle Bin until retention period expires
