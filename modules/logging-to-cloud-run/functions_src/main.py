import os
import json
import base64
import requests

def handler(event, context):
    slack_webhook = os.getenv("SLACK_WEBHOOK_URL")

    if "data" in event:
        payload = base64.b64decode(event["data"]).decode("utf-8")
        try:
            payload_json = json.loads(payload)
            instance_name = payload_json.get("resource", {}).get("labels", {}).get("instance_group_manager_name", "unknown")
            event_type = payload_json.get("protoPayload", {}).get("methodName", "unknown")
            msg = f"MIG Event: instance={instance_name}, event={event_type}"
        except Exception:
            msg = "MIG Event received (unable to parse payload)."
    else:
        msg = "MIG Event received (no payload)."

    requests.post(slack_webhook, json={"text": msg})
