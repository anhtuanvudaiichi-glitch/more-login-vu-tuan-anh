# 00-DOCS-MANIFEST

- Owner role: **Tech Lead**
- Status: **[DEEP-DIVE SUPPLEMENT] Approved v1.1**
- Last updated: **2026-03-30**
- Related docs: [05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md](./05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md), [../00-INDEX.md](../00-INDEX.md), [../00-DOCS-MANIFEST.md](../00-DOCS-MANIFEST.md), [../05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md](../05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md)

## 1) Source-of-truth map

### 1.1) Scope note

- File nay la manifest **deep-dive cap subfolder `docs/*`**.
- Khong override source-of-truth cap package tai `../00-DOCS-MANIFEST.md`.

### 1.2) Precedence note

- Neu co xung dot voi file root, uu tien file root:
1. `../00-DOCS-MANIFEST.md`
2. `../05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md`

| Nhóm | Source of Truth |
|---|---|
| Product strategy & scope | `../00-INDEX.md`, `../01-PROJECT-CHARTER-AND-SUCCESS.md` |
| Architecture & implementation | `../02-*`, `../03-*`, `../04-*`, `../05-*` |
| Agent API contract | `../../api/openapi/agent-v1.openapi.json`, `../../api/guides/*.md`, `../06-AGENT-API-CONTRACT-MAPPING.md` |
| Security/Compliance | `../07-SECURITY-AUTH-COMPLIANCE.md`, `./05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md` |
| Deployment/Release | `./deployment/*`, `../10-CUTOVER-ROLLBACK-OPERATIONS.md` |
| Observability/On-call | `./ops/*` |
| Testing/UAT | `./testing/*`, `../09-TEST-PLAN-AND-UAT.md` |

## 2) Ưu tiên khi xung đột tài liệu

1. OpenAPI + guides trong `../../api` (contract kỹ thuật agent).
2. `../06-AGENT-API-CONTRACT-MAPPING.md` (adapter contract phía web tools).
3. Tài liệu module/testing/deployment trong thư mục `./`.

## 3) Danh mục deliverables bắt buộc cho mức 99-100%

- `db/*`
- `engineering/*`
- `deployment/*`
- `ops/*`
- `testing/*`
- `05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md`

## 4) Trạng thái hiện tại

- Manifest version: `v1.0`
- Bộ docs đạt chuẩn: `Implementation-ready`
