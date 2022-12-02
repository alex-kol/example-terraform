terraform {
  required_providers {
    
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.36"
    }
    
    template = {
      source = "hashicorp/template"
      version = ">= 2.2.0"
    }
  }

  required_version = ">= 0.14.5"

}
