module "vpc" {
    source              = "git::https://github.com/Chandu2828/terraform-aws-vpc.git?ref=master"
    project             = var.project 
    environment         = var.environment
    is_peering_required = false
}