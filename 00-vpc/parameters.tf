resource "aws_ssm_parameter" "vpc_id" {
    name        = "/${var.project}/${var.environment}/vpc_id"
    type        = "String"
    value       = module.vpc.vpc_id 
    overwrite   = true 
}

resource "aws_ssm_parameter" "public_subnet_ids" {
    name = "/${var.project}/${var.environment}/public_subnet_ids"
    type = "String"
    value = join(",", module.vpc.public_subnet_ids) # because the value is list(tuple) but it expects as a string 
    overwrite = true 
}