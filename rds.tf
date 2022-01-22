resource "aws_db_instance" "sharks" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "sharks"
  password             = "Admin4321"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  auto_minor_version_upgrade = false
  db_subnet_group_name = aws_db_subnet_group.sharks.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_db_subnet_group" "sharks" {
  name       = "sharks-rds"
  subnet_ids = aws_subnet.sharks_private_subnet.*.id

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "rds_sg" {
    name = "rds_sg"
    description = "Allow traffic for RDS MySQL"
    vpc_id = aws_vpc.sharks_vpc.id

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.web_sg.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "rds_sg-${terraform.workspace}"
    }
}
