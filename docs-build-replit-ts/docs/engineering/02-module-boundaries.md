# 02-module-boundaries

- Owner role: **Tech Lead**
- Status: **Ready v1.0**
- Last updated: **2026-03-30**
- Related docs: [01-repo-structure.md](./01-repo-structure.md), [04-dto-and-internal-api.md](./04-dto-and-internal-api.md), [../../06-AGENT-API-CONTRACT-MAPPING.md](../../06-AGENT-API-CONTRACT-MAPPING.md)

## 1) Module catalog

| Module | Mục tiêu chính |
|---|---|
| IAM | AuthN/AuthZ, RBAC, tenancy scope |
| Account | Quản lý account/profile/proxy |
| Inbox | Hội thoại tập trung + assignment |
| CRM | Customer, tag, segment, consent |
| Campaign | Bulk/send/schedule/progress |
| Reports | Dashboard KPI + analytics views |
| Admin | Audit, config, backup/restore operations |

## 2) Dependency rules

- IAM có thể được dùng bởi mọi module.
- Account cung cấp account/profile context cho Inbox/Campaign.
- CRM cung cấp audience cho Campaign.
- Campaign phát domain events cho Reports/Admin.
- Admin đọc audit toàn hệ thống, không bypass policy của IAM.

## 3) Forbidden dependency

- Inbox không gọi trực tiếp storage của Campaign.
- CRM không gọi trực tiếp HTTP tới agent.
- Reports không đọc thẳng queue internals nếu không qua service API.
- Module business không import trực tiếp client HTTP agent ngoài `AgentClient` wrapper.

## 4) Event boundary

| Event | Publisher | Subscriber |
|---|---|---|
| `account.health.changed` | Account | Reports, Admin |
| `callback.event.received` | Inbox Integration | Inbox, CRM, Campaign |
| `campaign.delivery.updated` | Campaign Worker | Reports, Inbox |
| `job.status.changed` | Worker | Campaign, Admin |

## 5) API boundary (nội bộ)

- Public domain service interface:
- `IAMService`
- `AccountService`
- `InboxService`
- `CRMService`
- `CampaignService`
- `ReportService`
- `AdminService`

- Shared contract vào/ra đặt tại `packages/shared`.

## 6) Acceptance boundary checklist

- [ ] Không import chéo vi phạm forbidden dependency.
- [ ] Mọi call agent đi qua `AgentClient`.
- [ ] Mọi module có service interface rõ và test được độc lập.
