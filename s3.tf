resource "aws_s3_bucket" "how_light_media_1" {
  bucket    = var.how-light-media-bucket


}

resource aws_s3_bucket_acl "how_light_acl_bucket" {
  bucket = aws_s3_bucket.how_light_media_1.id
  acl    = "public-read"

}

resource "aws_s3_bucket_cors_configuration" "example" {
  bucket = aws_s3_bucket.how_light_media_1.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

}

resource "aws_iam_user" "how_light_media_user" {
  name = "how-light-media-user"

}

resource "aws_iam_user_policy" "how_light_media_polisy" {
  user = aws_iam_user.how_light_media_user.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_access_key" "how_light_media_bucket" {
  user = aws_iam_user.how_light_media_user.name
}