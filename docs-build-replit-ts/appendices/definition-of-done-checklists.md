# appendices/definition-of-done-checklists

> Owner role: Tech Lead + QA Lead  
> Status: [SOURCE OF TRUTH] Approved v1.1  
> Last updated: 2026-03-30  
> Related docs: ../03-IMPLEMENTATION-ROADMAP-WBS.md, ../09-TEST-PLAN-AND-UAT.md, ../10-CUTOVER-ROLLBACK-OPERATIONS.md

## 1) DoD theo module

### 1.1 IAM & Tenant

- [ ] Role matrix được định nghĩa rõ và được test.
- [ ] Mọi endpoint có kiểm tra scope tenant/workspace.
- [ ] Audit log có đủ actor/action/target/result.

### 1.2 Account & Session

- [ ] Mapping account_id <-> profile_id hoạt động đúng.
- [ ] `profile.list/start/stop/status` pass integration test.
- [ ] Error handling auth/rate-limit/transport đạt yêu cầu.

### 1.3 Inbox & CRM

- [ ] Callback verify signature pass.
- [ ] Dedupe event theo `event_id` pass.
- [ ] Timeline hội thoại và customer upsert đúng.

### 1.4 Campaign & Scheduler

- [ ] Job state machine chạy đủ `queued/running/completed/failed`.
- [ ] Không gửi trùng recipient trong cùng step.
- [ ] Pause/resume/cancel hoạt động đúng.

### 1.5 Reports & Admin

- [ ] Dashboard số liệu khớp nguồn dữ liệu.
- [ ] Audit viewer lọc được theo thời gian/team/account.
- [ ] Backup/restore test pass và có biên bản.

## 2) DoD theo sprint

- [ ] Mọi task trong sprint có acceptance criteria rõ.
- [ ] Unit + integration test của sprint pass.
- [ ] Không còn bug Sev-1/Sev-2 mở trong phạm vi sprint.
- [ ] Tài liệu liên quan đã cập nhật.

## 3) Release Gate DoD

### Gate A: Ready for UAT

- [ ] Feature traceability đạt >= 95% planned scope.
- [ ] Contract tests với agent pass.
- [ ] Môi trường Replit ổn định qua restart.

### Gate B: Ready for Go-Live

- [ ] 100% P0 pass, >=95% P1 pass.
- [ ] UAT sign-off có chữ ký PM + QA Lead + Tech Lead.
- [ ] Cutover dry-run pass.
- [ ] Rollback drill pass.

### Gate C: Post Go-Live Stable

- [ ] KPI vận hành trong ngưỡng 72 giờ đầu.
- [ ] Không có incident Sev-1 mở.
- [ ] Postmortem hoàn tất nếu có sự cố.

## 4) DoD tài liệu chống lệch

Mọi thay đổi kỹ thuật phải cập nhật đồng thời:
- [ ] 03-IMPLEMENTATION-ROADMAP-WBS.md
- [ ] 06-AGENT-API-CONTRACT-MAPPING.md
- [ ] 09-TEST-PLAN-AND-UAT.md
- [ ] 10-CUTOVER-ROLLBACK-OPERATIONS.md
