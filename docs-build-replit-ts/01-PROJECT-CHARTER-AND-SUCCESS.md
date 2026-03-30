# 01-PROJECT-CHARTER-AND-SUCCESS

## 1) Mục tiêu dự án

Xây dựng ứng dụng web tools Marketing Zalo có thể vận hành thực tế cho đội nội bộ/agency với kiến trúc chuẩn:

`Web Tools (TypeScript trên Replit) -> Agent Python MoreLogin -> MoreLogin Local API`

Trong đó:
- Web tools chịu trách nhiệm nghiệp vụ: IAM, Account, Inbox, CRM, Campaign, Reports, Admin.
- Agent Python chịu trách nhiệm tích hợp kỹ thuật tới MoreLogin + OA/ZNS routing theo tài liệu API agent.

## 2) Kết quả kinh doanh và kỹ thuật cần đạt

### 2.1 Kết quả kinh doanh

- Giảm thao tác thủ công cho đội CSKH/Marketing qua các luồng bulk + inbox + CRM.
- Chuẩn hóa vận hành đa tài khoản theo team và audit trail.
- Có khả năng rollout theo tenant/workspace.

### 2.2 Kết quả kỹ thuật

- Tất cả tính năng đi qua `AgentClient` và endpoint agent.
- Có retry/idempotency/circuit breaker cho các luồng async và tác vụ có rủi ro.
- Có bộ test và UAT checklist đủ điều kiện bàn giao vận hành.

## 3) Tiêu chí thành công (Success Criteria)

| Mã | Tiêu chí | Ngưỡng đạt |
|---|---|---|
| SC-01 | Phủ tính năng | 100% feature trong traceability matrix có trạng thái Done |
| SC-02 | Phủ tích hợp agent | 100% feature có endpoint mapping hợp lệ |
| SC-03 | Chất lượng test | 100% test P0 pass, >=95% test P1 pass trước go-live |
| SC-04 | Vận hành | Cutover pass, rollback drill pass |
| SC-05 | Bảo mật | HMAC auth + secret policy + audit log được bật ở production |

## 4) KPI vận hành sau go-live

| KPI | Mục tiêu |
|---|---|
| Tỷ lệ request agent thành công | >= 99.0% |
| Tỷ lệ job async hoàn thành | >= 98.0% |
| Tỷ lệ gửi trùng chiến dịch | <= 0.1% |
| Độ trễ median gọi agent | <= 500ms (sync) |
| MTTR incident mức Sev-2 | <= 2 giờ |

## 5) Phạm vi thực hiện

### 5.1 In-scope

- Web UI + Product API + Worker bằng TypeScript trên Replit.
- Các module: IAM, Account/Session, Inbox, CRM, Campaign, Reports, Admin.
- Tích hợp đầy đủ qua agent API cho profile/jobs/callback/diagnostics.
- Hướng dẫn triển khai, test, cutover, rollback.

### 5.2 Out-of-scope

- Viết lại hoặc thay đổi contract API agent hiện có.
- Tích hợp trực tiếp MoreLogin local API từ web tools.
- Các thay đổi pháp lý nằm ngoài phạm vi sản phẩm kỹ thuật.

## 6) Ràng buộc bắt buộc

- Nền tảng web tools: Replit.
- Ngôn ngữ web tools: TypeScript.
- Agent tích hợp: Python MoreLogin tại `C:\Users\Admin\Desktop\tools mkt zalo\api`.
- HMAC và retry policy phải tuân theo guide trong thư mục `api/guides`.

## 7) Vai trò và trách nhiệm

| Vai trò | Trách nhiệm chính |
|---|---|
| Sponsor | Phê duyệt scope, ngân sách, tiêu chí bàn giao |
| PM/PO | Quản lý backlog, acceptance, UAT sign-off |
| Tech Lead | Quyết định kỹ thuật trong phạm vi tài liệu, review kiến trúc |
| Backend Team | Xây Product API, AgentClient, worker, data layer |
| Frontend Team | Xây UI workflows theo module và acceptance criteria |
| QA Team | Test chức năng/tích hợp/tải/UAT |
| DevOps/SRE | Setup Replit env, monitoring, cutover, rollback |

## 8) Cơ chế kiểm soát thay đổi

Mọi thay đổi liên quan tới kiến trúc/tích hợp phải có:
- Change request theo template.
- Cập nhật đồng bộ các tài liệu 03, 06, 09, 10.
- Re-approval của Tech Lead và PM.

## 9) Điều kiện bàn giao cho đội kỹ thuật

Dự án chỉ được chuyển trạng thái “sẵn sàng thi công toàn diện” khi:
- Tài liệu 00-10 + phụ lục + templates đã hoàn chỉnh v1.0.
- Endpoint mapping và traceability matrix đã được kiểm tra chéo.
- Test plan/UAT/Cutover/Rollback đã có checklist đầy đủ.
