# Infrastructure Setup Guide

This project uses a separated backend architecture to ensure state safety and prevent accidental deletion of infrastructure.

## Phase 1: The "Bootstrap" (One-Time Setup)
Think of this as building the **foundation**. You only do this once to create the "Cloud Storage" where your state will live.

1. **Navigate to the folder:**
   ```bash
   cd 10-customer-practice/bootstrap
   ```
2. **Initialize locally:**
   ```bash
   terraform init
   ```
3. **Create the backend resources:**
   ```bash
   terraform apply -auto-approve
   ```
   **Result:** You now have an S3 bucket and DynamoDB table in AWS, managed by a local `terraform.tfstate` file in this folder.

---

## Phase 2: The "Project" (Daily Work)
Think of this as building your **actual product**. This project will save its data into the foundation you just built.

1. **Navigate to your project folder:**
   ```bash
   cd ../policy-practice
   ```
2. **Initialize with Remote State:**
   ```bash
   terraform init
   ```
   *Terraform will see the `backend.tf` file and connect to the S3 bucket created in Phase 1.*
3. **Build your resources:**
   ```bash
   terraform apply -auto-approve
   ```
   **Result:** Your IAM Policy and Log Group are created, and the record of them is safely uploaded to your S3 bucket.

---

## Phase 3: The "Cleanup" (Optional)
This will delete everything from AWS. **Order matters!**

1. **Delete the Application first:**
   ```bash
   # From the policy-practice folder
   terraform destroy -auto-approve
   ```

2. **Delete the Storage last:**
   ```bash
   cd ../bootstrap
   terraform destroy -auto-approve
   ```