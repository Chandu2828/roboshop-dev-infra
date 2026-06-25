module "sg" {
    count = length(var.sg_names)
    source = "git::https://github.com/Chandu2828/terraform-aws-sg.git?ref=master"
    project = var.project 
    environment = var.environment
    vpc_id = local.vpc_id 
    sg_name = replace(var.sg_names[count.index], "_", "-") 
}