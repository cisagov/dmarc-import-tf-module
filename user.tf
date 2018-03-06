provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "user" {
  name = "dmarc-importer-user"
}

resource "aws_iam_access_key" "access_key" {
  user = "${aws_iam_user.user.name}"
}

resource "aws_iam_user_policy" "s3_read" {
  name = "dmarc-import-s3-read"
  user = "${aws_iam_user.user.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:GetObjectTorrent"
            ],
            "Resource": [
                "arn:aws:s3:::cyhy-dmarc-report-emails",
                "arn:aws:s3:::cyhy-dmarc-report-emails/*",
                "arn:aws:s3:::dmarc-import",
                "arn:aws:s3:::dmarc-import/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_user_policy" "es_full" {
  name = "dmarc-import-es-full-access"
  user = "${aws_iam_user.user.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "es:*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}
