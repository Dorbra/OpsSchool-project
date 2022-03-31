terraform {
  backend "s3" {
    bucket = "doronmidproj"
    key    = "tfstate"
    region = "us-east-1"
  }
}
