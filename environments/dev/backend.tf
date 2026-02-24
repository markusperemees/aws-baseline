terraform {
  backend "s3" {
    bucket         = "secure-baseline-tfstate-636499496034-eu-north-1"
    key            = "secure-baseline/dev/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "secure-baseline-tfstate-lock"
  }
}
