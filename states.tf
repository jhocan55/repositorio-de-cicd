terraform{
    backend "s3" {
        bucket = "luna-terraform-state-1"
        encrypt = true
        key = "terraform1.tfstate"
        region = "eu-west-3"
    }
}

provider "aws" {
  region  = "eu-west-3"
}

#Comment