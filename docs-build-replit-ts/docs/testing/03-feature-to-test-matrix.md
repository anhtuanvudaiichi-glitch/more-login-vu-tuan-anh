# 03-feature-to-test-matrix

- Owner role: **QA Lead**
- Status: **Ready v1.0**
- Last updated: **2026-03-30**
- Related docs: [../../appendices/feature-traceability-matrix.csv](../../appendices/feature-traceability-matrix.csv), [../db/02-logical-schema.md](../db/02-logical-schema.md), [../../06-AGENT-API-CONTRACT-MAPPING.md](../../06-AGENT-API-CONTRACT-MAPPING.md)

## Matrix

| Feature ID | Feature | Endpoint/Command | Test Case IDs | Evidence Required |
|---|---|---|---|---|
| FTR-001 | Multi-account management | profile.list/status/start/stop | T-ACC-01, T-ACC-02 | API logs + account UI screenshot |
| FTR-002 | Proxy assignment quality | profile.status + diagnostics | T-ACC-04 | Diagnostics snapshot + audit log |
| FTR-003 | Browser profile lifecycle | profile.start/stop/status | T-ACC-02, T-ACC-05 | request_id/job_id traces |
| FTR-004 | Queue + throttling | schedule.create/cancel + job poll | T-CMP-02, T-CMP-04 | queue metrics + job logs |
| FTR-005 | Unified inbox | callback ingest | T-INB-01, T-INB-02 | callback payload + dedup evidence |
| FTR-006 | CRM tags/assignment | callback + CRM API | T-CRM-01, T-CRM-02 | customer timeline + audit |
| FTR-007 | Bulk campaign | browser.open_and_run + job poll | T-CMP-01..05 | campaign progress report |
| FTR-008 | CSV/XLSX import | internal import API | T-CRM-02, T-IMP-01 | import error report |
| FTR-009 | Dashboard | health/diagnostics + internal report | T-RPT-01 | dashboard screenshot + query logs |
| FTR-010 | RBAC + audit | internal IAM API | T-IAM-01, T-IAM-02 | permission test + audit logs |
| FTR-011 | Backup/restore + monitor | ops scripts + health endpoints | T-OPS-01, T-OPS-02 | restore report + health checks |
| FTR-012 | OA/ZNS integration via agent | command/callback mapping | T-OA-01, T-OA-02 | callback + delivery trace |
| FTR-013 | Group workflows | async commands + schedule | T-GRP-01, T-GRP-02 | job state logs |
| FTR-014 | High-risk bulk friend | async commands | T-HR-01 | quota + auto-stop logs |
| FTR-015 | High-risk nurture | async commands | T-HR-02 | fail-rate auto-stop evidence |

## Coverage target

- P0 features: 100% test coverage theo matrix.
- P1 features: >=95% trước go-live.
- P2/P3 feature flags: test trong môi trường controlled.
