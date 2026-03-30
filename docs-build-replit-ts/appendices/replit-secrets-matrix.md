# replit-secrets-matrix

> Owner role: DevOps/Replit Engineer  
> Status: [SOURCE OF TRUTH] Approved v1.0  
> Last updated: 2026-03-30  
> Related docs: .env.example.md, 08-REPLIT-DEPLOYMENT-AND-ENV-SETUP.md

| Secret | Noi su dung | Dinh dang | Bat buoc | Rotation owner | Chu ky rotation |
|---|---|---|---|---|---|
| `AGENT_API_KEY_ID` | `api`, `worker` | string | Yes | Backend Lead | 90 ngay |
| `AGENT_API_KEY_SECRET` | `api`, `worker` | string (>=32) | Yes | Backend Lead | 90 ngay |
| `CALLBACK_KEY_ID` | `api` | string | Yes | Backend Lead | 90 ngay |
| `CALLBACK_KEY_SECRET` | `api` | string (>=32) | Yes | Backend Lead | 90 ngay |
| `DATABASE_URL` | `api`, `worker` | URI | Yes | DevOps Lead | 180 ngay |
| `REDIS_URL` | `api`, `worker` | URI | Yes | DevOps Lead | 180 ngay |
| `SESSION_SECRET` | `web`, `api` | string (>=32) | Yes | Tech Lead | 90 ngay |
| `JWT_SIGNING_KEY` | `api` | PEM/base64 | Optional | Tech Lead | 180 ngay |

## Checklist rotation

- [ ] Tao secret moi.
- [ ] Cap nhat Replit Secrets cho service lien quan.
- [ ] Roll restart theo thu tu worker -> api -> web.
- [ ] Verify health + auth smoke tests.
- [ ] Thu hoi secret cu.
