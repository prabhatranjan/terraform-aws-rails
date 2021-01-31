# terraform-aws-rails

This repository contains a terraform script to deploy a rails application to AWS elastic beanstalk.

It starts with a configuration of s3 bucket where the application files can be zipped and uploaded. 

The environment for the elastic beanstalk application can be configured as per the needs of the application. The file railsApp.tf contains a few of them as described below:
- AutoScaling is enabled to deploy a scalable architecture, one of the values "MaxSize" is set as an example.
- The trigger for AutoScaling is put as CPUutilization as an example, again this can be modified based on needs of the application
- The environment type is selected as "LoadBalanced" to enable elastic load balancer for the application. This will allow to route traffic to a server based on parameters that can be configured. 
- A RDS instance is added with mysql default database. This is allow for a highly available data store.
- More options such as security groups and VPC can be configured to host the infrastructure in a private network and expose it through a load balancer pointed to by a DNS hosted in route53.

The complete list of configuration options for elastic beanstalk is available here, https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-autoscalinglaunchconfiguration

Architecture
------------

