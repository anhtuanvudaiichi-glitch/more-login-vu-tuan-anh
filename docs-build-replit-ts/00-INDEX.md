# 00-INDEX

Phiên bản bộ tài liệu: **v1.0**  
Ngày chốt: **2026-03-30**  
Phạm vi áp dụng: Thi công 100% ứng dụng web tools Marketing Zalo theo báo cáo `deep-research-report (1).md`.

## 1) Mục tiêu bộ tài liệu

Bộ tài liệu này được thiết kế để đội kỹ thuật có thể:
- Bắt đầu thi công ngay mà không cần tự đưa thêm quyết định kiến trúc cốt lõi.
- Triển khai đầy đủ web tools chạy trên Replit (TypeScript), tích hợp bắt buộc qua agent Python MoreLogin.
- Nghiệm thu theo checklist rõ ràng từ phát triển đến vận hành, cutover, rollback.

## 2) Nguyên tắc bắt buộc

- Mọi tính năng web tools phải đi qua `AgentClient` và gọi API agent tại lớp tích hợp.
- Không có luồng nào gọi trực tiếp MoreLogin local API từ web tools.
- Mọi request phải dùng HMAC headers theo `api/guides/authentication.md`.
- Mọi mapping endpoint phải bám bộ tài liệu API trong `C:\Users\Admin\Desktop\tools mkt zalo\api`.

## 3) Thứ tự đọc bắt buộc

1. [01-PROJECT-CHARTER-AND-SUCCESS.md](./01-PROJECT-CHARTER-AND-SUCCESS.md)
2. [02-TARGET-ARCHITECTURE-REPLIT-AGENT.md](./02-TARGET-ARCHITECTURE-REPLIT-AGENT.md)
3. [03-IMPLEMENTATION-ROADMAP-WBS.md](./03-IMPLEMENTATION-ROADMAP-WBS.md)
4. [04-MODULE-BUILD-SPECS.md](./04-MODULE-BUILD-SPECS.md)
5. [05-DATA-MODEL-AND-STATE-MACHINES.md](./05-DATA-MODEL-AND-STATE-MACHINES.md)
6. [06-AGENT-API-CONTRACT-MAPPING.md](./06-AGENT-API-CONTRACT-MAPPING.md)
7. [07-SECURITY-AUTH-COMPLIANCE.md](./07-SECURITY-AUTH-COMPLIANCE.md)
8. [08-REPLIT-DEPLOYMENT-AND-ENV-SETUP.md](./08-REPLIT-DEPLOYMENT-AND-ENV-SETUP.md)
9. [09-TEST-PLAN-AND-UAT.md](./09-TEST-PLAN-AND-UAT.md)
10. [10-CUTOVER-ROLLBACK-OPERATIONS.md](./10-CUTOVER-ROLLBACK-OPERATIONS.md)
11. [appendices/feature-traceability-matrix.csv](./appendices/feature-traceability-matrix.csv)
12. [appendices/endpoint-catalog.csv](./appendices/endpoint-catalog.csv)
13. [appendices/definition-of-done-checklists.md](./appendices/definition-of-done-checklists.md)
14. [templates/issue-risk-change-templates.md](./templates/issue-risk-change-templates.md)

## 4) Ma trận tài liệu theo vai trò

| Vai trò | Tài liệu bắt buộc |
|---|---|
| PM/PO | 01, 03, 09, 10, appendices/definition-of-done-checklists.md |
| Tech Lead | 02, 03, 04, 05, 06, 07 |
| Backend Engineer | 04, 05, 06, 07, 08, 09 |
| Frontend Engineer | 04, 06, 08, 09 |
| QA Engineer | 05, 06, 09, 10 |
| DevOps/SRE | 02, 07, 08, 10 |

## 5) Định nghĩa hoàn thiện 100%

Dự án được coi là hoàn thiện khi đồng thời đạt:
- 100% feature trong `feature-traceability-matrix.csv` có trạng thái `Done` và có bằng chứng test.
- 100% endpoint mapping trong `endpoint-catalog.csv` có contract test pass.
- UAT sign-off đạt cho tất cả luồng P0/P1.
- Cutover checklist pass và có rollback drill pass.

## 6) Thay đổi so với báo cáo gốc

- Chốt cứng ngôn ngữ web tools: **TypeScript**.
- Chốt cứng môi trường web tools: **Replit**.
- Chốt cứng lớp tích hợp: **Agent Python MoreLogin** (không qua API trung gian khác).
- Bổ sung mức tài liệu thi công 100%: WBS, runbook, checklist nghiệm thu, rollback.

## 7) Quy trình cập nhật chống lệch tài liệu (anti-drift)

Khi có thay đổi kỹ thuật, bắt buộc cập nhật đồng thời:
- `03-IMPLEMENTATION-ROADMAP-WBS.md`
- `06-AGENT-API-CONTRACT-MAPPING.md`
- `09-TEST-PLAN-AND-UAT.md`
- `10-CUTOVER-ROLLBACK-OPERATIONS.md`

Không được merge thay đổi kiến trúc nếu thiếu một trong bốn cập nhật trên.

## 8) Trạng thái bộ tài liệu

| Hạng mục | Trạng thái |
|---|---|
| Tài liệu lõi 00-10 | Ready v1.0 |
| Phụ lục traceability/endpoint catalog | Ready v1.0 |
| Template issue/risk/change | Ready v1.0 |
| Có thể bàn giao cho đội kỹ thuật thi công | Yes |
