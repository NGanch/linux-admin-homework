terraform {
  backend "s3" {
    bucket         = "mydjangodockerbucket"
    dynamodb_table = "terraform-lock-table"
    key            = "lesson-6/terraform.tfstate"
    region         = "eu-north-1"
  }
}


