resource "aws_ebs_volume" "ebs" {
  availability_zone = var.availability_zone
  size              = var.size
  count             = var.ebs_count
  type              = var.type
  encrypted         = var.encrypted
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = join("\",\"", aws_ebs_volume.ebs.*.id)
  instance_id = var.instance_id
  count       = var.ebs_count
}