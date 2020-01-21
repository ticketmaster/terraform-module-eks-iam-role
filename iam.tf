data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${replace(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")}:oidc-provider/${data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer}"]
    }

    condition {
      test = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")}:sub"
      values = ["system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}"]
    }
  }
}

resource "aws_iam_role" "iam_role" {
  name = "${var.role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}

resource "aws_iam_role_policy" "iam_policy" {
  name = "${var.role_name}-policy"
  role = "${aws_iam_role.iam_role.id}"
  policy = "${var.iam_policy}"
}
