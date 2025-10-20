variable "availability_zone" {
  type        = string
  description = "AZ for demo volume"
  default     = "ap-southeast-2a"
}

# Tag that flags snapshots for Recycle Bin protection
variable "snapshot_tag_key" {
  type    = string
  default = "Compliance"
}

variable "snapshot_tag_value" {
  type    = string
  default = "Daily"
}

# How long to retain deleted snapshots in Recycle Bin
variable "retention_days" {
  type    = number
  default = 35
}
