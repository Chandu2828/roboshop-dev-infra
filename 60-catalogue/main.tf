#Executes first 
resource "aws_instance" "catalogue" {
    ami                     = local.ami_id 
    instance_type           = "t3.micro"
    vpc_security_group_ids  = [local.catalogue_sg_id]
    subnet_id               = local.private_subnet_id 
    tags = merge(
        {
            Name = "${local.common_name}-catalogue"
        },
        local.common_tags 
    )
}

# Executes second 
resource "terraform_data" "catalogue" {
    triggers_replace = [
        aws_instance.catalogue.id 
    ]

    connection {
        type        = "ssh"
        user        = "ec2-user"
        password    = "DevOps321"
        host        = aws_instance.catalogue.private_ip 
    }

    provisioner "file" {
        source      = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh catalogue ${var.environment} ${var.app_version}"
        ]
    }
}

# Executes third 

resource "aws_ec2_instance_state" "catalogue"{
    instance_id = aws_instance.catalogue.id 
    state       = "stopped"
    depends_on  = [terraform_data.catalogue]
}

# depends_on specified that task3 should execute only after task1

resource "aws_ami_from_instance" "catalogue" {
    name = "${local.common_name}-catalogue-${var.app_version}-${aws_instance.catalogue.id}" # roboshop-dev-catalogue-v3-<instance_id_of_catalogue_server>
    source_instance_id = aws_instance.catalogue.id 
    depends_on = [aws_ec2_instance_state.catalogue]
    tags = merge(
        {
            Name = "${local.common_name}-catalogue-${var.app_version}-${aws_instance.catalogue.id}"
        },
        local.common_tags 
    )
}

resource "aws_launch_template" "catalogue" {
    name = "${local.common_name}-datalogue"
    image_id = aws_ami_from_instance.catalogue.id # AMI ID
    instance_initiated_shutdown_behavior = "terminate"
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.catalogue_sg_id]
    update_default_version = true 

    # Once the instanced are created, these will become instace tags
    tag_specifications {
        resource_type = "instance"

        tags = merge(
            {
                Name = "${local.common_name}-catalogue-${var.app_version}-${aws_instance.catalogue.id}"
            },
            local.common_tags 
        )
    }

    # Once the instances are created, these will become volume tags
    tag_specifications {
        resource_type = "volume"

        tags = merge(
            {
                Name = "${local.common_name}-catalogue-${var.app_version}-${aws_instance.catalogue.id}"
            },
            local.common_tags 
        )
    }

    # Launch template resource tags
    tags = merge(
        {
            Name = "${local.common_name}-catalogue-${var.app_version}-${aws_instance.catalogue.id}"
        },
        local.common_tags 
    )
}

resource "aws_lb_target_group" "catalogue" {
    name = "${local.common_name}-catalogue"
    port = 8080
    protocol = "HTTP"
    vpc_id = local.vpc_id 
    deregistration_delay = 30 

    health_check {
        healthy_threshold   = 2
        interval            = 10
        matcher             = "200-299"
        path                = "/health"
        port                = 8080
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
    }
}
