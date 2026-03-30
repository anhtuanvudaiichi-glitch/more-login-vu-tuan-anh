# 05-DOCUMENT-CONTROL-AND-CHANGE-RULES

- Owner role: **Tech Lead + PM**
- Status: **[DEEP-DIVE SUPPLEMENT] Approved v1.1**
- Last updated: **2026-03-30**
- Related docs: [00-DOCS-MANIFEST.md](./00-DOCS-MANIFEST.md), [../00-DOCS-MANIFEST.md](../00-DOCS-MANIFEST.md), [../05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md](../05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md), [../../api/guides/versioning.md](../../api/guides/versioning.md)

## 1) Mục tiêu

Ngăn lệch tài liệu giữa contract API, implementation guide, test plan, và runbook vận hành.

## 1.1) Scope note

- File nay la rule supplement cho nhom deep-dive trong `docs/*`.
- Khong override governance cap package tai `../05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md`.

## 1.2) Precedence note

- Neu co xung dot quy tac:
1. Uu tien `../05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md`
2. Sau do moi ap dung quy tac bo sung trong file nay

## 2) Change control bắt buộc

Mọi thay đổi liên quan contract hoặc hành vi tích hợp phải mở **Change Request** và cập nhật đồng thời:
- `../../api/openapi/agent-v1.openapi.json` (hoặc `.yaml`)
- `../../api/postman/MoreLogin-Agent.postman_collection.json`
- `../06-AGENT-API-CONTRACT-MAPPING.md`
- `./testing/02-contract-test-vectors.md`
- `../09-TEST-PLAN-AND-UAT.md`
- `../10-CUTOVER-ROLLBACK-OPERATIONS.md`

## 3) Rule theo loại thay đổi

| Loại thay đổi | Cập nhật bắt buộc |
|---|---|
| Thêm/sửa endpoint/command | OpenAPI + Postman + 06 + testing + cutover |
| Sửa auth/retry/error | guides/authentication + guides/rate-limit + 06 + testing |
| Sửa callback flow | guides/callbacks + 06 + testing + ops/oncall |
| Sửa release/rollback | deployment/* + 10 + ops/oncall |

## 4) Quy tắc path và link

- Không dùng đường dẫn tuyệt đối máy cá nhân kiểu `C:\Users\...` trong docs bàn giao team.
- Chỉ dùng đường dẫn tương đối theo repo.
- Mọi file mới phải có phần metadata: owner, status, last updated, related docs.

## 5) Quy trình review và phê duyệt

1. Author mở PR + change request.
2. Tech Lead review technical consistency.
3. QA Lead review test impact.
4. DevOps review deployment/ops impact (nếu có).
5. PM phê duyệt cuối và chốt version docs.

## 6) Docs versioning

- Major: thay đổi kiến trúc/contract lớn.
- Minor: thêm nội dung triển khai/test/ops không breaking.
- Patch: sửa lỗi chính tả/link/format.

## 7) Audit checklist cho docs trước phát hành

- [ ] Không còn placeholder chưa điền trong tài liệu chuẩn bàn giao.
- [ ] Không còn path tuyệt đối máy cá nhân.
- [ ] Cross-links hợp lệ.
- [ ] Danh sách source-of-truth đồng bộ với `00-DOCS-MANIFEST.md`.
