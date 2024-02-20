resource "aws_iam_role" "comprehensive_iam_role" {
  name               = var.name
  assume_role_policy = templatefile("${path.module}/policies/assume_role.json", {})

  path = "/"
}

resource "aws_iam_policy" "comprehensive_permissions" {
  name   = "ComprehensivePermissions"
  policy = templatefile("${path.module}/policies/comprehensive_permissions.json", {})
}

resource "aws_iam_role_policy_attachment" "comprehensive_permissions_attachment" {
  role       = aws_iam_role.comprehensive_iam_role.name
  policy_arn = aws_iam_policy.comprehensive_permissions.arn
}

