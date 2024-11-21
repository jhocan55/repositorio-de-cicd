# resource "aws_s3_bucket" "frontend_artifacts" {
#   bucket = var.S3FrontEnd
#   acl    = "public-read"
#   policy = data.aws_iam_policy_document.website_policy.json
#   website {
#     index_document = "index.html"
#     error_document = "index.html"
#   }
# }
# data "aws_iam_policy_document" "website_policy" {
#   statement {
#     actions = [
#       "s3:GetObject"
#     ]
#     principals {
#       identifiers = ["*"]
#       type        = "AWS"
#     }
#     resources = [
#       "arn:aws:s3:::${var.S3FrontEnd}/*"
#     ]
#   }
# }
# resource "aws_codebuild_project" "tf-frontend1" {
#   name         = "cicd-build-${var.name_frontend}"
#   description  = "pipeline for aplicacion frontend"
#   service_role = var.codebuild_role

#   artifacts {
#     type = "CODEPIPELINE"
#   }

#   environment {
#     compute_type                = "BUILD_GENERAL1_SMALL"
#     image                       = "aws/codebuild/standard:4.0"
#     type                        = "LINUX_CONTAINER"
#     image_pull_credentials_type = "CODEBUILD"
#     privileged_mode             = true

#     environment_variable {
#       type  = "PLAINTEXT"
#       name  = "S3_BUCKET_URL"
#       value = aws_s3_bucket.frontend_artifacts.id
#     }
#   }
#   source {
#     type      = "CODEPIPELINE" #BITBUCKET
#     buildspec = file("2-frontend/buildspec.yml")
#   }
# }
# resource "aws_codepipeline" "frontend1_pipeline" {

#   name     = "cicd-${var.name_frontend}"
#   role_arn = var.codepipeline_role

#   artifact_store {
#     type     = "S3"
#     location = var.s3_terraform_pipeline
#   }

#   stage {
#     name = "Source"
#     action {
#       name     = "Source"
#       category = "Source"
#       owner    = "AWS"
#       provider = "CodeStarSourceConnection"
#       version  = "1"
#       output_artifacts = [
#         "SourceArtifact",
#       ]
#       configuration = {
#         FullRepositoryId     = "culturadevops/angular2.git"
#         BranchName           = "master"
#         ConnectionArn        = var.codestar_connector_credentials
#         OutputArtifactFormat = "CODE_ZIP"
#       }
#     }
#   }

#   stage {
#     name = "Plan"
#     action {
#       name     = "Build"
#       category = "Build"
#       provider = "CodeBuild"
#       version  = "1"
#       owner    = "AWS"
#       input_artifacts = [
#         "SourceArtifact",
#       ]

#       output_artifacts = [
#         "BuildArtifact",
#       ]
#       configuration = {
#         ProjectName = "cicd-build-${var.name_frontend}"
#       }
#     }
#   }
#   stage {
#     name = "Deploy"

#     action {
#       category = "Deploy"
#       configuration = {
#         "BucketName" = aws_s3_bucket.frontend_artifacts.id
#         "Extract"    = "true"
#       }
#       input_artifacts = [
#         "BuildArtifact",
#       ]
#       name             = "Deploy"
#       output_artifacts = []
#       owner            = "AWS"
#       provider         = "S3"
#       run_order        = 1
#       version          = "1"
#     }
#   }


# }

# resource "aws_s3_bucket" "frontend_artifacts" {
#   bucket            = var.S3FrontEnd
#   object_ownership  = "BucketOwnerEnforced" # Ensures AWS enforces ownership
#   force_destroy     = true # Optional: Automatically deletes bucket on destroy (use cautiously)

#   website {
#     index_document = "index.html"
#     error_document = "index.html"
#   }

#   versioning {
#     enabled = true # Optional: Enables versioning for your bucket
#   }

#   tags = {
#     Name        = "FrontendArtifacts"
#     Environment = "Production"
#   }
# }

# # Bucket Policy for Public Access (instead of ACL)
# resource "aws_s3_bucket_policy" "frontend_policy" {
#   bucket = aws_s3_bucket.frontend_artifacts.id
#   policy = data.aws_iam_policy_document.website_policy.json
# }

# data "aws_iam_policy_document" "website_policy" {
#   statement {
#     actions = [
#       "s3:GetObject"
#     ]
#     principals {
#       identifiers = ["*"] # Public access
#       type        = "AWS"
#     }
#     resources = [
#       "arn:aws:s3:::${var.S3FrontEnd}/*"
#     ]
#   }
# }

# resource "aws_codebuild_project" "tf-frontend1" {
#   name         = "cicd-build-${var.name_frontend}"
#   description  = "Pipeline for frontend application"
#   service_role = var.codebuild_role

#   artifacts {
#     type = "CODEPIPELINE"
#   }

#   environment {
#     compute_type                = "BUILD_GENERAL1_SMALL"
#     image                       = "aws/codebuild/standard:4.0"
#     type                        = "LINUX_CONTAINER"
#     image_pull_credentials_type = "CODEBUILD"
#     privileged_mode             = true

#     environment_variable {
#       type  = "PLAINTEXT"
#       name  = "S3_BUCKET_URL"
#       value = aws_s3_bucket.frontend_artifacts.bucket_regional_domain_name
#     }
#   }

#   source {
#     type      = "CODEPIPELINE"
#     buildspec = file("2-frontend/buildspec.yml")
#   }
# }

# resource "aws_codepipeline" "frontend1_pipeline" {
#   name     = "cicd-${var.name_frontend}"
#   role_arn = var.codepipeline_role

#   artifact_store {
#     type     = "S3"
#     location = var.s3_terraform_pipeline
#   }

#   stage {
#     name = "Source"
#     action {
#       name     = "Source"
#       category = "Source"
#       owner    = "AWS"
#       provider = "CodeStarSourceConnection"
#       version  = "1"
#       output_artifacts = [
#         "SourceArtifact",
#       ]
#       configuration = {
#         FullRepositoryId     = "culturadevops/angular2.git"
#         BranchName           = "master"
#         ConnectionArn        = var.codestar_connector_credentials
#         OutputArtifactFormat = "CODE_ZIP"
#       }
#     }
#   }

#   stage {
#     name = "Plan"
#     action {
#       name     = "Build"
#       category = "Build"
#       provider = "CodeBuild"
#       version  = "1"
#       owner    = "AWS"
#       input_artifacts = [
#         "SourceArtifact",
#       ]

#       output_artifacts = [
#         "BuildArtifact",
#       ]
#       configuration = {
#         ProjectName = "cicd-build-${var.name_frontend}"
#       }
#     }
#   }

#   stage {
#     name = "Deploy"
#     action {
#       category = "Deploy"
#       configuration = {
#         "BucketName" = aws_s3_bucket.frontend_artifacts.bucket
#         "Extract"    = "true"
#       }
#       input_artifacts = [
#         "BuildArtifact",
#       ]
#       name             = "Deploy"
#       output_artifacts = []
#       owner            = "AWS"
#       provider         = "S3"
#       run_order        = 1
#       version          = "1"
#     }
#   }
# }


# resource "aws_s3_bucket" "frontend_artifacts" {
#   bucket         = var.S3FrontEnd
#   force_destroy  = true # Optional: Automatically deletes bucket on destroy (use cautiously)

#   website {
#     index_document = "index.html"
#     error_document = "index.html"
#   }

#   versioning {
#     enabled = true # Optional: Enables versioning for your bucket
#   }

#   tags = {
#     Name        = "FrontendArtifacts"
#     Environment = "Production"
#   }
# }

resource "aws_s3_bucket" "frontend_artifacts" {
  bucket            = var.S3FrontEnd
  force_destroy     = true

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  versioning {
    enabled = true
  }

  tags = {
    Name        = "FrontendArtifacts"
    Environment = "Production"
  }

  # Disable Block Public Access to allow bucket policy changes
  public_access_block_configuration {
    block_public_acls       = false
    ignore_public_acls      = false
    block_public_policy     = false
    restrict_public_buckets = false
  }
}


# Bucket Policy for Public Access (instead of ACL)
resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend_artifacts.id
  policy = data.aws_iam_policy_document.website_policy.json
}

data "aws_iam_policy_document" "website_policy" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"] # Public access
      type        = "AWS"
    }
    resources = [
      "arn:aws:s3:::${var.S3FrontEnd}/*"
    ]
  }
}

resource "aws_codebuild_project" "tf-frontend1" {
  name         = "cicd-build-${var.name_frontend}"
  description  = "Pipeline for frontend application"
  service_role = var.codebuild_role

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      type  = "PLAINTEXT"
      name  = "S3_BUCKET_URL"
      value = aws_s3_bucket.frontend_artifacts.bucket_regional_domain_name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("2-frontend/buildspec.yml")
  }
}

resource "aws_codepipeline" "frontend1_pipeline" {
  name     = "cicd-${var.name_frontend}"
  role_arn = var.codepipeline_role

  artifact_store {
    type     = "S3"
    location = var.s3_terraform_pipeline
  }

  stage {
    name = "Source"
    action {
      name     = "Source"
      category = "Source"
      owner    = "AWS"
      provider = "CodeStarSourceConnection"
      version  = "1"
      output_artifacts = [
        "SourceArtifact",
      ]
      configuration = {
        FullRepositoryId     = "culturadevops/angular2.git"
        BranchName           = "main"
        ConnectionArn        = var.codestar_connector_credentials
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Plan"
    action {
      name     = "Build"
      category = "Build"
      provider = "CodeBuild"
      version  = "1"
      owner    = "AWS"
      input_artifacts = [
        "SourceArtifact",
      ]

      output_artifacts = [
        "BuildArtifact",
      ]
      configuration = {
        ProjectName = "cicd-build-${var.name_frontend}"
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      category = "Deploy"
      configuration = {
        "BucketName" = aws_s3_bucket.frontend_artifacts.bucket
        "Extract"    = "true"
      }
      input_artifacts = [
        "BuildArtifact",
      ]
      name             = "Deploy"
      output_artifacts = []
      owner            = "AWS"
      provider         = "S3"
      run_order        = 1
      version          = "1"
    }
  }
}
