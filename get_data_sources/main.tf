terraform {
  required_version = ">= 0.8, <= 0.11.7"
}

provider "aws" {
  region = "us-east-2"
}

#
# Get all Availability Zones
#
data "aws_availability_zones" "all" {}

output "azs" {
  value = "${data.aws_availability_zones.all.names}"
}

#
# Get All available VPCs
#
data "aws_vpcs" "vpcs" {}

output "vpcs" {
  value = "${data.aws_vpcs.vpcs.ids}"
}

#
# Get EBS Snapshots Information
#
data "aws_ebs_snapshot" "ebs_volume" {
  most_recent = true
  owners      = ["self"]
}

output "my_snapshots" {
  value = "${data.aws_ebs_snapshot.ebs_volume.snapshot_id}"
}

#
# Get IAM Groups
#
data "aws_iam_group" "group" {
  group_name = "operators"
}

output "iam_group" {
  value = "${data.aws_iam_group.group.arn} ${data.aws_iam_group.group.group_id}"
}

#
# Get IAM Users
#
data "aws_iam_user" "user" {
  user_name = "Bob"
}

output "iam_user" {
  value = "${data.aws_iam_user.user.arn} ${data.aws_iam_user.user.user_id}"
}
