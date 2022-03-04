# TERRAFORM CI/CD

![alt text](https://github.com/tanersa/terraform/blob/feature/terraform-iac/terraform.png)

<br />

&nbsp; &nbsp; Terraform is an infrastructure as code **(IAC)** Contious Deployment Stack other than Cloud Formation Template **(CFT)**. Terraform, 
differs than **CFT** because it is cloud/platform agnostic **IAC** tool.

&nbsp; &nbsp; This time we are going to provide solution for creating **Postgres Cluster** using **Terraform** and **Ansible** interconnectively. Therefore,
we are not going to use **managed PostGres** from AWS. 

We have this **main.tf** file. First, we are going to deploy our databases. DBs are going to run on VMs. In this case, we'll use **"centos-ami"**

          data "aws" "centos_ami" {
                most_recent= true
                owners= ["aws-marketplace"]
          
          }
          
Then, we create our security group,

          resource "aws_security_group" "edb-sg" {
              count= 
              name=
              description
              vpc_id=
                
             egress {
              from_port        = 0
              to_port          = 0
              protocol         = "-1". ---> means all protocols
              cidr_blocks      = ["0.0.0.0/0"]---> only for testing purposes
            }      
          }
          
Create your instance using IAC...

          provisioner "local-exec" {
              command= "echo $(self.public-ip)"   
          }
          
Whenever we configure PostGres, we will do that with ANSIBLE.

          resource "aws-instance" "EDB_DB_Cluster" {
              count= length(var.subnet_id)     
          }
          
**Note:** Length is a "loop" in terraform. Loop says, go and look how many subnets there. We define our subnets based on the number of instances.       
       
We need to give some sleep time for provisioning the infrastructure. It usually takes a long time.          
          
          provisioner "local-exec" {
              command= "sleep 60"   
          }
          
   -  ssh to instance and loop through every 60 seconds. 
   -  Create two provisioners

          provisioner "remote-exec" {
                  inline=[
                          "yum info pyhton" (Because, Ansible is built on python)
                  ]
          }
          
          provisioner "local-exec" {
                command= "ansible-playbook -i ${path.module}/..../hosts"   (use hosts file for instances) 
          }
          
There are **3 instances** created because there are **3 subnet ids.**

Then configure your ansible create your **ansible-playbook** yaml file. Here, we configure our Postgres.

We have **slaves** which are **Standby DBs**. 

And once we run terraform, it will write IPs in hosts file.

<br />

**STEPS for TERRAFORM:**

   -  Initialize Terraform

          terraform init   
          
   -  Dry Run Terraform (To see resources created)

          terraform plan 
          
   -  Create instances and bring up the cluster, deploying Terraform
      
        terraform apply        

Now, go to EC2 on AWS Console and see Postgress instances are getting initialized. 

There should be **1 Master** and **2 Standbys**

And if you go to hosts file, **3 IPs are added.**






        
           
                


























          
          
          
          
          
          
          

