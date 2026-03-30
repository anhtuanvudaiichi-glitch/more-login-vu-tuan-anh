# MoreLogin Agent API - Authentication

> Owner role: Backend Lead  
> Status: [SOURCE OF TRUTH] Approved v1.1  
> Last updated: 2026-03-30  
> Related docs: quickstart.md, callbacks.md, ../../docs-build-replit-ts/appendices/hmac-golden-vectors.md

## 1) Scope

Tat ca `/agent/v1/*` endpoints yeu cau HMAC, ngoai tru:
- `POST /agent/v1/callbacks/morelogin` khi goi tu loopback (`127.0.0.1`).

## 2) Credentials convention

- `X-API-Key`: `[PLACEHOLDER: AGENT_API_KEY_ID]`
- Secret ky: `[PLACEHOLDER: AGENT_API_KEY_SECRET]`

Khong su dung secret demo trong production.

## 3) Required headers

| Header | Value |
|---|---|
| `X-API-Key` | API key id |
| `X-Timestamp` | unix seconds |
| `X-Nonce` | fresh uuid |
| `X-Signature` | hmac sha256 lowercase hex |

## 4) Canonical and signature

```text
canonical = {METHOD}\n{PATH}\n{TIMESTAMP}\n{NONCE}\n{SHA256(BODY)}
signature = HMAC_SHA256_HEX(AGENT_API_KEY_SECRET, canonical)
```

Rules:
- `METHOD` uppercase.
- `PATH` path-only (khong query string).
- `SHA256(BODY)` la lowercase hex tren raw bytes.
- GET/no-body dung hash cua empty bytes.

## 5) Replay protection

- Timestamp window: 120s.
- Nonce TTL: 300s.
- Body max size: 2MB.

## 6) Golden vectors (bat buoc)

Bo vectors chinh thuc: `../../docs-build-replit-ts/appendices/hmac-golden-vectors.md`

Backend + QA phai verify doc lap:
- HMAC-001..HMAC-004: pass signatures.
- HMAC-005: fail expired timestamp.
- HMAC-006: fail replay nonce lan 2.

## 7) Error handling

| Error type | HTTP | Retry |
|---|---:|---|
| `auth_error` | 401 | No |
| `replay_error` | 401 | No |
| `rate_limit_error` | 429 | Yes (Retry-After) |
| `transport_error` | 5xx | Yes (backoff+jitter) |

## 8) Example signer (for testing only)

```javascript
// [EXAMPLE] Postman/Node style
const canonical = `${method}\n${path}\n${timestamp}\n${nonce}\n${bodyHash}`;
const signature = CryptoJS.HmacSHA256(canonical, apiKeySecret).toString();
```
