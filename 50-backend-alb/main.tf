resource "aws_lb" "backend_alb" {
    name                = "${local.common_name}-backend-alb" # roboshop-dev-backend-alb 
    internal            = true 
    load_balancer_type  = "applicatio"
    security_groups     = [local.backend_alb_sg_id]
    subnets             = local.private_subnet_ids 

    enable_deletion_protection = true 

    tags = merge(
        {
            Name = "${local.common_name}-backend-alb"
        },
        local.common_tags 
    )
}

resource "aws_lb_listener" "http" {
    load_balancer_arn   = aws_lb.backend_alb.arn 
    port                = "80"
    protocol            = "HTTP"

    default_action {
        type = "fixed_response"

        fixed_response {
            content_type = "text/html"
            message_body = "<hi>Hi, I am HTTP Backend ALB</h1>"
            status_code = "200"
        }
    }
}

resource "aws_route53_record" "www" {
    zone_id = var.zone_id 
    name = "*.backend-alb-${var.environment}.vnmurthy.online" # *.backend-alb-dev.vnmurthy.online 
    type = "A"

    alias {
        # AWS details 
        name                    = aws_lb_backend_alb.dns_name
        zone_id                 = aws_lb_backend_alb.zone_id
        evaluate_target_health  = true
    }
    allow_overwrite = true 
}

