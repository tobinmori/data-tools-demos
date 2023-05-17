data "aws_iam_policy_document" "dms-s3-target-policy" {
    statement {
        sid       = "VisualEditor0"
        actions   = ["s3:PutObject","s3:PutObjectTagging","s3:DeleteObject"]
        resources = ["arn:aws:s3:::${var.dms_target_mvault_cdc_s3_bucket}/*",]
        effect    = "Allow"
    }
    statement {
        sid       = "VisualEditor1"
        actions   = ["s3:ListBucket",]
        resources = ["arn:aws:s3:::${var.dms_target_mvault_cdc_s3_bucket}",]
        effect    = "Allow"
    }
}

resource "aws_iam_policy" "dms-s3-target-policy" {
  name   = "dms-s3-target-policy"  # Make sure this has the name you want
  policy = data.aws_iam_policy_document.dms-s3-target-policy.json
}

# does not work for some reason, so have to do this in the console:
# attach dms-access-for-endpoint role to dms-s3-target-policy 
resource "aws_iam_role_policy_attachment" "dms_s3_target_access_attachment" {
  role       = "arn:aws:iam::960713385905:role/dms-access-for-endpoint"
  policy_arn = aws_iam_policy.dms-s3-target-policy.arn
}



