resource "aws_lb" "elb" {
  name               = "sharks-elb"
  subnets = local.pub_sub_ids
  security_groups = [aws_security_group.elb_sg.id]
  load_balancer_type = "application"


#   listener {
#     instance_port     = 80
#     instance_protocol = "http"
#     lb_port           = 80
#     lb_protocol       = "http"
#   }


#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "HTTP:80/index.html"
#     interval            = 30
#   }

#   instances                   = aws_instance.web.*.id
#   cross_zone_load_balancing   = true
#   idle_timeout                = 400
#   connection_draining         = true
#   connection_draining_timeout = 400

  tags = {
    Environment = terraform.workspace
  }
}

resource "aws_security_group" "elb_sg" {
    name = "elb_sg"
    description = "Allow traffic through ELB"
    vpc_id = aws_vpc.sharks_vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "elb_sg-${terraform.workspace}"
    }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "web-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.sharks_vpc.id
}

resource "aws_lb_target_group_attachment" "web_tg_attach" {
count = var.web_instance_count
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web.*.id[count.index]
  port             = 80
}