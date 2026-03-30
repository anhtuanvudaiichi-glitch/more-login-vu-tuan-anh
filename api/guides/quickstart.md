# MoreLogin Agent API - Quickstart

> Owner role: Backend Lead  
> Status: [SOURCE OF TRUTH] Approved v1.1  
> Last updated: 2026-03-30  
> Related docs: authentication.md, callbacks.md, ../openapi/agent-v1.openapi.yaml, ../../docs-build-replit-ts/11-REPLIT-BLUEPRINT.md

## 1) Scope

Quickstart nay dung de tich hop Product API/Worker voi Agent Python MoreLogin.

## 2) Placeholder policy

- `[PLACEHOLDER]`: gia tri phai thay khi deploy that.
- `[EXAMPLE]`: gia tri chi de test local.

## 3) Required runtime values

| Key | Value type |
|---|---|
| `AGENT_BASE_URL` | `[PLACEHOLDER: https://agent.example.com]` |
| `AGENT_API_KEY_ID` | `[PLACEHOLDER]` |
| `AGENT_API_KEY_SECRET` | `[PLACEHOLDER]` |
| `CALLBACK_KEY_ID` | `[PLACEHOLDER]` |
| `CALLBACK_KEY_SECRET` | `[PLACEHOLDER]` |

## 4) Auth headers

All authenticated requests must include:
- `X-API-Key`
- `X-Timestamp`
- `X-Nonce`
- `X-Signature`

Canonical string:

```text
{METHOD}\n{PATH}\n{TIMESTAMP}\n{NONCE}\n{SHA256(BODY)}
```

## 5) Minimal flow (implementation-ready)

1. Call `GET /agent/v1/health` with valid HMAC.
2. Call `POST /agent/v1/commands/profile.list` (sync smoke).
3. Call `POST /agent/v1/commands/browser.open_and_run` and get `job_id`.
4. Poll `GET /agent/v1/jobs/{job_id}` until completed/failed.
5. Verify callback at backend endpoint `POST /api/agent/callback`.

## 6) Curl template

```bash
BASE_URL="[PLACEHOLDER:https://agent.example.com]"
API_KEY_ID="[PLACEHOLDER]"
TIMESTAMP="[PLACEHOLDER:unix_seconds]"
NONCE="[PLACEHOLDER:uuid]"
SIGNATURE="[PLACEHOLDER:computed_hmac]"

curl -s "$BASE_URL/agent/v1/health" \
  -H "X-API-Key: $API_KEY_ID" \
  -H "X-Timestamp: $TIMESTAMP" \
  -H "X-Nonce: $NONCE" \
  -H "X-Signature: $SIGNATURE"
```

## 7) Deterministic verification

Dung bo vectors chinh thuc:
- `../../docs-build-replit-ts/appendices/hmac-golden-vectors.md`
- `../../docs-build-replit-ts/appendices/callback-signature-golden-vectors.md`

Neu signature tinh ra khac expected output trong vectors => integration fail.
