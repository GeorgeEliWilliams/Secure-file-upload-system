# Secure File Upload to Amazon S3 using Temporary IAM Credentials

This project implements a secure, scalable, and production-grade **file upload workflow** to Amazon S3 using **Python**, **Boto3**, and **IAM Role Assumption** via `sts:AssumeRole`. It supports **multipart uploads** for large files and enforces security best practices by using **temporary credentials** rather than long-lived access keys.

- **Technical Article:** [medium.com/@your-handle/secure-multipart-s3-upload](https://medium.com/@your-handle/secure-multipart-s3-upload)

---

##  Tools & Services Used

- **AWS S3** – Object storage for uploaded files  
- **AWS IAM** – Role-based access control using least privilege  
- **AWS STS** – Temporary credential generation via role assumption  
- **AWS CloudTrail** – Auditing access to S3 and STS  
- **AWS SNS** – Upload completion notifications  
- **Boto3** – Python SDK for AWS  
- **tqdm** – Terminal progress bar for upload tracking  
- **Python 3.13**, **virtualenv**

---

##  Architecture Overview

```plaintext
[Uploader (Local)]
     |
     | -- boto3 + uploader-profile
     | -- assumes IAM Role (STS)
     v
[Assumed Role: s3-uploader-role]
     |
     | -- Temporary Credentials
     v
[Amazon S3: my-secure-upload-bucket-007]
     |
     | -- Multipart Upload
     | -- Upload Tracked via CloudTrail
     | -- Notification via SNS (Optional)
```

---

## Features

- Secure Upload Flow using temporary IAM credentials via sts:AssumeRole

- Multipart Upload support for large files with chunked uploading logic

- Real-Time Progress Bar with tqdm for better UX during uploads

- Least Privilege IAM Design for both users and roles

- Monitoring & Alerts via AWS CloudTrail and optional SNS integration

---

## Directory Structure

secure-s3-upload/
├── scripts/
│   └── multipart_upload.py       # Upload logic
    └── monitor.py
├── .env/                         # Virtual environment
├── README.md
├── test-upload.zip               # Sample test file
└── terraform/                    # Infrastructure as Code 
└── main.tf
└── variables.tf
└── provider.tf
└── backend.tf

---

##  How it works

1. IAM User (uploader-profile) is configured locally with minimal permissions to assume a role.

2. Script assumes s3-uploader-role using STS, which returns temporary credentials.

3. A multipart upload session is initiated with S3.

4. File is uploaded in 8MB chunks, and each part is tracked.

5. If successful, all parts are committed. Otherwise, the upload is aborted.

6. CloudTrail logs every action for auditing. SNS notification is sent upon completion.

---

## Setup & Usage

1.  Clone & Create Virtual Environment

```bash
git clone https://github.com/your-username/secure-s3-upload.git
cd secure-s3-upload
python3 -m venv myenv
source myenv/bin/activate
pip install -r requirements.txt
```

2. Configure AWS CLI Profile
```
aws configure --profile uploader-profile
```

3. Run the Script
```bash
python scripts/multipart_upload.py
```

---

## IAM Policy Samples

**IAM User (uploader-profile)**
```bash
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::ACCOUNT_ID:role/s3-uploader-role"
    }
  ]
}
```

**IAM Role (s3-uploader-role)**
```bash
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:AbortMultipartUpload",
        "s3:ListMultipartUploadParts",
        "s3:CompleteMultipartUpload"
      ],
      "Resource": "arn:aws:s3:::my-secure-upload-bucket-007/*"
    }
  ]
}
```

---

## Monitoring & Alerts

- AWS CloudTrail: Tracks all API calls for auditing purposes.

- AWS SNS (optional): Sends a notification to subscribers after successful uploads.

Integrate s3:PutObject trigger to invoke an SNS topic.