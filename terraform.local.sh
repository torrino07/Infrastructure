cd terraform

terraform init \
    -backend-config="region=us-east-1" \
    -backend-config="bucket=terraformstate001-dev" \
    -backend-config="key=dev/terraform.tfstate" \
    -backend-config="dynamodb_table=terraform-locks-dev"

terraform workspace select dev || terraform workspace new dev

terraform plan -var-file="environments/dev/terraform.tfvars" -out=dev-plan.out

terraform apply dev-plan.out

terraform destroy -var-file="environments/dev/terraform.tfvars" -auto-approve

aws eks update-kubeconfig --region us-east-1 --name my-cluster-eks
kubectl get pods