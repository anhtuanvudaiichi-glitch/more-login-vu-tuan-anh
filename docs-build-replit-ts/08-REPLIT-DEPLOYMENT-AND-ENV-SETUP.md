# 08-REPLIT-DEPLOYMENT-AND-ENV-SETUP

> Owner role: DevOps/Replit Engineer  
> Status: [SOURCE OF TRUTH] Approved v1.2  
> Last updated: 2026-03-30  
> Related docs: 11-REPLIT-BLUEPRINT.md, appendices/.replit.example, appendices/.replit.web.example, appendices/.replit.api.example, appendices/.replit.worker.example, appendices/replit-service-deployment-mapping.md, appendices/replit.nix.example, appendices/.env.example.md

## 1) Muc tieu

Dua bo Web Tools len Replit theo model da khoa: `1 workspace + 3 deployment services (web/api/worker)`.

## 2) Runtime model

| Service | Command dev | Command start | Port |
|---|---|---|---:|
| web | `npm run dev:web` | `npm run start:web` | 3000 |
| api | `npm run dev:api` | `npm run start:api` | 4000 |
| worker | `npm run dev:worker` | `npm run start:worker` | n/a |

## 3) Setup theo thu tu

1. Copy `appendices/.replit.example` -> `.replit` cho chế độ dev orchestrator.
2. Copy `appendices/replit.nix.example` -> `replit.nix`.
3. Khi tạo deployment services, dùng template tương ứng:
   - `appendices/.replit.web.example`
   - `appendices/.replit.api.example`
   - `appendices/.replit.worker.example`
4. Điền Replit Secrets theo `appendices/.env.example.md` và `appendices/replit-secrets-matrix.md`.
5. Deploy service `api`, verify health.
6. Deploy service `worker`, verify queue consume.
7. Deploy service `web`, verify UI flow.

## 4) Env bat buoc

- `APP_ENV`, `APP_BASE_URL`, `API_BASE_URL`
- `DATABASE_URL`, `REDIS_URL`
- `AGENT_BASE_URL`, `AGENT_API_KEY_ID`, `AGENT_API_KEY_SECRET`
- `CALLBACK_KEY_ID`, `CALLBACK_KEY_SECRET`
- `LOG_LEVEL`

## 5) Callback setup

- Route chuan: `POST /api/agent/callback` (service api).
- Verify callback signature truoc khi business processing.
- Dedupe theo `event_id`.

## 6) Smoke checks bat buoc

- [ ] `GET /health` va `GET /health/dependencies` pass.
- [ ] Call `profile.list` (sync) pass.
- [ ] Call `browser.open_and_run` + poll job pass.
- [ ] Callback verify pass voi vectors CB-001..CB-004.

## 7) Bring-up proof

Mot ky su khac phai dung duoc env moi bang template copy-paste ma khong hoi lai,
va nop evidence gom request_id/job_id/log/screenshot theo checklist trong:
- `11-REPLIT-BLUEPRINT.md`
- `appendices/replit-bringup-proof-checklist.md`
