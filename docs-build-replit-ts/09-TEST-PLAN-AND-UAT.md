# 09-TEST-PLAN-AND-UAT

## 1) Mục tiêu test

- Xác nhận web tools hoạt động đúng nghiệp vụ.
- Xác nhận tích hợp agent đúng contract auth/envelope/retry.
- Xác nhận hệ thống đạt điều kiện UAT và go-live.

## 2) Chiến lược test

| Loại test | Mục tiêu | Công cụ/đầu ra |
|---|---|---|
| Unit test | Logic module riêng lẻ | Báo cáo coverage |
| Integration test | Product API <-> AgentClient <-> Agent API | Contract test report |
| E2E test | Luồng nghiệp vụ từ UI đến backend | E2E test report |
| Performance test | Kiểm tra queue/job under load | Throughput + latency report |
| Resilience test | Kiểm tra retry/fallback khi lỗi mạng | Incident simulation report |
| UAT | Nghiệm thu theo use case nghiệp vụ | UAT sign-off |

## 3) Danh sách test scenario bắt buộc

### 3.1 IAM/Account

| ID | Scenario | Expected |
|---|---|---|
| T-IAM-01 | Đăng nhập đúng role | Trả đúng quyền theo role |
| T-ACC-01 | `profile.list` thành công | Danh sách profile hiển thị đúng |
| T-ACC-02 | `profile.start` và `profile.status` | Trạng thái account cập nhật đúng |
| T-ACC-03 | Auth lỗi chữ ký | Trả `auth_error`, không retry mù |

### 3.2 Inbox/CRM

| ID | Scenario | Expected |
|---|---|---|
| T-INB-01 | Callback event mới | Tạo conversation/message mới |
| T-INB-02 | Callback trùng `event_id` | Dedupe, không tạo bản ghi trùng |
| T-CRM-01 | Tag và phân công khách | Dữ liệu lưu đúng, audit có record |
| T-CRM-02 | Import file lỗi format | Trả error report chi tiết |

### 3.3 Campaign/Async Job

| ID | Scenario | Expected |
|---|---|---|
| T-CMP-01 | Tạo campaign batch | Job được tạo đúng theo recipient |
| T-CMP-02 | Command always async | Nhận `job_id`, poll trạng thái chuẩn |
| T-CMP-03 | `rate_limit_error` 429 | Retry theo `Retry-After` |
| T-CMP-04 | `transport_error` 503 | Retry backoff + jitter |
| T-CMP-05 | Pause/Resume campaign | Không mất trạng thái tiến trình |

### 3.4 Replit vận hành

| ID | Scenario | Expected |
|---|---|---|
| T-DEP-01 | Restart app Replit | App recover, queue không mất |
| T-DEP-02 | Mất kết nối agent tạm thời | Hệ thống fallback + alert |
| T-DEP-03 | Callback signature sai | Reject và log cảnh báo |

## 4) UAT checklist theo nghiệp vụ

- [ ] Quản lý tài khoản và trạng thái hoạt động.
- [ ] Inbox xử lý hội thoại, gán người phụ trách.
- [ ] CRM phân loại tag/segment đúng.
- [ ] Campaign chạy được, theo dõi được progress.
- [ ] Reports hiển thị đúng theo dữ liệu thực.
- [ ] Admin xem được audit log và trạng thái hệ thống.

## 5) Tiêu chí pass/fail UAT

- Pass khi:
- 100% test P0 pass.
- >=95% test P1 pass.
- Không còn bug Sev-1/Sev-2 mở.
- Có biên bản sign-off của PM + Tech Lead + QA Lead.

- Fail khi:
- Có lỗi bảo mật blocker.
- Có mismatch contract agent chưa xử lý.
- Có lỗi dữ liệu trùng/lệch ở state machine quan trọng.

## 6) Test evidence bắt buộc lưu trữ

- Báo cáo unit/integration/e2e.
- Log request/response mẫu với request_id.
- Ảnh/chụp màn hình UAT quan trọng.
- Biên bản sign-off UAT.

## 7) Quy tắc cập nhật test plan

Khi thay đổi kỹ thuật/contract, phải cập nhật cùng lúc:
- `06-AGENT-API-CONTRACT-MAPPING.md`
- `09-TEST-PLAN-AND-UAT.md`
- `10-CUTOVER-ROLLBACK-OPERATIONS.md`
