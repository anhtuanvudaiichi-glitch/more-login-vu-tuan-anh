# 08-REPLIT-DEPLOYMENT-AND-ENV-SETUP

## 1) Mục tiêu

Thiết lập môi trường Replit để web tools chạy ổn định, kết nối an toàn tới agent Python MoreLogin, và sẵn sàng cho kiểm thử/go-live.

## 2) Kiến trúc triển khai

- Replit chạy:
- Web UI (TypeScript)
- Product API (TypeScript)
- Worker (TypeScript)
- Agent chạy ngoài Replit trên node có MoreLogin.

## 3) Biến môi trường bắt buộc

| Biến | Bắt buộc | Mô tả |
|---|---|---|
| `APP_ENV` | Yes | `dev/staging/prod` |
| `APP_BASE_URL` | Yes | URL web tools |
| `DATABASE_URL` | Yes | PostgreSQL connection |
| `REDIS_URL` | Yes | Redis/BullMQ connection |
| `AGENT_BASE_URL` | Yes | URL endpoint agent (HTTPS/public/tunnel) |
| `AGENT_API_KEY` | Yes | API key ID cho HMAC |
| `AGENT_API_SECRET` | Yes | API key secret cho HMAC |
| `CALLBACK_KEY_SECRET` | Yes | Secret verify callback từ agent |
| `LOG_LEVEL` | Yes | `info/warn/error/debug` |
| `FEATURE_FLAGS` | Optional | Toggle rollout/cutover |

## 4) Thiết lập Replit từng bước

1. Tạo Repl mới cho web tools TypeScript.
2. Cấu hình scripts: `dev`, `build`, `start`, `worker`.
3. Khai báo toàn bộ env vars trong Replit Secrets.
4. Cấu hình DB + Redis managed service.
5. Triển khai endpoint callback trên backend.
6. Kết nối tới agent bằng HTTPS + auth đầy đủ.
7. Chạy smoke test health + command sync + command async.

## 5) Kết nối Replit -> Agent an toàn

- Không expose MoreLogin local API trực tiếp.
- Chỉ expose endpoint agent có auth.
- Giới hạn IP/allowlist nếu có thể.
- Theo dõi latency và tỷ lệ lỗi theo route agent.

## 6) Setup webhook/callback

- Backend route nhận callback: ví dụ `/api/agent/callback`.
- Bắt buộc verify chữ ký callback trước khi xử lý.
- Log đầy đủ `event_id`, `trace_id`, `job_id`.
- Bật retry DLQ qua endpoint retry khi cần.

## 7) Healthcheck và giám sát

### 7.1 Endpoint nội bộ web tools

- `GET /health` (app health)
- `GET /health/dependencies` (db/redis/agent reachability)

### 7.2 Kiểm tra định kỳ phía agent

- `GET /agent/v1/health`
- `GET /agent/v1/health/upstream`
- `GET /agent/v1/diagnostics/morelogin`

### 7.3 Alert khuyến nghị

- Tăng đột biến `auth_error`.
- Tăng `rate_limit_error` liên tục.
- Tỷ lệ `transport_error` vượt ngưỡng.
- Queue backlog vượt ngưỡng vận hành.

## 8) Checklist readiness trước UAT

- [ ] Replit app chạy ổn định sau restart.
- [ ] DB + Redis + Agent connectivity pass.
- [ ] Callback verify pass với payload thật.
- [ ] Sync và async command pass.
- [ ] Logging + metrics + alert hoạt động.

## 9) Checklist readiness trước production

- [ ] Secret rotation policy đã áp dụng.
- [ ] Backup DB và restore test đã pass.
- [ ] Cutover plan và rollback plan đã duyệt.
- [ ] Có người trực on-call trong cửa sổ go-live.
