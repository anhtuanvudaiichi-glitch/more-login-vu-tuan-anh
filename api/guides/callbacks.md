# MoreLogin Agent API - Callbacks

> Owner role: Backend Lead + QA Lead  
> Status: [SOURCE OF TRUTH] Approved v1.1  
> Last updated: 2026-03-30  
> Related docs: authentication.md, ../../docs-build-replit-ts/appendices/callback-signature-golden-vectors.md, ../../docs-build-replit-ts/11-REPLIT-BLUEPRINT.md

## 1) Callback model

- Agent ingest callback from MoreLogin:
  - `POST /agent/v1/callbacks/morelogin`
- Agent forward callback outbound to backend:
  - `POST [PLACEHOLDER: https://api.example.com/api/agent/callback]`

## 2) Outbound callback headers from agent

- `X-Agent-Id`
- `X-Timestamp`
- `X-Nonce`
- `X-Signature`
- `Content-Type: application/json`

## 3) Callback signature verification

Canonical:

```text
POST\n{PATH}\n{TIMESTAMP}\n{NONCE}\n{SHA256(BODY)}
```

Signature:

```text
X-Signature = HMAC_SHA256_HEX(CALLBACK_KEY_SECRET, canonical)
```

`PATH` mac dinh backend: `/api/agent/callback`.

## 4) Golden vectors (bat buoc)

Dung bo vectors chinh thuc:
`../../docs-build-replit-ts/appendices/callback-signature-golden-vectors.md`

- CB-001: valid signature -> pass.
- CB-002: duplicate event_id -> dedupe.
- CB-003: expired timestamp -> reject.
- CB-004: invalid signature -> reject.

## 5) Retry and dead-letter

- Retry backoff: 1s -> 2s -> 4s -> 8s -> 16s -> 30s -> 30s -> 30s.
- Max attempts: 8.
- Dead-letter retry endpoint:
  - `POST /agent/v1/local-ops/callbacks/dead-letter/{event_id}/retry` (loopback-only).

## 6) Processing requirements at backend

- Verify signature truoc business handling.
- Dedupe theo `event_id`.
- Log bat buoc: `event_id`, `trace_id`, `job_id`, `x-nonce`, `x-timestamp`.
- Neu invalid signature/timestamp: tra 401, khong xu ly tiep.
