variable "aws_region" {
  default = "us-east-2"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "tenancy" {
  default = "default"
}

variable "web_amis" {
  type        = map
  description = "Used for nat instances"
  default     =  {
      us-east-1 = "ami-0ed9277fb7eb570c9"
      us-east-2 = "ami-002068ed284fb165b"
  }
}

variable "web_instance_type" {
  type        = string
  description = "Used for nat instances types"
  default     = "t2.micro"
}

variable "web_instance_count" {
type        = string
  description = "Number of instances"
  default     = "2"
}

variable "web_instance_tag" {
 type        = map
  description = "instance names"
  default     = {
      Name = "webserver"
  }
}

variable "s3_bucket" {
  type = string 
  default = "sharks-s3-bucket-12345"
}

variable "subnet_cidr_block" {
  type        = string
  description = "Used for public subnets"
  default     = "10.0.1.0/24"
}
