
data "aws_iam_policy_document" "this" {
  for_each = { for role in var.roles : role.name => role }
  statement {
    effect =  each.value.effect
    principals {
      type        = each.value.type
      identifiers = each.value.identifiers
    }
    actions = each.value.actions
  }
}

resource "aws_iam_role" "this" {
  for_each = { for role in var.roles : role.name => role }
  name               = "${var.proj}-iam-role-${each.key}"
  assume_role_policy = data.aws_iam_policy_document.this[each.key].json
}


locals {
  role_policy_map = {
    for role in var.roles :
    role.name => [
      for policy_arn in role.policy_arns : {
        role_name  = role.name
        policy_arn = policy_arn
      }
    ]
  }
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  for_each = { for role_map in flatten([for role_name, policies in local.role_policy_map : policies]) : "${role_map.role_name}-${role_map.policy_arn}" => role_map }

  role       = aws_iam_role.this[each.value.role_name].name
  policy_arn = each.value.policy_arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  for_each = { for role in var.roles : role.name => role }

  name = "${var.proj}-instance-profile-${each.value.name}"
  role = aws_iam_role.this[each.key].name
}

