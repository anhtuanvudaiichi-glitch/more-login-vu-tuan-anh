# 09-TEST-PLAN-AND-UAT

> Owner role: QA Lead  
> Status: [SOURCE OF TRUTH] Approved v1.1  
> Last updated: 2026-03-30  
> Related docs: appendices/fixture-samples.md, appendices/test-fixture-matrix.csv, appendices/hmac-golden-vectors.md, appendices/callback-signature-golden-vectors.md

## 1) Muc tieu

Bao dam doi QA/Backend co the test ngay ma khong tu tao payload.

## 2) Test layers

| Layer | Scope | Du lieu dau vao |
|---|---|---|
| Unit | logic module | fixture request/response |
| Integration | api <-> agent-client <-> agent | golden vectors + fixture pack |
| Contract | auth/callback/retry envelope | OpenAPI + Postman + vectors |
| UAT | P0/P1 business flows | fixture matrix + evidence checklist |

## 3) Scenario mapping (P0/P1)

| ID | Scenario | Priority | Fixture ID | Evidence ID |
|---|---|---|---|---|
| T-ACC-01 | profile.list success | P0 | FX-REQ-001 | EVD-001 |
| T-ACC-02 | profile.start + profile.status | P0 | FX-REQ-002, FX-REQ-003 | EVD-002, EVD-003 |
| T-CMP-02 | async job completed/failed | P0 | FX-REQ-004, FX-REQ-005 | EVD-004, EVD-005 |
| T-CMP-03 | 429 retry | P1 | FX-REQ-006 | EVD-006 |
| T-CMP-04 | 503 retry | P1 | FX-REQ-007 | EVD-007 |
| T-INB-02 | duplicate callback dedupe | P0 | FX-REQ-008 | EVD-008 |
| T-SEC-01 | HMAC vectors HMAC-001..006 | P0 | hmac-golden-vectors | EVD-009 |
| T-SEC-02 | Callback vectors CB-001..004 | P0 | callback-signature-golden-vectors | EVD-010 |

## 4) Performance baseline

| Metric | Threshold pass |
|---|---|
| profile.list p95 | <= 800ms |
| async job callback latency p95 | <= 5s |
| queue backlog during steady load | <= 500 |
| transport retry success ratio | >= 95% |

## 5) Evidence format bat buoc

Moi evidence ID phai co:
- screenshot (neu la UAT flow)
- request/response log
- `request_id` va/hoac `job_id`
- ket luan pass/fail

## 6) Dieu kien pass release

- 100% test P0 pass.
- >=95% test P1 pass.
- Khong co bug Sev-1/Sev-2 mo.
- Co bien ban sign-off QA + Tech Lead + PM.
