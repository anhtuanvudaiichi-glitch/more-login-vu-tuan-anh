#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════
# MoreLogin Agent API — cURL Examples
# ═══════════════════════════════════════════════════════════════════
#
# Prerequisites:
#   - Agent running on http://127.0.0.1:18080
#   - jq, openssl, uuidgen installed
#   - Replace [PLACEHOLDER:PROFILE_ID] / [PLACEHOLDER:CLOUDPHONE_ID] with real values
#
# Usage:
#   chmod +x curl-examples.sh
#   ./curl-examples.sh
#
# ═══════════════════════════════════════════════════════════════════

set -euo pipefail

# ── Configuration ────────────────────────────────────────────────
API_KEY_ID="[PLACEHOLDER:AGENT_API_KEY_ID]"
API_KEY_SECRET="[PLACEHOLDER:AGENT_API_KEY_SECRET]"

# Choose base URL:
BASE_URL="http://127.0.0.1:18080"
# BASE_URL="https://[PLACEHOLDER:agent.example.com]"

# ── Helper: Compute HMAC signature ──────────────────────────────
# Usage: sign METHOD PATH [BODY]
sign() {
    local method="$1"
    local path="$2"
    local body="${3:-}"

    TIMESTAMP=$(date +%s)
    NONCE=$(uuidgen 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")
    BODY_HASH=$(printf '%s' "$body" | openssl dgst -sha256 -hex 2>/dev/null | awk '{print $NF}')
    CANONICAL=$(printf '%s\n%s\n%s\n%s\n%s' "$method" "$path" "$TIMESTAMP" "$NONCE" "$BODY_HASH")
    SIGNATURE=$(printf '%s' "$CANONICAL" | openssl dgst -sha256 -hmac "$API_KEY_SECRET" -hex 2>/dev/null | awk '{print $NF}')
}

# ── Helper: Auth headers ────────────────────────────────────────
auth_headers() {
    echo "-H \"X-API-Key: ${API_KEY_ID}\" -H \"X-Timestamp: ${TIMESTAMP}\" -H \"X-Nonce: ${NONCE}\" -H \"X-Signature: ${SIGNATURE}\""
}

echo "═══════════════════════════════════════════════════════════"
echo "  MoreLogin Agent API — cURL Examples"
echo "  Base URL: ${BASE_URL}"
echo "═══════════════════════════════════════════════════════════"

# ─────────────────────────────────────────────────────────────────
# 1. Health Check (GET, no body)
# ─────────────────────────────────────────────────────────────────
echo ""
echo "── 1. Health Check ──────────────────────────────────────"
sign "GET" "/agent/v1/health" ""
curl -s -X GET "${BASE_URL}/agent/v1/health" \
  -H "X-API-Key: ${API_KEY_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Nonce: ${NONCE}" \
  -H "X-Signature: ${SIGNATURE}" | jq .

# ─────────────────────────────────────────────────────────────────
# 2. Upstream Health Check
# ─────────────────────────────────────────────────────────────────
echo ""
echo "── 2. Upstream Health Check ─────────────────────────────"
sign "GET" "/agent/v1/health/upstream" ""
curl -s -X GET "${BASE_URL}/agent/v1/health/upstream" \
  -H "X-API-Key: ${API_KEY_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Nonce: ${NONCE}" \
  -H "X-Signature: ${SIGNATURE}" | jq .

# ─────────────────────────────────────────────────────────────────
# 3. Diagnostics Snapshot
# ─────────────────────────────────────────────────────────────────
echo ""
echo "── 3. Diagnostics Snapshot ──────────────────────────────"
sign "GET" "/agent/v1/diagnostics/morelogin" ""
curl -s -X GET "${BASE_URL}/agent/v1/diagnostics/morelogin" \
  -H "X-API-Key: ${API_KEY_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Nonce: ${NONCE}" \
  -H "X-Signature: ${SIGNATURE}" | jq .

# ─────────────────────────────────────────────────────────────────
# 4. Refresh Diagnostics (POST, no body)
# ─────────────────────────────────────────────────────────────────
echo ""
echo "── 4. Refresh Diagnostics ───────────────────────────────"
sign "POST" "/agent/v1/diagnostics/morelogin/refresh" ""
curl -s -X POST "${BASE_URL}/agent/v1/diagnostics/morelogin/refresh" \
  -H "X-API-Key: ${API_KEY_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Nonce: ${NONCE}" \
  -H "X-Signature: ${SIGNATURE}" | jq .

# ─────────────────────────────────────────────────────────────────
# 5. profile.list — List browser profiles
# ─────────────────────────────────────────────────────────────────
echo ""
echo "── 5. profile.list ──────────────────────────────────────"
BODY='{"request_id":"'$(uuidgen 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")'","payload":{"page":1,"page_size":20},"options":{"async":false}}'
sign "POST" "/agent/v1/commands/profile.list" "$BODY"
curl -s -X POST "${BASE_URL}/agent/v1/commands/profile.list" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: ${API_KEY_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Nonce: ${NONCE}" \
  -H "X-Signature: ${SIGNATURE}" \
  -d "$BODY" | jq .

# ─────────────────────────────────────────────────────────────────
# 6. profile.start — Start a browser profile
# ─────────────────────────────────────────────────────────────────
echo ""
echo "── 6. profile.start ─────────────────────────────────────"
BODY='{"request_id":"'$(uuidgen 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")'","target":{"profile_id":"[PLACEHOLDER:PROFILE_ID]"},"payload":{"is_headless":false},"options":{"async":false}}'
sign "POST" "/agent/v1/commands/profile.start" "$BODY"
curl -s -X POST "${BASE_URL}/agent/v1/commands/profile.start" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: ${API_KEY_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Nonce: ${NONCE}" \
  -H "X-Signature: ${SIGNATURE}" \
  -d "$BODY" | jq .

# ─────────────────────────────────────────────────────────────────
# 7. profile.stop — Stop a browser profile
# ─────────────────────────────────────────────────────────────────
echo ""
echo "── 7. profile.stop ──────────────────────────────────────"
BODY='{"request_id":"'$(uuidgen 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")'","target":{"profile_id":"[PLACEHOLDER:PROFILE_ID]"},"payload":{},"options":{"async":false}}'
sign "POST" "/agent/v1/commands/profile.stop" "$BODY"
curl -s -X POST "${BASE_URL}/agent/v1/commands/profile.stop" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: ${API_KEY_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Nonce: ${NONCE}" \
  -H "X-Signature: ${SIGNATURE}" \
  -d "$BODY" | jq .

# ─────────────────────────────────────────────────────────────────
# 8. profile.status — Get profile status
# ─────────────────────────────────────────────────────────────────
echo ""
echo "── 8. profile.status ────────────────────────────────────"
BODY='{"request_id":"'$(uuidgen 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")'","target":{"profile_id":"[PLACEHOLDER:PROFILE_ID]"},"payload":{},"options":{"async":false}}'
sign "POST" "/agent/v1/commands/profile.status" "$BODY"
curl -s -X POST "${BASE_URL}/agent/v1/commands/profile.status" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: ${API_KEY_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Nonce: ${NONCE}" \
  -H "X-Signature: ${SIGNATURE}" \
  -d "$BODY" | jq .

# ─────────────────────────────────────────────────────────────────
# 9. browser.open_and_run — Run JS script (ALWAYS ASYNC)
# ─────────────────────────────────────────────────────────────────
echo ""
echo "── 9. browser.open_and_run (async) ──────────────────────"
BODY='{"request_id":"'$(uuidgen 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")'","idempotency_key":"curl-demo-001","target":{"profile_id":"[PLACEHOLDER:PROFILE_ID]"},"payload":{"script":"return document.title;","is_headless":false},"options":{"async":true,"timeout_seconds":120}}'
sign "POST" "/agent/v1/commands/browser.open_and_run" "$BODY"
curl -s -X POST "${BASE_URL}/agent/v1/commands/browser.open_and_run" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: ${API_KEY_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Nonce: ${NONCE}" \
  -H "X-Signature: ${SIGNATURE}" \
  -d "$BODY" | jq .

# ─────────────────────────────────────────────────────────────────
# 10. Get Job Status — Poll async job result
# ─────────────────────────────────────────────────────────────────
echo ""
echo "── 10. Get Job Status (replace 42 with real job_id) ─────"
JOB_ID=42
sign "GET" "/agent/v1/jobs/${JOB_ID}" ""
curl -s -X GET "${BASE_URL}/agent/v1/jobs/${JOB_ID}" \
  -H "X-API-Key: ${API_KEY_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Nonce: ${NONCE}" \
  -H "X-Signature: ${SIGNATURE}" | jq .

# ─────────────────────────────────────────────────────────────────
# 11. cloudphone.list — List cloud phones
# ─────────────────────────────────────────────────────────────────
echo ""
echo "── 11. cloudphone.list ──────────────────────────────────"
BODY='{"request_id":"'$(uuidgen 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")'","payload":{"page":1,"page_size":20},"options":{"async":false}}'
sign "POST" "/agent/v1/commands/cloudphone.list" "$BODY"
curl -s -X POST "${BASE_URL}/agent/v1/commands/cloudphone.list" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: ${API_KEY_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Nonce: ${NONCE}" \
  -H "X-Signature: ${SIGNATURE}" \
  -d "$BODY" | jq .

# ─────────────────────────────────────────────────────────────────
# 12. cloudphone.exec_command — Execute shell command
# ─────────────────────────────────────────────────────────────────
echo ""
echo "── 12. cloudphone.exec_command ──────────────────────────"
BODY='{"request_id":"'$(uuidgen 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")'","target":{"cloudphone_id":"[PLACEHOLDER:CLOUDPHONE_ID]"},"payload":{"command":"echo hello"},"options":{"async":false}}'
sign "POST" "/agent/v1/commands/cloudphone.exec_command" "$BODY"
curl -s -X POST "${BASE_URL}/agent/v1/commands/cloudphone.exec_command" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: ${API_KEY_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Nonce: ${NONCE}" \
  -H "X-Signature: ${SIGNATURE}" \
  -d "$BODY" | jq .

# ─────────────────────────────────────────────────────────────────
# 13. file.attach_from_url — Upload file (ALWAYS ASYNC)
# ─────────────────────────────────────────────────────────────────
echo ""
echo "── 13. file.attach_from_url (async) ─────────────────────"
BODY='{"request_id":"'$(uuidgen 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")'","target":{"cloudphone_id":"[PLACEHOLDER:CLOUDPHONE_ID]"},"payload":{"file_url":"https://example.com/file.txt"},"options":{"async":true,"timeout_seconds":300}}'
sign "POST" "/agent/v1/commands/file.attach_from_url" "$BODY"
curl -s -X POST "${BASE_URL}/agent/v1/commands/file.attach_from_url" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: ${API_KEY_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Nonce: ${NONCE}" \
  -H "X-Signature: ${SIGNATURE}" \
  -d "$BODY" | jq .

# ─────────────────────────────────────────────────────────────────
# 14. schedule.create — Create scheduled task (ALWAYS ASYNC)
# ─────────────────────────────────────────────────────────────────
echo ""
echo "── 14. schedule.create (async) ──────────────────────────"
BODY='{"request_id":"'$(uuidgen 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")'","target":{"cloudphone_id":"[PLACEHOLDER:CLOUDPHONE_ID]"},"payload":{"task_config":{"name":"my-task","cron":"*/5 * * * *"}},"options":{"async":true}}'
sign "POST" "/agent/v1/commands/schedule.create" "$BODY"
curl -s -X POST "${BASE_URL}/agent/v1/commands/schedule.create" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: ${API_KEY_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Nonce: ${NONCE}" \
  -H "X-Signature: ${SIGNATURE}" \
  -d "$BODY" | jq .

# ─────────────────────────────────────────────────────────────────
# 15. schedule.cancel — Cancel scheduled task
# ─────────────────────────────────────────────────────────────────
echo ""
echo "── 15. schedule.cancel ──────────────────────────────────"
BODY='{"request_id":"'$(uuidgen 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")'","payload":{"schedule_id":"YOUR_SCHEDULE_ID"},"options":{"async":false}}'
sign "POST" "/agent/v1/commands/schedule.cancel" "$BODY"
curl -s -X POST "${BASE_URL}/agent/v1/commands/schedule.cancel" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: ${API_KEY_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Nonce: ${NONCE}" \
  -H "X-Signature: ${SIGNATURE}" \
  -d "$BODY" | jq .

# ─────────────────────────────────────────────────────────────────
# 16. Callback — Send test callback (loopback only, no auth)
# ─────────────────────────────────────────────────────────────────
echo ""
echo "── 16. Test Callback (loopback, no auth) ────────────────"
curl -s -X POST "http://127.0.0.1:18080/agent/v1/callbacks/morelogin" \
  -H "Content-Type: application/json" \
  -d '{
    "event_id": "test-'$(date +%s)'",
    "event_type": "profile_started",
    "source": "morelogin",
    "payload": {"profile_id": "TEST_PROFILE", "status": "running"}
  }' | jq .

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  Done! All examples executed."
echo "═══════════════════════════════════════════════════════════"

