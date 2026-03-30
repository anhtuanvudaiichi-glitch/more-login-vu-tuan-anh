# 00-DOCS-MANIFEST

> Owner role: Tech Lead + Technical Writer  
> Status: [SOURCE OF TRUTH] Approved v1.0  
> Last updated: 2026-03-30  
> Related docs: ../README.md, 11-REPLIT-BLUEPRINT.md, 06-AGENT-API-CONTRACT-MAPPING.md, 08-REPLIT-DEPLOYMENT-AND-ENV-SETUP.md, 09-TEST-PLAN-AND-UAT.md, 10-CUTOVER-ROLLBACK-OPERATIONS.md, docs/00-DOCS-MANIFEST.md, docs/05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md

## 1) Muc tieu

Tai lieu nay khoa cung bo tai lieu chinh thuc cho thi cong Web Tools tren Replit theo kien truc:

`Web Tools TypeScript (Replit) -> Agent Python MoreLogin -> MoreLogin Local API`

## 1.1) Scope va precedence note

- File nay la **source-of-truth cap package**.
- `../README.md` la **onboarding entrypoint** cho nguoi moi nhan package.
- Cac file trong `docs/*` la deep-dive supplement de dao sau theo domain.
- Khi co xung dot noi dung, uu tien theo thu tu:
1. `00-DOCS-MANIFEST.md` (root)
2. `05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md` (root)
3. `docs/00-DOCS-MANIFEST.md` (supplement)
4. `docs/05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md` (supplement)

## 2) Quy uoc nhan dien tai lieu

- `[SOURCE OF TRUTH]`: tai lieu chinh thuc bat buoc tuan thu.
- `[PLACEHOLDER]`: gia tri phai thay the khi trien khai that.
- `[EXAMPLE]`: chi dung de minh hoa ky thuat.

## 3) Nhom tai lieu va nguon su that

| Nhom | Source of truth | Ghi chu |
|---|---|---|
| Kien truc + blueprint | `11-REPLIT-BLUEPRINT.md`, `02-TARGET-ARCHITECTURE-REPLIT-AGENT.md` | Blueprint uu tien cao nhat khi co xung dot |
| Contract API agent | `api/openapi/agent-v1.openapi.yaml`, `api/openapi/agent-v1.openapi.json`, `06-AGENT-API-CONTRACT-MAPPING.md` | OpenAPI la hop dong may-doc, file 06 la mapping thi cong |
| Bao mat HMAC/callback | `api/guides/authentication.md`, `api/guides/callbacks.md`, `appendices/hmac-golden-vectors.md`, `appendices/callback-signature-golden-vectors.md` | Golden vectors la bo expected output chuan |
| Replit deployment | `08-REPLIT-DEPLOYMENT-AND-ENV-SETUP.md`, `appendices/.replit.example`, `appendices/replit.nix.example`, `appendices/.env.example.md`, `appendices/replit-secrets-matrix.md` | Template copy-paste cho team |
| Kiem thu/UAT | `09-TEST-PLAN-AND-UAT.md`, `appendices/fixture-samples.md`, `appendices/test-fixture-matrix.csv`, `api/examples/fixtures/*` | Fixture JSON trong `api/examples/fixtures` la nguon du lieu test |
| Cat over/rollback | `10-CUTOVER-ROLLBACK-OPERATIONS.md` | Bat buoc dong bo voi release docs |
| Quan tri thay doi docs | `05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md` | Gate truoc merge |

## 4) Tinh thu tu uu tien khi co xung dot

1. `11-REPLIT-BLUEPRINT.md`
2. OpenAPI (`api/openapi/*.yaml|json`)
3. `06-AGENT-API-CONTRACT-MAPPING.md`
4. Guides (`api/guides/*.md`)
5. Postman (`api/postman/*.json`)
6. Test/UAT docs (`09` + appendices)

## 5) Danh muc deliverable bat buoc de chot 100%

- `11-REPLIT-BLUEPRINT.md`
- `appendices/.replit.example`
- `appendices/.replit.web.example`
- `appendices/.replit.api.example`
- `appendices/.replit.worker.example`
- `appendices/replit-service-deployment-mapping.md`
- `appendices/replit.nix.example`
- `appendices/.env.example.md`
- `appendices/replit-secrets-matrix.md`
- `appendices/hmac-golden-vectors.md`
- `appendices/callback-signature-golden-vectors.md`
- `appendices/fixture-samples.md`
- `appendices/test-fixture-matrix.csv`
- `appendices/replit-bringup-proof-checklist.md`
- `appendices/internal-acceptance-report-100.md`
- `api/examples/fixtures/requests/*`
- `api/examples/fixtures/responses/*`
- `api/examples/fixtures/callbacks/*`

## 6) Rule khong duoc vi pham

- Module nghiep vu khong duoc goi HTTP truc tiep toi Agent.
- Tat ca call Agent phai thong qua `packages/agent-client`.
- Khong commit secret that vao docs/Postman/OpenAPI.
- Khong dung path tuyet doi may ca nhan (`C:\Users\...`) trong source of truth.
