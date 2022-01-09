locals {
    env_tag = {
        Environment = terraform.workspace
    }
    web_tags = merge(var.web_instance_tag, local.env_tag)

}

resource "aws_instance" "web" {
    ami = var.web_amis[var.aws_region]
    instance_type = var.web_instance_type
    count = var.web_instance_count
    subnet_id = local.pub_sub_ids[count.index]
    iam_instance_profile = aws_iam_instance_profile.s3_ec2_profile.name
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    user_data = file("scripts/apache.sh")


    tags = local.web_tags
    
}

resource "aws_security_group" "web_sg" {
    name = "web_sg"
    description = "Allow traffic"
    vpc_id = aws_vpc.sharks_vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "web_sg"
    }


}