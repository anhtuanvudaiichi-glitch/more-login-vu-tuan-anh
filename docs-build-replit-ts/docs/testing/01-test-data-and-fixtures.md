# 01-test-data-and-fixtures

- Owner role: **QA Lead**
- Status: **Ready v1.0**
- Last updated: **2026-03-30**
- Related docs: [02-contract-test-vectors.md](./02-contract-test-vectors.md), [03-feature-to-test-matrix.md](./03-feature-to-test-matrix.md), [../../appendices/feature-traceability-matrix.csv](../../appendices/feature-traceability-matrix.csv)

## 1) Test data sets

| Set ID | Mục tiêu |
|---|---|
| TD-CORE-001 | tenant/workspace/user/role baseline |
| TD-ACC-001 | account/profile/proxy states |
| TD-CRM-001 | customer with consent variants |
| TD-INB-001 | conversation/message state transitions |
| TD-CMP-001 | campaign attempts with retry scenarios |
| TD-CBK-001 | callback events valid/invalid/duplicate |

## 2) Fixture conventions

- JSON fixtures theo module:
- `fixtures/iam/*.json`
- `fixtures/account/*.json`
- `fixtures/inbox/*.json`
- `fixtures/crm/*.json`
- `fixtures/campaign/*.json`
- `fixtures/callback/*.json`

- Naming: `<module>-<scenario>-<seq>.json`

## 3) Seed/reset policy

- Seed trước suite integration bằng transaction-safe script.
- Reset sau suite bằng truncate có thứ tự FK hoặc schema sandbox per test run.
- Không dùng dữ liệu production clone trực tiếp chứa PII thật.

## 4) Mock callback payloads bắt buộc

- Callback hợp lệ signature.
- Callback sai signature.
- Callback duplicate event_id.
- Callback event type không hỗ trợ.
- Callback có payload thiếu field bắt buộc.

## 5) Evidence template khi chạy test

- Screenshot UI (nếu test E2E liên quan UI).
- Raw request/response (ẩn secret).
- request_id/job_id/event_id tương ứng.
- Log excerpt có correlation_id.
