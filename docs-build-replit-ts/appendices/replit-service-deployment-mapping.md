# replit-service-deployment-mapping

> Owner role: DevOps Lead  
> Status: [SOURCE OF TRUTH] Approved v1.0  
> Last updated: 2026-03-30  
> Related docs: .replit.example, .replit.web.example, .replit.api.example, .replit.worker.example, ../11-REPLIT-BLUEPRINT.md

## 1) Mục tiêu

Khóa rõ template triển khai cho từng deployment service trong mô hình
`1 workspace + 3 deployment services`.

## 2) Mapping theo service

| Service | Template | Build command | Run command | Port | Health endpoint | Rollback impact |
|---|---|---|---|---:|---|---|
| web | `.replit.web.example` | `npm run build:web` | `npm run start:web` | 3000 | `GET /health` (web gateway) | Ảnh hưởng UI, API/worker vẫn hoạt động |
| api | `.replit.api.example` | `npm run build:api` | `npm run start:api` | 4000 | `GET /health`, `GET /health/dependencies` | Ảnh hưởng endpoint nghiệp vụ + callback |
| worker | `.replit.worker.example` | `npm run build:worker` | `npm run start:worker` | n/a | worker heartbeat metric | Delay async jobs, queue backlog tăng |

## 3) Env tối thiểu theo service

| Env | web | api | worker |
|---|---|---|---|
| `APP_ENV` | Yes | Yes | Yes |
| `APP_BASE_URL` | Yes | Optional | Optional |
| `API_BASE_URL` | Yes | Optional | Optional |
| `DATABASE_URL` | No | Yes | Yes |
| `REDIS_URL` | No | Yes | Yes |
| `AGENT_BASE_URL` | No | Yes | Yes |
| `AGENT_API_KEY_ID` | No | Yes | Yes |
| `AGENT_API_KEY_SECRET` | No | Yes | Yes |
| `CALLBACK_KEY_ID` | No | Yes | No |
| `CALLBACK_KEY_SECRET` | No | Yes | No |

## 4) Startup order bắt buộc

1. api
2. worker
3. web

## 5) Rollback order khuyến nghị

1. web
2. api
3. worker

## 6) Checklist triển khai nhanh

- [ ] Đúng template cho đúng service.
- [ ] Đủ env bắt buộc theo bảng mapping.
- [ ] Smoke pass cho health + auth + callback + async job.
