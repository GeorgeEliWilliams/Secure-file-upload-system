import boto3
import os
import math
from tqdm import tqdm

BUCKET_NAME = "my-secure-upload-bucket-007"
FILE_PATH = "test-upload.zip"  
KEY_NAME = os.path.basename(FILE_PATH)
CHUNK_SIZE = 8 * 1024 * 1024  # 8 MB

# Function to assume the s3-uploader-role using the uploader-profile
def assume_role():
    session = boto3.Session(profile_name='uploader-profile')  # Use uploader-profile to assume role
    sts_client = session.client('sts')
    
    assumed_role = sts_client.assume_role(
        RoleArn="...",  # Role ARN for s3-uploader-role
        RoleSessionName="upload-session"
    )
    credentials = assumed_role['Credentials']
    
    # Return a session with the assumed role credentials
    return boto3.Session(
        aws_access_key_id=credentials['AccessKeyId'],
        aws_secret_access_key=credentials['SecretAccessKey'],
        aws_session_token=credentials['SessionToken']
    )

# Use the assumed role session to upload
session = assume_role()
s3 = session.client("s3")

def multipart_upload(bucket, file_path, key_name, chunk_size):
    # Step 1: Initiate upload
    response = s3.create_multipart_upload(Bucket=bucket, Key=key_name)
    upload_id = response['UploadId']
    print(f"🚀 Initiated multipart upload. Upload ID: {upload_id}")

    parts = []
    try:
        file_size = os.path.getsize(file_path)
        total_parts = math.ceil(file_size / chunk_size)

        with open(file_path, 'rb') as f, tqdm(total=file_size, unit='B', unit_scale=True, desc="Uploading") as pbar:
            for i in range(1, total_parts + 1):
                data = f.read(chunk_size)
                part = s3.upload_part(
                    Bucket=bucket,
                    Key=key_name,
                    PartNumber=i,
                    UploadId=upload_id,
                    Body=data
                )
                parts.append({
                    'ETag': part['ETag'],
                    'PartNumber': i
                })
                pbar.update(len(data))

        # Step 3: Complete the upload
        s3.complete_multipart_upload(
            Bucket=bucket,
            Key=key_name,
            UploadId=upload_id,
            MultipartUpload={'Parts': parts}
        )
        print("✅ Multipart upload completed successfully.")

    except Exception as e:
        print(f"❌ Error: {e}")
        print("⚠️ Aborting upload...")
        s3.abort_multipart_upload(Bucket=bucket, Key=key_name, UploadId=upload_id)

if __name__ == "__main__":
    multipart_upload(BUCKET_NAME, FILE_PATH, KEY_NAME, CHUNK_SIZE)
