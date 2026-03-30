# 07-SECURITY-AUTH-COMPLIANCE

## 1) Mục tiêu

- Bảo vệ tích hợp Replit -> Agent khỏi giả mạo, replay, lộ secret.
- Bảo vệ dữ liệu khách hàng (PII) và lịch sử thao tác.
- Đảm bảo auditability cho toàn bộ thao tác nhạy cảm.

## 2) Chính sách auth cho agent API

### 2.1 Bắt buộc

- Dùng HMAC-SHA256 cho tất cả endpoint yêu cầu auth.
- Không hard-code `api_key_secret` trong source code.
- Đồng bộ thời gian server để tránh lỗi timestamp window 120s.

### 2.2 Key management

- Tên biến môi trường:
- `AGENT_API_KEY`
- `AGENT_API_SECRET`
- `AGENT_BASE_URL`
- Rotation key theo chu kỳ (khuyến nghị 30-90 ngày).
- Hỗ trợ dual-key rollout để đổi key không downtime.

## 3) Callback security

- Verify `X-Timestamp`, `X-Nonce`, `X-Signature` cho callback outbound từ agent.
- Reject callback nếu signature không hợp lệ hoặc quá replay window.
- Lưu `event_id` để dedup, chống xử lý lặp.

## 4) Bảo mật dữ liệu và PII

| Hạng mục | Yêu cầu |
|---|---|
| Dữ liệu nhạy cảm | Mã hóa at-rest và in-transit |
| Export file | URL ký số, thời hạn ngắn |
| Nhật ký | Không log secret/token raw |
| Quyền truy cập | Least privilege theo role |

## 5) RBAC và audit bắt buộc

- Mọi action thay đổi dữ liệu phải có audit record.
- Audit record tối thiểu gồm:
- `actor_id`
- `tenant_id`
- `action`
- `target_type`
- `target_id`
- `request_id`
- `timestamp`
- `result`

## 6) Chính sách tuân thủ dữ liệu

- Có cờ consent theo customer.
- Có retention policy theo loại dữ liệu.
- Có cơ chế masking theo role khi xem dữ liệu.

## 7) Hardening checklist trước production

- [ ] Secrets chỉ lưu trong secret manager/Replit Secrets.
- [ ] Chặn endpoint admin nội bộ khỏi public internet không kiểm soát.
- [ ] Bật TLS cho kết nối Replit -> Agent.
- [ ] Bật rate limit phía web tools và theo dõi 429 phía agent.
- [ ] Bật alert khi auth_error tăng đột biến.
- [ ] Chạy security review cho callback verification path.

## 8) Incident response security

| Tình huống | Hành động ngay |
|---|---|
| Nghi lộ API secret | Rotate key, revoke key cũ, rà soát logs |
| Auth error hàng loạt | Kiểm tra clock drift, canonical path, key mismatch |
| Callback giả mạo | Tạm khóa endpoint, bật strict signature checks, điều tra |
| Truy cập trái phép dữ liệu | Thu hồi session/token, cô lập tenant ảnh hưởng, báo cáo incident |

## 9) Hồ sơ chứng cứ compliance

Chuẩn bị và lưu trữ:
- Security checklist đã ký.
- Biên bản key rotation.
- Biên bản drill incident.
- Bằng chứng audit log truy vết từ request đến hành động.
