# callback-signature-golden-vectors

> Owner role: Backend Lead + QA Lead  
> Status: [SOURCE OF TRUTH] Approved v1.0  
> Last updated: 2026-03-30  
> Related docs: ../../api/guides/callbacks.md, hmac-golden-vectors.md, ../09-TEST-PLAN-AND-UAT.md

## 1) Dinh danh bo vector

- `[EXAMPLE] CALLBACK_KEY_ID`: `agent-callback-vector`
- `[EXAMPLE] CALLBACK_KEY_SECRET`: `example_callback_secret_for_vectors_2026`
- Callback endpoint backend dung de verify: `/api/agent/callback`

Canonical callback:

```text
POST\n{PATH}\n{TIMESTAMP}\n{NONCE}\n{SHA256(BODY)}
```

## 2) Bang vectors

| ID | Scenario | Timestamp | Nonce | Expected HTTP | Expected error |
|---|---|---|---|---:|---|
| CB-001 | valid signature | `1760000100` | `aaaa1111-1111-1111-1111-111111111111` | 200 | none |
| CB-002 | duplicate event_id | `1760000101` | `bbbb2222-2222-2222-2222-222222222222` | 200/409 theo policy dedupe | none/replay marker |
| CB-003 | expired timestamp | `1750000100` | `cccc3333-3333-3333-3333-333333333333` | 401 | `auth_error` |
| CB-004 | invalid signature | `1760000100` | `aaaa1111-1111-1111-1111-111111111111` | 401 | `auth_error` |

## 3) Expected details

### CB-001

- Body SHA256: `aff1e967ca1b10fca7a5217a90da5865473812561bd2352d95f470ac5b2200d8`
- Canonical:

```text
POST
/api/agent/callback
1760000100
aaaa1111-1111-1111-1111-111111111111
aff1e967ca1b10fca7a5217a90da5865473812561bd2352d95f470ac5b2200d8
```

- Expected signature: `bbc6deed1dad7959929a06518a2f86be3ce4d37c3fe2643bf140865880a82992`

### CB-002

- Body SHA256: `aff1e967ca1b10fca7a5217a90da5865473812561bd2352d95f470ac5b2200d8`
- Canonical:

```text
POST
/api/agent/callback
1760000101
bbbb2222-2222-2222-2222-222222222222
aff1e967ca1b10fca7a5217a90da5865473812561bd2352d95f470ac5b2200d8
```

- Expected signature: `1fae976da152be0499262f98107caa27fada1f6464c179efeb0c3c66454c926c`
- Expected processing: event trung `event_id` khong tao duplicate record.

### CB-003

- Body SHA256: `889c8841cfe7733311912afe90f5aa56b09cca060f14b65fe46344b822e032d5`
- Canonical:

```text
POST
/api/agent/callback
1750000100
cccc3333-3333-3333-3333-333333333333
889c8841cfe7733311912afe90f5aa56b09cca060f14b65fe46344b822e032d5
```

- Expected signature: `066f4b30eee06effbd2f1af08554de38a71e4c792d725fe6f07bacec67d3d228`
- Expected processing: reject vi timestamp het han.

### CB-004

- Body va canonical giong CB-001.
- Header signature gui len co chu ky sai vi du: `cbc6deed1dad7959929a06518a2f86be3ce4d37c3fe2643bf140865880a82992`.
- Expected processing: reject `auth_error`.

## 4) Rule nghiem thu

- Ky su Backend va QA verify doc lap phai trung expected signature.
- Test callback duplicate phai chung minh idempotency thong qua `event_id`.
- Log bat buoc: `event_id`, `trace_id`, `job_id`, `x-nonce`, `x-timestamp`.
