


resource "aws_iam_user" "how_light_media_user" {
  name = "how-light-media-bucket"

}

resource "aws_iam_user_policy" "how_light_media_polisy" {
  user = aws_iam_user.how_light_media_user
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.how_light_media_bucket}",
          "arn:aws:s3:::${var.how_light_media_bucket}/*"
        ]
      },
    ]
  })
}

resource "aws_iam_access_key" "how_light_media_bucket" {
  user = aws_iam_user.how_light_media_user.name
}