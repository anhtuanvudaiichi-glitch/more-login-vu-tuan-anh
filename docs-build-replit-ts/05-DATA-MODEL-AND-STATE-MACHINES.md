# 05-DATA-MODEL-AND-STATE-MACHINES

## 1) Mục tiêu thiết kế dữ liệu

- Đảm bảo nhất quán dữ liệu nghiệp vụ cho inbox/CRM/campaign.
- Hỗ trợ idempotency và retry an toàn.
- Dễ audit và truy vết theo request/job/event.

## 2) Thực thể dữ liệu cốt lõi

| Entity | Mục đích | Key chính |
|---|---|---|
| Tenant | Đơn vị tổ chức | `tenant_id` |
| Workspace | Phạm vi vận hành | `workspace_id` |
| User | Tài khoản nội bộ | `user_id` |
| RolePolicy | Phân quyền | `role_id` |
| ZaloAccount | Hồ sơ tài khoản marketing | `account_id` |
| BrowserProfile | Mapping profile MoreLogin | `profile_id` |
| ProxyProfile | Metadata proxy/quality | `proxy_id` |
| Customer | Thực thể khách hàng | `customer_id` |
| Conversation | Luồng hội thoại | `conversation_id` |
| Message | Bản ghi tin nhắn | `message_id` |
| Campaign | Cấu hình chiến dịch | `campaign_id` |
| DeliveryAttempt | Gửi theo recipient | `attempt_id` |
| JobRun | Trạng thái job async | `job_id` |
| CallbackEvent | Event callback ingest | `event_id` |
| AuditLog | Nhật ký thao tác | `audit_id` |

## 3) Quan hệ dữ liệu tối thiểu

- `Tenant 1-n Workspace`
- `Workspace 1-n User`
- `Workspace 1-n ZaloAccount`
- `ZaloAccount 1-1 BrowserProfile`
- `Customer 1-n Conversation`
- `Conversation 1-n Message`
- `Campaign 1-n DeliveryAttempt`
- `JobRun` liên kết tới `Campaign` hoặc `Account` tùy loại task.
- `CallbackEvent` liên kết `JobRun`/`Conversation` theo `job_id` hoặc payload mapping.

## 4) Khóa idempotency bắt buộc

| Luồng | Idempotency Key |
|---|---|
| Gửi campaign per recipient | `{campaign_id}:{recipient_id}:{step}` |
| Xử lý callback inbound | `event_id` |
| Thao tác command quan trọng | `request_id` + `idempotency_key` |
| Import dữ liệu | `import_batch_id` + checksum file |

## 5) State machine bắt buộc

### 5.1 Job trạng thái async

`queued -> running -> completed | failed`

Điều kiện chuyển trạng thái:
- `queued -> running`: worker pick up job.
- `running -> completed`: agent trả kết quả thành công.
- `running -> failed`: retry exhausted hoặc lỗi non-retryable.

### 5.2 Message delivery

`draft -> queued -> sending -> sent -> delivered -> read`  
Nhánh lỗi: `sending -> failed`

### 5.3 Account health

`unknown -> healthy -> warning -> blocked`

Nguồn cập nhật:
- profile.status,
- tỷ lệ lỗi campaign,
- callback error events.

### 5.4 Callback event lifecycle

`received -> verified -> processed -> archived`  
Nhánh lỗi: `received -> rejected` hoặc `processed -> dead_letter`

## 6) Chính sách retry và dedup

- Retry chỉ cho lỗi retryable (`rate_limit_error`, `transport_error`, và một số upstream_business_error theo rule).
- Respect `Retry-After` khi HTTP 429.
- Dedupe callback theo `event_id` + hash payload.
- Mọi retry phải giữ nguyên `idempotency_key`.

## 7) Chỉ mục dữ liệu bắt buộc

- `DeliveryAttempt(campaign_id, recipient_id, step)` unique.
- `CallbackEvent(event_id)` unique.
- `Message(conversation_id, created_at)` index.
- `AuditLog(tenant_id, created_at)` index.
- `JobRun(status, updated_at)` index.

## 8) Data retention và phân loại dữ liệu

| Nhóm dữ liệu | Retention mặc định |
|---|---|
| Audit logs | 180 ngày |
| Callback raw events | 90 ngày |
| Message metadata | 365 ngày |
| PII export artifacts | 30 ngày |

Lưu ý: thời gian retention có thể điều chỉnh theo chính sách pháp lý nội bộ.

## 9) Checklist xác nhận model trước triển khai

- [ ] Có khóa unique cho các luồng idempotency.
- [ ] Có state machine rõ cho job/message/event.
- [ ] Có index đáp ứng truy vấn vận hành.
- [ ] Có data retention policy và masking policy.
