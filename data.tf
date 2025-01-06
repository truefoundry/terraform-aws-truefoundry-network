data "aws_subnet" "private_subnets" {
  count = var.shim ? length(var.private_subnets_ids) : 0

  id = element(var.private_subnets_ids, count.index)
}

data "aws_subnet" "public_subnets" {
  count = var.shim ? length(var.public_subnets_ids) : 0

  id = element(var.public_subnets_ids, count.index)
}
