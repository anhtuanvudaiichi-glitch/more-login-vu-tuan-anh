# replit-bringup-proof-checklist

> Owner role: QA Lead + DevOps Lead  
> Status: [SOURCE OF TRUTH] Approved v1.0  
> Last updated: 2026-03-30  
> Related docs: ../11-REPLIT-BLUEPRINT.md, ../08-REPLIT-DEPLOYMENT-AND-ENV-SETUP.md, test-fixture-matrix.csv

## 1) Muc tieu

Xac nhan mot ky su thu 2 co the dung moi truong tu dau chi dua tren tai lieu va template.

## 2) Bien ban nguoi thuc hien

- Ky su thuc hien: `[PLACEHOLDER]`
- Ngay gio: `[PLACEHOLDER]`
- Moi truong: `[PLACEHOLDER:dev|staging]`

## 3) Checklist buoc thuc hien

- [ ] Copy `appendices/.replit.example` -> `.replit`.
- [ ] Copy `appendices/replit.nix.example` -> `replit.nix`.
- [ ] Dien toan bo secrets theo `appendices/.env.example.md` + `appendices/replit-secrets-matrix.md`.
- [ ] Start `api`, `worker`, `web` theo startup order.
- [ ] Verify `GET /health` va dependency health.
- [ ] Chay Postman request `Run HMAC Golden Vectors` pass.
- [ ] Chay Postman request `Run Callback Golden Vectors` pass.
- [ ] Chay fixture P0 trong `appendices/test-fixture-matrix.csv`.

## 4) Evidence bat buoc nop

- [ ] Screenshot service runtime (web/api/worker up).
- [ ] Log snippet co `request_id`, `job_id`, `correlation_id`.
- [ ] Ket qua Postman tests (pass count).
- [ ] Evidence IDs da nop: `EVD-001..EVD-010`.

## 5) Ket luan

- [ ] PASS: Co the dung moi truong khong can hoi them.
- [ ] FAIL: Can bo sung docs (ghi ro muc can bo sung).
