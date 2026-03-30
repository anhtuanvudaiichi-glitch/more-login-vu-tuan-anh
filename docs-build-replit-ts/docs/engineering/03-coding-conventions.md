# 03-coding-conventions

- Owner role: **Tech Lead**
- Status: **Ready v1.0**
- Last updated: **2026-03-30**
- Related docs: [04-dto-and-internal-api.md](./04-dto-and-internal-api.md), [../../07-SECURITY-AUTH-COMPLIANCE.md](../../07-SECURITY-AUTH-COMPLIANCE.md)

## 1) Naming conventions

| Artifact | Convention | Ví dụ |
|---|---|---|
| Route path | kebab-case | `/api/campaign-delivery` |
| Service class | PascalCase + `Service` | `CampaignService` |
| Repository | PascalCase + `Repository` | `MessageRepository` |
| DTO | PascalCase + `Dto` | `CreateCampaignDto` |
| Event name | dot.case | `campaign.delivery.updated` |
| Constant | UPPER_SNAKE_CASE | `MAX_RETRY_ATTEMPTS` |
| File name | kebab-case | `campaign-service.ts` |

## 2) Logging conventions

- Structured JSON log bắt buộc fields:
- `timestamp`
- `level`
- `service`
- `module`
- `request_id`
- `correlation_id`
- `actor_id` (nếu có)
- `message`
- `error_type` (nếu có)

## 3) Error mapping conventions

- App-level errors map từ agent envelope:
- `auth_error -> AUTH_FAILED`
- `validation_error -> INPUT_INVALID`
- `rate_limit_error -> RATE_LIMITED`
- `transport_error -> AGENT_UNAVAILABLE`
- `upstream_business_error -> UPSTREAM_REJECTED`

- Không throw raw upstream messages trực tiếp ra client end-user.

## 4) Correlation ID conventions

- Mọi request vào API phải có `request_id`.
- Nếu chưa có từ client thì server sinh UUIDv4.
- `correlation_id` giữ xuyên suốt từ API -> worker -> agent calls -> callback handling.

## 5) Audit logging conventions

- Audit ở các hành động mutate state/config/security.
- Mẫu audit record:
- `actor_id`, `action`, `target_type`, `target_id`, `request_id`, `result`, `metadata`.

## 6) Code quality conventions

- TypeScript strict mode bật.
- Không dùng `any` nếu không có lý do tài liệu hóa.
- Validate input bằng schema (Zod/validator).
- Tách command handlers nhỏ, tránh function > 80 dòng nếu không cần thiết.

## 7) Security conventions

- Không log secret/token/signature raw.
- Không commit credentials vào repo.
- HMAC signing tập trung tại `packages/agent-client`.

## 8) Definition of Done cho coding conventions

- [ ] ESLint/format rules thống nhất toàn repo.
- [ ] Error mapping table được implement và test.
- [ ] Logging schema được enforce trong app/api/worker.
