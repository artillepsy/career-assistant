# CI/CD Pipeline Workflows

## Troubleshooting

### Terraform State Lock

If you experience a Terraform state lock blocking deployment, follow these steps in Terminal:

1. Use this command to list your buckets and filter for "tfstate":
```bash
aws s3 ls | Select-String "tfstate"
```

2. List the files to find the lock. Look for the file ending in .tflock
```bash
# Replace <BUCKET_NAME> with your actual bucket name found in the output.
aws s3 ls s3://<BUCKET_NAME> --recursive
```

3. Delete the lock via CLI
    1. YOUR_BUCKET_NAME: This is the name of the S3 bucket where you store your Terraform state.
    2. YOUR_PROJECT_PATH: This is the folder path inside that bucket.
```bash
# Replace <BUCKET_NAME> and <PATH> with your actual details
aws s3 rm s3://<YOUR_BUCKET_NAME>/<YOUR_PROJECT_PATH>/terraform.tfstate.tflock
```

If you still experience issues with the same lock id, delete the lock manually in the AWS Console.

1. Go to your S3 bucket in the AWS Console.

2. Click the "Show versions" toggle switch (usually at the top right of the file list).

3. Find terraform.tfstate.tflock. You will now see multiple entries for it.

4. Select all of them and click Delete.

5. Confirm by typing permanently delete.