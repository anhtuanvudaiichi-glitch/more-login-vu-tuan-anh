# fixture-samples

> Owner role: QA Lead + Backend Lead  
> Status: [SOURCE OF TRUTH] Approved v1.0  
> Last updated: 2026-03-30  
> Related docs: test-fixture-matrix.csv, ../09-TEST-PLAN-AND-UAT.md, ../../api/examples/fixtures

## 1) Cau truc fixture

Moi fixture gom:
- request JSON
- response JSON
- callback JSON (neu co)
- expected DB state
- expected log fields
- expected idempotency behavior

## 2) Danh muc fixture chuan

| Fixture ID | Request | Response | Callback | Muc tieu |
|---|---|---|---|---|
| FX-REQ-001 | `requests/profile.list.request.json` | `responses/profile.list.response.json` | n/a | profile list sync |
| FX-REQ-002 | `requests/profile.start.request.json` | `responses/profile.start.response.json` | `callbacks/profile.started.callback.json` | profile start + callback |
| FX-REQ-003 | `requests/profile.status.request.json` | `responses/profile.status.response.json` | n/a | profile status sync |
| FX-REQ-004 | `requests/browser.open_and_run.request.json` | `responses/browser.open_and_run.accepted.response.json` | `callbacks/job.completed.callback.json` | async success |
| FX-REQ-005 | `requests/browser.open_and_run.request.json` | `responses/browser.open_and_run.accepted.response.json` | `callbacks/job.failed.callback.json` | async fail |
| FX-REQ-006 | `requests/profile.list.request.json` | `responses/rate_limit.error.response.json` | n/a | 429 retry |
| FX-REQ-007 | `requests/profile.list.request.json` | `responses/transport.error.response.json` | n/a | 503 retry |
| FX-REQ-008 | n/a | n/a | `callbacks/duplicate.event.callback.json` | dedupe event |

## 3) Expected DB state mau

- Sau `FX-REQ-002`: account status `running`, co audit log action `profile.start`.
- Sau `FX-REQ-004`: co record `job_run` status `completed` + campaign delivery update.
- Sau `FX-REQ-005`: co record `job_run` status `failed` + retry count tang.
- Sau `FX-REQ-008`: khong them ban ghi callback_event moi, `dedupe_hit=true`.

## 4) Expected log fields toi thieu

- `request_id`
- `job_id` (neu async)
- `event_id` (neu callback)
- `trace_id`
- `correlation_id`
- `error.type` (neu fail)

## 5) Rule deterministic

- Fixture payload khong thay doi thu tu field neu tham chieu golden vectors.
- Test rerun 3 lan phai cho ket qua pass/fail nhu nhau.
