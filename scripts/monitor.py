import boto3
import datetime
import pytz
import json

# Configuration
REGION = "us-west-1"
SUSPICIOUS_EVENT_CODE = "AccessDenied"
SNS_TOPIC_ARN = "arn:aws:sns:us-west-1:<your_account_id>:security-alerts-topic"

# Initialize AWS clients
cloudtrail = boto3.client("cloudtrail", region_name=REGION)
sns = boto3.client("sns", region_name=REGION)

# Use UTC timezone
utc = pytz.UTC

def get_recent_events(minutes=15):
    """Fetch recent CloudTrail events within the last `minutes` minutes."""
    now = datetime.datetime.utcnow().replace(tzinfo=utc)
    start_time = now - datetime.timedelta(minutes=minutes)

    try:
        response = cloudtrail.lookup_events(
            StartTime=start_time,
            EndTime=now,
            MaxResults=50  
        )
        return response.get("Events", [])
    except Exception as e:
        print(f"[ERROR] Could not fetch CloudTrail events: {e}")
        return []

def parse_and_alert(events):
    """Filter suspicious events and send alerts if found."""
    for event in events:
        event_detail = json.loads(event["CloudTrailEvent"])

        error_code = event_detail.get("errorCode", "")
        event_name = event_detail.get("eventName", "")
        user = event_detail.get("userIdentity", {}).get("arn", "Unknown")
        resource = event_detail.get("requestParameters", {}).get("bucketName", "Unknown")

        if error_code == SUSPICIOUS_EVENT_CODE:
            alert_message = (
                f"🚨 Unauthorized Access Detected!\n"
                f"- Event: {event_name}\n"
                f"- Error: {error_code}\n"
                f"- User: {user}\n"
                f"- Bucket: {resource}\n"
                f"- Time: {event['EventTime']}"
            )

            print(alert_message)
            send_sns_alert(alert_message)

def send_sns_alert(message):
    """Send an email notification using SNS."""
    try:
        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Message=message,
            Subject="🔐 Security Alert - Unauthorized S3 Access"
        )
        print("[INFO] Alert sent via SNS.")
    except Exception as e:
        print(f"[ERROR] Could not send SNS alert: {e}")

def main():
    print("[INFO] Monitoring for suspicious S3 access...")
    events = get_recent_events()
    if not events:
        print("[INFO] No events found.")
        return
    parse_and_alert(events)

if __name__ == "__main__":
    main()
