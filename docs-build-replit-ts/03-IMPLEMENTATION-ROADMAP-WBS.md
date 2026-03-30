# 03-IMPLEMENTATION-ROADMAP-WBS

## 1) Nguyên tắc lập WBS

- Tách công việc theo module nghiệp vụ và theo phase kỹ thuật.
- Mỗi task có: owner role, đầu ra, dependency, tiêu chí hoàn thành.
- Không để task “mơ hồ” kiểu nghiên cứu chung chung khi đã có tài liệu quyết định.

## 2) Roadmap đề xuất (12 tuần)

| Phase | Tuần | Mục tiêu |
|---|---|---|
| P0 | W1-W2 | Foundation Replit + baseline kiến trúc + contract agent |
| P1 | W3-W5 | IAM + Account/Session + AgentClient + observability lõi |
| P2 | W6-W8 | Inbox + CRM + Campaign + Import |
| P3 | W9-W10 | Reports + Admin + backup/restore + hardening |
| P4 | W11-W12 | Test tổng thể + UAT + cutover + rollback drill |

## 3) WBS chi tiết theo mã công việc

### 3.1 Foundation

| Mã | Công việc | Owner | Dependency | Đầu ra |
|---|---|---|---|---|
| FND-01 | Khởi tạo skeleton project TypeScript trên Replit | Tech Lead | - | Repo chạy `dev/build/start/worker` |
| FND-02 | Chuẩn hóa env schema và secrets | DevOps | FND-01 | Danh sách env và chính sách secret |
| FND-03 | Tạo AgentClient core (auth signing + retry) | Backend | FND-01 | SDK client nội bộ gọi agent API |
| FND-04 | Thiết lập logging/metrics/trace | Backend+DevOps | FND-01 | Dashboard cơ bản + alert rule |
| FND-05 | Contract test cho auth + envelope | QA+Backend | FND-03 | Bộ test contract pass |

### 3.2 IAM + Account/Session

| Mã | Công việc | Owner | Dependency | Đầu ra |
|---|---|---|---|---|
| ACC-01 | Xây RBAC/tenant/workspace model | Backend | FND-02 | API IAM chuẩn |
| ACC-02 | Build account registry và mapping profile_id | Backend | ACC-01,FND-03 | Account-Service hoàn chỉnh |
| ACC-03 | Tích hợp `profile.list/start/stop/status` | Backend | ACC-02 | Luồng account thao tác được |
| ACC-04 | UI quản lý tài khoản/trạng thái | Frontend | ACC-03 | Màn hình account management |
| ACC-05 | Test chức năng + lỗi auth/rate-limit | QA | ACC-03 | Test report pass |

### 3.3 Inbox + CRM + Campaign

| Mã | Công việc | Owner | Dependency | Đầu ra |
|---|---|---|---|---|
| CRM-01 | Thiết kế model Customer/Conversation/Message | Backend | FND-01 | Schema và migration |
| CRM-02 | Luồng ingest callback + dedup event | Backend | FND-03 | Pipeline callback ổn định |
| CRM-03 | UI inbox + gán tag + assignment | Frontend | CRM-02 | Màn hình inbox/CRM |
| CMP-01 | Campaign engine + state machine | Backend | CRM-01 | Dịch vụ campaign |
| CMP-02 | Tích hợp command async + job polling | Backend | CMP-01,FND-03 | Luồng async hoàn chỉnh |
| CMP-03 | Import CSV/XLSX + validate + report lỗi | Backend+Frontend | CMP-01 | Import flow hoàn chỉnh |
| CMP-04 | Test hiệu năng gửi theo batch + retry | QA | CMP-02 | Báo cáo benchmark |

### 3.4 Reports + Admin + Hardening

| Mã | Công việc | Owner | Dependency | Đầu ra |
|---|---|---|---|---|
| RPT-01 | Dashboard metrics và top lists | Backend+Frontend | CRM-03,CMP-02 | Report module |
| ADM-01 | Audit log viewer + action trails | Backend+Frontend | ACC-01 | Admin audit UI/API |
| ADM-02 | Backup/restore runbook + thực thi | DevOps | RPT-01 | Quy trình sao lưu/khôi phục |
| SEC-01 | Hardening security/compliance | DevOps+Backend | ADM-01 | Security checklist pass |
| SEC-02 | Load test + failover test | QA+DevOps | SEC-01 | Reliability report |

### 3.5 UAT + Go-Live

| Mã | Công việc | Owner | Dependency | Đầu ra |
|---|---|---|---|---|
| UAT-01 | Chạy test plan đầy đủ theo tài liệu 09 | QA | Tất cả phase trước | UAT report |
| CUT-01 | Dry-run cutover theo tài liệu 10 | DevOps+Tech Lead | UAT-01 | Dry-run pass |
| CUT-02 | Rollback drill (Sev-1/Sev-2) | DevOps+Backend | CUT-01 | Rollback pass report |
| GO-01 | Go-live production | Sponsor+PM+Tech Lead | CUT-02 | Biên bản go-live |

## 4) RACI tóm tắt

| Hạng mục | R | A | C | I |
|---|---|---|---|---|
| Kiến trúc & contract | Tech Lead | Tech Lead | Backend, DevOps | PM |
| API/Worker/Data | Backend | Tech Lead | QA | PM |
| UI/UX flow | Frontend | Tech Lead | PO | QA |
| Test/UAT | QA | QA Lead | Backend, Frontend | PM |
| Deploy/Cutover | DevOps | Tech Lead | Backend, QA | Sponsor |

## 5) Điều kiện chuyển phase (phase gate)

- Gate P0->P1: auth contract test pass, AgentClient stable.
- Gate P1->P2: IAM + account/session pass test P0.
- Gate P2->P3: inbox+CRM+campaign pass integration test.
- Gate P3->P4: security/load baseline pass.
- Gate P4->Go-live: UAT sign-off + cutover/rollback drill pass.

## 6) Quy tắc cập nhật roadmap

Khi có thay đổi kỹ thuật quan trọng, cập nhật bắt buộc:
- `03-IMPLEMENTATION-ROADMAP-WBS.md`
- `06-AGENT-API-CONTRACT-MAPPING.md`
- `09-TEST-PLAN-AND-UAT.md`
- `10-CUTOVER-ROLLBACK-OPERATIONS.md`
