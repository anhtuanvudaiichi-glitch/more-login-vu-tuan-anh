# templates/issue-risk-change-templates

> Owner role: PM/Technical Writer + Tech Lead  
> Status: [SOURCE OF TRUTH] Approved v1.1  
> Last updated: 2026-03-30  
> Related docs: ../05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md, ../03-IMPLEMENTATION-ROADMAP-WBS.md, ../10-CUTOVER-ROLLBACK-OPERATIONS.md

## 1) Template ticket triển khai kỹ thuật

```md
# [TASK] <Mã công việc> - <Tên công việc>

## Mục tiêu
- 

## Phạm vi
- In-scope:
- Out-of-scope:

## Đầu vào bắt buộc
- Tài liệu tham chiếu:
- Endpoint/command liên quan:
- Dependency:

## Đầu ra mong đợi
- 

## Acceptance Criteria
- [ ]
- [ ]
- [ ]

## Test Cases tối thiểu
- 

## Rủi ro và phương án xử lý
- 

## Owner và ETA
- Owner:
- ETA:
```

## 2) Template risk log

```md
# [RISK] <Mã rủi ro> - <Tiêu đề>

## Mô tả
- 

## Nhóm rủi ro
- [ ] Kỹ thuật
- [ ] Bảo mật
- [ ] Dữ liệu
- [ ] Vận hành
- [ ] Pháp lý/chính sách

## Xác suất / Ảnh hưởng
- Xác suất: Low / Medium / High
- Ảnh hưởng: Low / Medium / High

## Trigger nhận biết sớm
- 

## Kế hoạch giảm thiểu
- 

## Kế hoạch ứng phó khi xảy ra
- 

## Owner / Deadline
- Owner:
- Deadline:

## Trạng thái
- Open / Monitoring / Mitigated / Closed
```

## 3) Template change request

```md
# [CR] <Mã thay đổi> - <Tiêu đề thay đổi>

## Lý do thay đổi
- 

## Mô tả thay đổi
- 

## Ảnh hưởng
- Kiến trúc:
- API contract:
- Dữ liệu:
- Test/UAT:
- Cutover/Rollback:

## Tài liệu bắt buộc cập nhật
- [ ] 03-IMPLEMENTATION-ROADMAP-WBS.md
- [ ] 06-AGENT-API-CONTRACT-MAPPING.md
- [ ] 09-TEST-PLAN-AND-UAT.md
- [ ] 10-CUTOVER-ROLLBACK-OPERATIONS.md

## Đánh giá rủi ro thay đổi
- 

## Quyết định phê duyệt
- PM:
- Tech Lead:
- QA Lead:
- Ngày phê duyệt:
```

## 4) Template incident report

```md
# [INC] <Mã sự cố> - <Tiêu đề>

## Mức độ
- Sev-1 / Sev-2 / Sev-3

## Timeline
- 

## Ảnh hưởng
- 

## Root cause
- 

## Hành động khắc phục ngay
- 

## Hành động phòng ngừa tái diễn
- 

## Tài liệu cần cập nhật sau incident
- [ ] 09-TEST-PLAN-AND-UAT.md
- [ ] 10-CUTOVER-ROLLBACK-OPERATIONS.md
- [ ] 06-AGENT-API-CONTRACT-MAPPING.md (nếu liên quan contract)
```
