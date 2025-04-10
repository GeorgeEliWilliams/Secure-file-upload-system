terraform {
  backend "s3" {
    bucket         = "proj-tfstate"
    key            = "tmp-secure-uploader/terraform.tfstate"
    region         = "us-west-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
