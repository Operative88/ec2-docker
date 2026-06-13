#!/usr/bin/env bash
# Warns if the lab instance is still running, so you don't leave it billing.
# Usage: ./scripts/cost-guard.sh
set -euo pipefail

PROJECT="${1:-ec2-docker}"
REGION="${AWS_REGION:-eu-central-1}"

running="$(aws ec2 describe-instances \
  --region "$REGION" \
  --filters "Name=tag:Project,Values=${PROJECT}" \
            "Name=instance-state-name,Values=running" \
  --query 'Reservations[].Instances[].[InstanceId,InstanceType]' \
  --output text)"

if [[ -z "$running" ]]; then
  echo "OK - nothing running for '${PROJECT}' in ${REGION}."
else
  echo "WARNING - still running in ${REGION}:"
  echo "$running" | sed 's/^/   /'
  echo "Tear down with: (cd terraform && terraform destroy)"
fi
