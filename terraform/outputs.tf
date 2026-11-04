output "application_url" { value = "http://${aws_lb.app.dns_name}" }
output "artifact_bucket" { value = aws_s3_bucket.artifacts.bucket }
output "github_actions_role_arn" { value = aws_iam_role.github_actions.arn }
output "vpc_id" { value = aws_vpc.main.id }
