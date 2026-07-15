#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if rg -n --hidden -S \
  "(TOKEN|SECRET|PASSWORD|PASS=|API[_-]?KEY|PRIVATE KEY|BEGIN OPENSSH|BEGIN RSA|ghp_|github_pat_|sk-|xoxb-|DATABASE_URL|REDIS_URL|PAYMONGO|SENDGRID|TWILIO|SEMAPHORE)" \
  "${ROOT_DIR}" \
  -g '!/.git/**' \
  -g '!docs/**' \
  -g '!scripts/secret-scan.sh'; then
  printf 'Potential secret patterns found. Review before committing.\n' >&2
  exit 1
fi

printf 'No obvious secret patterns found.\n'
