# 04-migrations-plan

- Owner role: **Backend Lead**
- Status: **Ready v1.0**
- Last updated: **2026-03-30**
- Related docs: [02-logical-schema.md](./02-logical-schema.md), [03-physical-schema.sql](./03-physical-schema.sql), [../deployment/04-rollback-by-version.md](../deployment/04-rollback-by-version.md)

## 1) Nguyên tắc migration

- Mọi migration phải idempotent, có `up`/`down` rõ.
- Không chỉnh sửa migration đã release production.
- Mỗi migration có validation script hậu triển khai.
- Migration data/backfill tách khỏi migration schema khi khối lượng lớn.

## 2) Lộ trình migration theo phase

| Version | Nội dung | Dependency |
|---|---|---|
| V001 | Core foundation: tenant, workspace, user, role_policy | - |
| V002 | Account + profile + proxy | V001 |
| V003 | Customer + conversation + message | V001,V002 |
| V004 | Campaign + delivery_attempt + job_run | V003 |
| V005 | callback_event + audit_log + indexes bổ sung | V004 |
| V006 | Performance tuning indexes và retention helpers | V005 |

## 3) Chi tiết từng migration

### V001_core_identity

- Create `tenant`, `workspace`, `user`, `role_policy`.
- Add initial indexes và trigger `updated_at`.
- Seed role mặc định: admin/manager/staff.

### V002_account_profile_proxy

- Create `zalo_account`, `proxy_profile`, `browser_profile`.
- Thêm unique mapping account-profile.
- Bổ sung health state defaults.

### V003_crm_inbox

- Create `customer`, `conversation`, `message`.
- Backfill customer from lịch sử import (nếu có).
- Tạo index query inbox.

### V004_campaign_job

- Create `campaign`, `delivery_attempt`, `job_run`.
- Áp dụng unique idempotency key.
- Backfill trạng thái chiến dịch cũ (nếu migration từ bản legacy).

### V005_callback_audit

- Create `callback_event`, `audit_log`.
- Add index truy vết request_id, created_at.
- Script dedup callback historical events theo `event_id`.

### V006_perf_retention

- Add retention job metadata tables (nếu cần).
- Tuning index theo query plan thực tế.
- Validate lock time và vacuum impact.

## 4) Rollback strategy theo migration

| Migration | Rollback |
|---|---|
| V001 | Down toàn bộ bảng identity nếu chưa có data production |
| V002 | Drop bảng account/profile/proxy sau khi backup |
| V003 | Rollback schema + archive data inbox trước drop |
| V004 | Rollback schema + giữ snapshot campaign |
| V005 | Rollback callback/audit chỉ khi chưa phát sinh compliance dependency |
| V006 | Revert index/job nếu gây regression |

Lưu ý: với production đã có dữ liệu, rollback ưu tiên **forward-fix** thay vì drop schema.

## 5) Data backfill plan

- Bước 1: snapshot dữ liệu nguồn.
- Bước 2: chạy script normalize phone/email.
- Bước 3: import theo batch và ghi `import_batch_id`.
- Bước 4: validate counts + sample audit.
- Bước 5: chốt biên bản đối soát.

## 6) Checklist nghiệm thu migration

- [ ] Migration chạy pass ở local/staging/prod dry-run.
- [ ] Zero data loss theo test đối soát.
- [ ] Query plan không có regression nghiêm trọng.
- [ ] Rollback/forward-fix runbook đã kiểm chứng.
