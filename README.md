# Terraform code for amyinfo.com

Create free GCP resources in my organization for testing.

## Usage
 
1. Create buckets as backend

```bash
terraform init
terraform apply -target=module.buckets -var-file=demo.tfvars --auto-approve
```

2. Migate terraform.state to GCS bucket

```bash
terraform init -var-file=demo.tfvars --migrate-state
```

3. Create sa iam

```bash
terraform plan -target=module.sa-iam -var-file=demo.tfvars
terraform apply -target=module.sa-iam -var-file=demo.tfvars --auto-approve
```

4. Create vpc

```bash
terraform plan -target=module.network -var-file=demo.tfvars
terraform apply -target=module.network -var-file=demo.tfvars --auto-approve
```

5. Create vm as nat gateway

```bash
terraform plan -target=module.nat-gateway -var-file=demo.tfvars
terraform apply -target=module.nat-gateway -var-file=demo.tfvars --auto-approve
```