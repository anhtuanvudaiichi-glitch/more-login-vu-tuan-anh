# hmac-golden-vectors

> Owner role: Backend Lead + QA Lead  
> Status: [SOURCE OF TRUTH] Approved v1.0  
> Last updated: 2026-03-30  
> Related docs: ../07-SECURITY-AUTH-COMPLIANCE.md, ../06-AGENT-API-CONTRACT-MAPPING.md, ../../api/guides/authentication.md

## 1) Dinh danh bo vector

- `[EXAMPLE] API_KEY_ID`: `vector-key-001`
- `[EXAMPLE] API_KEY_SECRET`: `example_hmac_secret_for_vectors_2026`
- Canonical format (bat buoc):

```text
{METHOD}\n{PATH}\n{TIMESTAMP}\n{NONCE}\n{SHA256(BODY)}
```

## 2) Bang vectors

| ID | Scenario | Method | Path | Timestamp | Nonce | Expected HTTP | Expected error |
|---|---|---|---|---|---|---:|---|
| HMAC-001 | GET no-body pass | GET | `/agent/v1/health` | `1760000000` | `11111111-1111-1111-1111-111111111111` | 200 | none |
| HMAC-002 | POST empty-body pass | POST | `/agent/v1/commands/profile.list` | `1760000001` | `22222222-2222-2222-2222-222222222222` | 200 | none |
| HMAC-003 | POST JSON nho pass | POST | `/agent/v1/commands/profile.start` | `1760000002` | `33333333-3333-3333-3333-333333333333` | 200 | none |
| HMAC-004 | POST JSON unicode pass | POST | `/agent/v1/commands/browser.open_and_run` | `1760000003` | `44444444-4444-4444-4444-444444444444` | 202 | none |
| HMAC-005 | Expired timestamp fail | GET | `/agent/v1/health` | `1750000000` | `55555555-5555-5555-5555-555555555555` | 401 | `auth_error` |
| HMAC-006 | Replay nonce fail | POST | `/agent/v1/commands/profile.status` | `1760000004` | `66666666-6666-6666-6666-666666666666` | 401 (lan 2) | `auth_error`/`replay_error` |

## 3) Chi tiet expected output

### HMAC-001

- Raw body: empty string
- Body SHA256: `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`
- Canonical string:

```text
GET
/agent/v1/health
1760000000
11111111-1111-1111-1111-111111111111
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
```

- Expected signature: `d5d5bc3386b20c388e8c772b9a657c663eafd24006bf852505dc2931164c788c`

### HMAC-002

- Raw body: empty string
- Body SHA256: `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`
- Canonical string:

```text
POST
/agent/v1/commands/profile.list
1760000001
22222222-2222-2222-2222-222222222222
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
```

- Expected signature: `a0778d70524aa85afa89257e8b0dc2eb252604cad70bcdaf8e40f4fea4f37170`

### HMAC-003

- Raw body:

```json
{"request_id":"test-003","target":{"profile_id":"PROFILE_001"},"payload":{"is_headless":false},"options":{"async":false}}
```

- Body SHA256: `43105408d4d156a5fd3893da7ad39c1999ebb17e0d41d6ccde2d9d3239536b20`
- Canonical string:

```text
POST
/agent/v1/commands/profile.start
1760000002
33333333-3333-3333-3333-333333333333
43105408d4d156a5fd3893da7ad39c1999ebb17e0d41d6ccde2d9d3239536b20
```

- Expected signature: `68690b061ac2e59edde4ed7bae4d33ec5527c275e38574ab156db3a21bc78e9b`

### HMAC-004

- Raw body:

```json
{"request_id":"test-004","target":{"profile_id":"PROFILE_001"},"payload":{"script":"return \"Xin chào\";"},"options":{"async":true}}
```

- Body SHA256: `d8d7099dd146db13bd38c1bdf1d178619a5a60a5cc59a9df2a3d2001fd81cfeb`
- Canonical string:

```text
POST
/agent/v1/commands/browser.open_and_run
1760000003
44444444-4444-4444-4444-444444444444
d8d7099dd146db13bd38c1bdf1d178619a5a60a5cc59a9df2a3d2001fd81cfeb
```

- Expected signature: `b16f0a4993ae5d613335ded7aff913259e2e87912deac4ea4dcee88144b1f35e`

### HMAC-005

- Raw body: empty string
- Body SHA256: `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`
- Expected signature: `04d90126fb4f00867f50e17a18881d0a095f3c75dd9493921e0bddd633df834e`
- Expected result: reject do timestamp het han (ngoai cua so 120s).

### HMAC-006

- Raw body:

```json
{"request_id":"test-006","target":{"profile_id":"PROFILE_001"},"options":{"async":false}}
```

- Body SHA256: `48d817a7a1cc8f7e0b45351c72a3bc4842f7640783f8570971e9a83e53ca6304`
- Expected signature: `3f2a370ebe9bb83cdeead4cbf84f00572cca84336a9f2aad758051afcac4e6be`
- Expected result:
  - Lan 1: pass neu timestamp hop le.
  - Lan 2 (cung nonce trong TTL): reject replay.

## 4) Rule nghiem thu

- Backend va QA tinh doc lap phai ra dung signature nhu tren.
- Neu sai 1 ky tu signature/canonical/body-hash => fail.
- Postman test phai assert theo bo vector nay.
