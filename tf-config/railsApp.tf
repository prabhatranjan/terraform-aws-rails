terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

#s3 bucket to store deployable artefacts

resource "aws_s3_bucket" "default" {
  bucket = "prabhat.applicationversion.bucket"
}

resource "aws_s3_bucket_object" "default" {
  bucket = aws_s3_bucket.default.id
  key    = "beanstalk/myApp.zip"
  source = "myApp.zip"
}

#elastic beanstalk application and version

resource "aws_elastic_beanstalk_application" "prabhat" {
  name        = "prabhat-eb"
  description = "rails app"
}

resource "aws_elastic_beanstalk_application_version" "pver" {
  name        = "prabhat-eb-version-label"
  application = "prabhat-eb"
  description = "application version"
  bucket      = aws_s3_bucket.default.id
  key         = aws_s3_bucket_object.default.id
}

#elastic beanstalk environment

resource "aws_elastic_beanstalk_environment" "prabhatenv" {
  name                = "prabhatenv-eb"
  application         = aws_elastic_beanstalk_application.prabhat.name
  solution_stack_name = "64bit Amazon Linux 2 v3.2.2 running Ruby 2.7"

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "2"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3a.large"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = "CPUUtilization"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  setting {
    namespace = "aws:rds:dbinstance"
    name      = "DBPassword"
    value     = var.pwd
  }

}

