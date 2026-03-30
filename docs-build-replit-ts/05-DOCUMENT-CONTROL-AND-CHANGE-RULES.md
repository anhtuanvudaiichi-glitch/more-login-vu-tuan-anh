# 05-DOCUMENT-CONTROL-AND-CHANGE-RULES

> Owner role: Tech Lead + PM/Technical Writer  
> Status: [SOURCE OF TRUTH] Approved v1.0  
> Last updated: 2026-03-30  
> Related docs: ../README.md, 00-DOCS-MANIFEST.md, 06-AGENT-API-CONTRACT-MAPPING.md, 09-TEST-PLAN-AND-UAT.md, 10-CUTOVER-ROLLBACK-OPERATIONS.md, docs/00-DOCS-MANIFEST.md, docs/05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md

## 1) Muc tieu

Dam bao docs khong bi drift giua OpenAPI, Postman, guides va tai lieu thi cong.

## 1.1) Scope va precedence note

- File nay la **rule book cap package** cho governance va change control.
- `../README.md` la tai lieu vao cua; governance chinh thuc van khoa trong file nay + `00-DOCS-MANIFEST.md`.
- Cap `docs/*` chi bo sung huong dan chi tiet theo tung nhom tai lieu.
- `docs/*` khong duoc override quy tac trong file root nay.

## 2) Gate cap nhat bat buoc theo loai thay doi

| Thay doi | Bat buoc cap nhat dong thoi |
|---|---|
| Thay doi endpoint/schema/error trong Agent API | `api/openapi/*`, `api/postman/MoreLogin-Agent.postman_collection.json`, `06-AGENT-API-CONTRACT-MAPPING.md`, `09-TEST-PLAN-AND-UAT.md`, `10-CUTOVER-ROLLBACK-OPERATIONS.md` |
| Thay doi HMAC/callback signing | `api/guides/authentication.md`, `api/guides/callbacks.md`, `appendices/hmac-golden-vectors.md`, `appendices/callback-signature-golden-vectors.md`, Postman tests |
| Thay doi Replit runtime/env | `11-REPLIT-BLUEPRINT.md`, `08-REPLIT-DEPLOYMENT-AND-ENV-SETUP.md`, `appendices/.replit.example`, `appendices/.replit.web.example`, `appendices/.replit.api.example`, `appendices/.replit.worker.example`, `appendices/replit-service-deployment-mapping.md`, `appendices/replit.nix.example`, `appendices/.env.example.md`, `appendices/replit-secrets-matrix.md` |
| Thay doi test scenario P0/P1 | `09-TEST-PLAN-AND-UAT.md`, `appendices/test-fixture-matrix.csv`, `appendices/fixture-samples.md`, `api/examples/fixtures/*` |
| Thay doi rollout/cutover/rollback | `10-CUTOVER-ROLLBACK-OPERATIONS.md`, `08-REPLIT-DEPLOYMENT-AND-ENV-SETUP.md`, `03-IMPLEMENTATION-ROADMAP-WBS.md` |

## 3) Quy trinh review/approval

1. Author mo PR va dien checklist dong bo docs.
2. Backend Lead duyet phan contract + auth/callback (neu co).
3. DevOps Lead duyet phan Replit runtime + rollback (neu co).
4. QA Lead duyet phan fixture/test vectors/UAT mapping.
5. Tech Lead chot final merge.

## 4) Checklist truoc merge

- [ ] Khong con placeholder chua dien trong source of truth.
- [ ] Khong con demo secret hardcoded trong file production template.
- [ ] Khong co path tuyet doi may ca nhan.
- [ ] OpenAPI va Postman cung version contract.
- [ ] Golden vectors va Postman test cho ket qua dong nhat.
- [ ] Fixture matrix map day du scenario P0/P1.

## 5) Quy tac dat ten va metadata

Moi file docs moi/sua lon phai co:
- `Owner role`
- `Status`
- `Last updated`
- `Related docs`

## 6) Lich review dinh ky

- Hang tuan: soat drift contract (Tech Lead + Backend Lead).
- Moi truoc release production: soat full manifest (Tech Lead + QA + DevOps).
- Sau moi incident Sev-1/2: cap nhat docs lien quan trong 48 gio.

