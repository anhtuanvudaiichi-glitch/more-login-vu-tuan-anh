# 01-replit-runtime-setup

> Owner role: DevOps Lead  
> Status: [SOURCE OF TRUTH] Approved v1.1  
> Last updated: 2026-03-30  
> Related docs: [../../11-REPLIT-BLUEPRINT.md](../../11-REPLIT-BLUEPRINT.md), [../../08-REPLIT-DEPLOYMENT-AND-ENV-SETUP.md](../../08-REPLIT-DEPLOYMENT-AND-ENV-SETUP.md), [../../appendices/replit-service-deployment-mapping.md](../../appendices/replit-service-deployment-mapping.md)

## 1) Runtime topology đã khóa

Mô hình triển khai duy nhất:
- **1 workspace Replit + 3 deployment services**
  - `web` (UI)
  - `api` (Product API + callback ingress)
  - `worker` (queue consumer + job polling)

Không triển khai theo mô hình tách rời workspace cho từng service trong phạm vi tài liệu này.

## 2) Networking model

- `web` gọi `api` theo route nội bộ/gateway.
- `api` và `worker` gọi agent qua `AGENT_BASE_URL` (HTTPS).
- Agent nằm ngoài Replit (node có MoreLogin local API).
- Không expose trực tiếp `127.0.0.1:40000` ra internet.

## 3) Secrets bắt buộc trên Replit

| Secret | Bắt buộc |
|---|---|
| `APP_ENV` | Yes |
| `APP_BASE_URL` | Yes |
| `DATABASE_URL` | Yes |
| `REDIS_URL` | Yes |
| `AGENT_BASE_URL` | Yes |
| `AGENT_API_KEY_ID` | Yes |
| `AGENT_API_KEY_SECRET` | Yes |
| `CALLBACK_KEY_SECRET` | Yes |

### Legacy -> canonical (deprecated)

| Legacy alias (không dùng mới) | Canonical key |
|---|---|
| legacy key-id alias | `AGENT_API_KEY_ID` |
| legacy key-secret alias | `AGENT_API_KEY_SECRET` |

## 4) Setup runbook theo service

1. Tạo **một workspace** và cấu hình 3 deployment services: `web`, `api`, `worker`.
2. Áp template tương ứng từ `appendices/.replit.web.example`, `appendices/.replit.api.example`, `appendices/.replit.worker.example`.
3. Set secrets vào Replit Secrets theo canonical naming.
4. Deploy `api` trước, verify health.
5. Deploy `worker`, verify queue connectivity.
6. Deploy `web`, verify UI flow.
7. Smoke test endpoint nội bộ + agent health + callback signature.

## 5) Readiness checklist

- [ ] `GET /health` pass
- [ ] `GET /health/dependencies` pass
- [ ] Agent health/upstream pass
- [ ] Worker process chạy ổn định >= 30 phút
- [ ] Callback verify test pass

## 6) Owner handoff

- DevOps Lead chịu trách nhiệm runbook này.
- Tech Lead sign-off trước release staging.
