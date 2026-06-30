data "aws_ssm_parameter" "catalogue_sg_id" {
    name = "/${var.project}/${var.environment}/catalogue_sg_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
    name = "/${var.project}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ami" "joindevops" {
    most_recent = true 
    owners      = ["973714476881"]

    filter {
        name = "name"
        vlaues = ["Redhat-9-DevOps-Practice"]
    }

    filter {
        name = "root-device-type"
        value = ["ebs"]
    }

    filter {
        name = "virtualization-type"
        value = ["hvm"]
    }

    filter {
        name = "architecture"
        value = ["x86_64"]
    }
}