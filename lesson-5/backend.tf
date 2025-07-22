terraform {
  backend "s3" {
    bucket         = "mydjangodockerbucket"
    key            = "lesson-5/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
