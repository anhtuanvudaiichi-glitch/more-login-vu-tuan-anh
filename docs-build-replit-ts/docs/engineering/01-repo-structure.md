# 01-repo-structure

- Owner role: **Tech Lead**
- Status: **Ready v1.0**
- Last updated: **2026-03-30**
- Related docs: [02-module-boundaries.md](./02-module-boundaries.md), [03-coding-conventions.md](./03-coding-conventions.md), [04-dto-and-internal-api.md](./04-dto-and-internal-api.md)

## 1) Cấu trúc repo chuẩn thi công

```text
repo-root/
  apps/
    web/                # Next.js web app (UI)
    api/                # Product API (REST/SSE/Webhook)
    worker/             # Queue workers + schedulers
  packages/
    shared/             # shared types, utils, constants
    agent-client/       # ONLY layer allowed to call agent HTTP API
  docs-build-replit-ts/
    ...
  api/                  # agent API source docs (OpenAPI/guides/postman)
```

## 2) Trách nhiệm từng app/package

| Path | Trách nhiệm |
|---|---|
| `apps/web` | UI pages, feature screens, client-side interaction |
| `apps/api` | Auth, domain services orchestration, webhook ingest, API facade |
| `apps/worker` | Async processing: polling jobs, campaign batch, retries, retention jobs |
| `packages/shared` | Domain DTO, error code enum, event constants, validation schemas |
| `packages/agent-client` | HMAC signing, retry, envelope parsing, command wrappers |

## 3) Boundary cứng

- `apps/web` không gọi agent API trực tiếp.
- `apps/api` và `apps/worker` chỉ gọi agent qua `packages/agent-client`.
- `packages/shared` không phụ thuộc `apps/*`.
- `packages/agent-client` không phụ thuộc domain module cụ thể.

## 4) Script tối thiểu

- Root:
- `pnpm lint`
- `pnpm test`
- `pnpm build`
- `pnpm -r typecheck`
- App-specific:
- `apps/web`: `dev`, `build`, `start`
- `apps/api`: `dev`, `build`, `start`
- `apps/worker`: `dev`, `start`

## 5) Quy tắc commit và version

- Conventional commits: `feat|fix|docs|refactor|chore`.
- Tag release: `vX.Y.Z`.
- Mọi thay đổi contract phải link change request.
