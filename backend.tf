terraform {
  backend "s3" {
    bucket         = "projects-tfstate-store"
    key            = "tmp-secure-uploader/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
