# Terraform for AWS Infrastructure
## Overview
The project uses Terraform to provision AWS infrastructure. The key components include VPC, EC2 instances, security groups, CloudWatch for monitoring, and an SNS topic for alarm notifications.

![2024-12-29 03_55_25-Cloud DevOps Accelerator - Hands-On pdf and 8 more pages - School - Microsoft_ E-Photoroom](https://github.com/user-attachments/assets/eff67d9d-dec4-4cd2-b2f2-872599489483)

## 1. Remote Backend for Terraform State
The Terraform state is managed remotely using an S3 bucket for storage and DynamoDB for state locking. This ensures that multiple users or systems can collaborate on the infrastructure management without conflicts.
```hcl
backend "s3" {
    bucket         = "ivolve-project-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ivolve-project-tb"
  }
 ```

![2024-12-28 22_04_00-ivolve-project-tfstate - S3 bucket _ S3 _ us-east-1](https://github.com/user-attachments/assets/f924259f-c5ce-4205-8f29-9e905c7cf0f8)


### 2. VPC Module
- **Purpose**: To create a Virtual Private Cloud (VPC) with a single public subnet.
- **Configuration**:
  
  ```hcl
  module "vpc" {
    source        = "./modules/vpc"
    vpc_name      = "ivolve"
    cidr_block    = "10.0.0.0/16"
    public_subnets = ["10.0.1.0/24"]
  }
  ```
![chrome-capture (61)](https://github.com/user-attachments/assets/877d6184-542a-4305-afaa-24f49fd85e09)

### 3. EC2 Instances
- **Purpose**: To deploy two EC2 instances (Master and Slave) in the VPC.
- **Local Variable for Instances**:
  
  ```hcl
  locals {
    instances = {
      Master = {
        name         = "Master"
        instance_type = "t3.micro"
      }
      Slave = {
        name         = "Slave"
        instance_type = "t3.medium"
      }
    }
  }
  ```
- **Module Configuration**:
  
  ```hcl
  module "ec2_instance" {
    for_each                        = local.instances
    source                          = "./modules/Ec2"
    ami_id                          = "ami-0e2c8caa4b6378d8c"
    instance_type                   = each.value.instance_type
    subnet_id                       = module.vpc.public_subnets[0]
    key_name                        = "Ec2Key"
    instance_name                   = each.value.name
    security_groups_id              = aws_security_group.ec2_sg.id
    associate_public_ip_address     = true
  }
  ```
![chrome-capture (60)](https://github.com/user-attachments/assets/5d4172c4-8a0a-499d-8493-5d60e4d6d9ea)

### 4. Security Group for EC2
- **Purpose**: To allow SSH, HTTP, and application-specific traffic.
- **Configuration**:
  
  ```hcl
  resource "aws_security_group" "ec2_sg" {
    name        = "ec2-security-group"
    description = "Allow SSH, HTTP, and other traffic"
    vpc_id      = module.vpc.vpc_id

    ingress {
      description = "Allow SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "Allow HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "Allow TCP on port 8080"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "Allow TCP on port 8081"
      from_port   = 8081
      to_port     = 8081
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "Allow TCP on port 9000"
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "EC2-Security-Group"
    }
  }
  ```

### 5. CloudWatch Monitoring
- **Purpose**: To monitor CPU utilization and trigger alarms if usage exceeds 70%.
- **SNS Topic for Alarm Notifications**:
  
  ```hcl
  resource "aws_sns_topic" "cpu_alarm_topic" {
    name = "cpu-alarm-topic"
  }
  
  resource "aws_sns_topic_subscription" "email_subscription" {
    topic_arn = aws_sns_topic.cpu_alarm_topic.arn
    protocol  = "email"
    endpoint  = "doaahemaid01@gmail.com"
  }
  ```
- **CloudWatch Alarm Configuration**:
  
  ```hcl
  resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
    alarm_name          = "High-CPU-Utilization"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = 2
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = 60
    statistic           = "Average"
    threshold           = 70
    alarm_description   = "This alarm triggers when CPU utilization exceeds 70%."
    actions_enabled     = true

    alarm_actions = [
      aws_sns_topic.cpu_alarm_topic.arn
    ]

    dimensions = {
      InstanceId = module.ec2_instance["Slave"].instance_id
    }
  }
  ```
  ![2024-12-28 21_59_22-High-CPU-Utilization _ Alarms _ CloudWatch _ us-east-1](https://github.com/user-attachments/assets/d56d4a0c-8be4-45bb-a2ae-5fb0e6a0c67d)


