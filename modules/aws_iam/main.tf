resource "aws_iam_role" "iam_role" {
    name = "${var.roleName}"
    description = "${var.roleDesc}"
    
    /* ROLE TRUST POLICY */
    assume_role_policy = jsonencode (
        {
            Version = "2012-10-17"
            Statement = [
                {
                    Sid = "AssumeRole"
                    Action = "sts:AssumeRole"
                    Effect = "Allow"
                    Principal = {
                        Service  = [
                            for tp in "${var.roleTrustPolicy}" : tp
                        ]
                    }
                }
            ]
        }
    )
}

###################################################################################################

/* CREATE IAM POLICY */
resource "aws_iam_policy" "iam_policy" {
    name        = "${var.policyName}"
    description = "${var.policyDesc}"
    policy = jsonencode (
        {
            Version = "2012-10-17"
            Statement = [
                {
                    Effect   = "Allow"
                    Action = [
                        for pp in "${var.policyPermission}" : pp
                    ]
                    Resource = "*"
                },
            ]
        }
    )
}

###################################################################################################

/* ROLE AND POLICY ATTACHMENT */
resource "aws_iam_role_policy_attachment" "policy_attachment" {
    role = aws_iam_role.iam_role.name
    policy_arn = aws_iam_policy.iam_policy.arn
}
resource "aws_iam_role_policy_attachment" "addons_policy_attachment" {
    for_each = toset([for apa in "${var.attachPolicyArn}" : apa])
    role = aws_iam_role.iam_role.name
    policy_arn = each.value
}

###################################################################################################