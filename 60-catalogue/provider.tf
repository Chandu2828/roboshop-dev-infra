terraform {
    required_providers {
        aws = {
            source  = "hasicorp/aws"
            version = "6.48.0"
        }
    }

    backend "s3" {
        bucket          = "remote-state-90s-practice-dev"
        key             = "roboshop-catalogue.tfstate"
        region          = "us-east-1"
        encrypt         = true 
        use_lockfile    = true 
    }
}

provider "aws" {
    region = "us-east-1"
}