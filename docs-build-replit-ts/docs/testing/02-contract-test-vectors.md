# 02-contract-test-vectors

- Owner role: **Backend Lead + QA Lead**
- Status: **Ready v1.0**
- Last updated: **2026-03-30**
- Related docs: [01-test-data-and-fixtures.md](./01-test-data-and-fixtures.md), [../../06-AGENT-API-CONTRACT-MAPPING.md](../../06-AGENT-API-CONTRACT-MAPPING.md), [../../../api/guides/authentication.md](../../../api/guides/authentication.md)

## 1) Auth HMAC vectors

### Vector A (POST with body)

- METHOD: `POST`
- PATH: `/agent/v1/commands/profile.list`
- TIMESTAMP: `1711324800`
- NONCE: `550e8400-e29b-41d4-a716-446655440000`
- BODY: `{"request_id":"11111111-1111-1111-1111-111111111111","payload":{"page":1,"page_size":20},"options":{"async":false}}`
- Expected:
- sha256(body) deterministic
- signature deterministic with shared test secret

### Vector B (GET no body)

- METHOD: `GET`
- PATH: `/agent/v1/health`
- BODY hash = sha256(empty string)

## 2) Envelope vectors

| Case | Input | Expected |
|---|---|---|
| ENV-OK-001 | success=true,data!=null,error=null | API returns success payload |
| ENV-ERR-VAL | validation_error,retryable=false | map to INPUT_INVALID |
| ENV-ERR-AUTH | auth_error,retryable=false | map to AUTH_FAILED |
| ENV-ERR-RATE | rate_limit_error,retryable=true | retry with Retry-After |
| ENV-ERR-TRAN | transport_error,retryable=true | retry with backoff |

## 3) Async job vectors

| Case | Input | Expected |
|---|---|---|
| JOB-001 | always-async command | receives job_id |
| JOB-002 | job status queued->running->completed | progress updates correctly |
| JOB-003 | job failed retryable | retry policy applies |
| JOB-004 | job failed non-retryable | mark failed and alert |

## 4) Callback signature vectors

| Case | Payload | Expected |
|---|---|---|
| CBK-SIG-OK | valid timestamp+nonce+signature | process event |
| CBK-SIG-BAD | invalid signature | reject + audit |
| CBK-REPLAY | reused nonce/event | dedup/reject |

## 5) Contract acceptance checklist

- [ ] HMAC vectors pass.
- [ ] Envelope mapping pass.
- [ ] Async polling vectors pass.
- [ ] Callback verification vectors pass.
