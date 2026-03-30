# 04-MODULE-BUILD-SPECS

## 1) Chuẩn áp dụng cho mọi module

- Ngôn ngữ triển khai: TypeScript.
- Runtime: Replit.
- Tích hợp ngoài: chỉ qua `AgentClient`.
- Mọi endpoint nghiệp vụ phải có audit log và correlation id.

## 2) Module IAM & Tenant

### Mục tiêu

Quản lý người dùng, vai trò, phân quyền theo tenant/workspace/team.

### Yêu cầu chức năng

- Đăng nhập, phân quyền RBAC theo vai trò `admin/manager/staff`.
- Scope theo workspace/team.
- Audit mọi hành động nhạy cảm.

### API nội bộ dự kiến

- `POST /api/auth/login`
- `GET /api/me`
- `POST /api/users`
- `PATCH /api/users/{id}/role`

### Acceptance

- Không user nào truy cập tài nguyên ngoài scope.
- Có log đầy đủ cho create/update/delete user và phân quyền.

## 3) Module Account & Session

### Mục tiêu

Quản lý tài khoản Zalo nội bộ và mapping profile môi trường qua agent.

### Yêu cầu chức năng

- Danh sách tài khoản + trạng thái health.
- Gán profile_id cho account.
- Start/stop/check status profile qua command agent.

### Agent command dùng

- `profile.list`
- `profile.start`
- `profile.stop`
- `profile.status`

### Acceptance

- Account actions thành công theo đúng envelope agent.
- Khi agent lỗi retryable, hệ thống retry đúng policy.

## 4) Module Unified Inbox

### Mục tiêu

Tập trung hội thoại đa tài khoản, không bỏ sót xử lý.

### Yêu cầu chức năng

- Nhận callback event, tạo/cập nhật conversation.
- Trạng thái message theo state machine.
- Gán người xử lý, tag, ghi chú.

### Tích hợp

- Callback ingest từ agent endpoint forward.
- Verify callback signature bắt buộc.

### Acceptance

- Không tạo trùng conversation cho cùng event_id.
- SLA xử lý hội thoại đo được theo dashboard.

## 5) Module CRM & Data

### Mục tiêu

Lưu trữ khách hàng, phân nhóm tag, phục vụ campaign.

### Yêu cầu chức năng

- Upsert customer theo identity resolution.
- Tag, note, assignment.
- Import CSV/XLSX có validate + error report.

### Acceptance

- Dữ liệu import có lineage và thống kê lỗi.
- Chống trùng profile khách theo key định danh.

## 6) Module Campaign & Scheduler

### Mục tiêu

Chạy chiến dịch gửi tin có lịch, có progress, pause/resume.

### Yêu cầu chức năng

- Tạo chiến dịch, audience, template.
- Queue per-recipient, idempotency key per-recipient.
- Theo dõi trạng thái `queued/running/completed/failed`.

### Agent command liên quan

- `browser.open_and_run` (always async)
- `schedule.create` (always async)
- `schedule.cancel`
- `file.attach_from_url`, `file.download` (nếu workflow cần)

### Acceptance

- Không gửi trùng cho cùng recipient trong cùng campaign step.
- Có thể pause/resume không mất trạng thái.

## 7) Module Reports

### Mục tiêu

Tổng hợp chỉ số vận hành theo tài khoản, team, campaign.

### Yêu cầu chức năng

- Dashboard tổng quan theo thời gian.
- Top khách hàng/tỉ lệ xử lý/tỉ lệ thành công campaign.
- Truy vết theo request_id/job_id.

### Acceptance

- Báo cáo khớp với dữ liệu nguồn theo mẫu kiểm tra QA.

## 8) Module Admin & Operations

### Mục tiêu

Quản trị vận hành: audit, backup/restore, monitoring.

### Yêu cầu chức năng

- Xem audit log theo filter.
- Runbook backup/restore.
- Cảnh báo khi mất kết nối agent hoặc queue backlog tăng.

### Acceptance

- Có thể phục hồi theo quy trình rollback đã tài liệu hóa.
- Alert được trigger đúng ngưỡng cấu hình.

## 9) Module Agent Integration Layer (AgentClient)

### Mục tiêu

Là cổng duy nhất gọi agent API từ web tools.

### Yêu cầu chức năng

- HMAC signing chuẩn.
- Retry policy theo `error.retryable` + `Retry-After`.
- Chuẩn hóa response envelope.
- Quản lý timeout/circuit breaker.

### Acceptance

- Contract tests pass cho tất cả endpoint agent đang dùng.
- Không còn call HTTP trực tiếp agent ở các module khác.

## 10) Checklist hoàn thành module

- [ ] Đã có đặc tả API nội bộ/DTO.
- [ ] Đã có mapping agent endpoint/command.
- [ ] Đã có unit + integration test.
- [ ] Đã có audit log + error handling.
- [ ] Đã có tài liệu runbook cơ bản cho module.
