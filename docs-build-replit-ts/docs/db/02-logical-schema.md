# 02-logical-schema

- Owner role: **Backend Lead**
- Status: **Ready v1.0**
- Last updated: **2026-03-30**
- Related docs: [01-erd.png](./01-erd.png), [03-physical-schema.sql](./03-physical-schema.sql), [04-migrations-plan.md](./04-migrations-plan.md), [../testing/03-feature-to-test-matrix.md](../testing/03-feature-to-test-matrix.md)

## 1) Quy ước chung

- Naming:
- Table: `snake_case`, số ít (`tenant`, `workspace`, `user`, ...)
- PK: `<table>_id` (UUID)
- FK: `<ref_table>_id`
- Timestamps: `created_at`, `updated_at`, tùy bảng có `deleted_at`
- Timezone: tất cả timestamp lưu **UTC**.
- Soft delete: dùng `deleted_at` thay vì hard delete cho bảng nghiệp vụ chính.
- Audit columns bắt buộc ở bảng nghiệp vụ chính: `created_at`, `updated_at`, `created_by`, `updated_by` (khi phù hợp).

## 2) Bảng và vai trò dữ liệu

### tenant

- Mục đích: phân vùng dữ liệu theo doanh nghiệp/agency.
- PK: `tenant_id`
- Unique: `code`
- Soft delete: Yes

### workspace

- Mục đích: phân vùng vận hành nhỏ hơn tenant.
- FK: `tenant_id -> tenant(tenant_id)`
- Unique: `(tenant_id, code)`
- Soft delete: Yes

### user

- Mục đích: tài khoản người dùng nội bộ.
- FK: `workspace_id -> workspace(workspace_id)`
- Unique: `(workspace_id, email)`
- Soft delete: Yes

### role_policy

- Mục đích: định nghĩa role + quyền (RBAC/ABAC hints).
- FK: `workspace_id`
- Unique: `(workspace_id, role_name)`
- Soft delete: No (dùng `status`)

### zalo_account

- Mục đích: account marketing được quản lý.
- FK: `workspace_id`, `owner_user_id`
- Unique: `(workspace_id, external_uid)` nullable-safe
- Soft delete: Yes

### browser_profile

- Mục đích: mapping account với profile phía agent/MoreLogin.
- FK: `account_id -> zalo_account(account_id)`
- Unique: `(account_id)`
- Soft delete: No

### proxy_profile

- Mục đích: kho proxy + quality state.
- FK: `workspace_id`
- Unique: `(workspace_id, proxy_host, proxy_port, proxy_user)`
- Soft delete: Yes

### customer

- Mục đích: hồ sơ khách hàng và consent.
- FK: `workspace_id`, `owner_user_id`
- Unique: `(workspace_id, external_uid)`, `(workspace_id, phone)` với phone normalized
- Soft delete: Yes

### conversation

- Mục đích: thread hội thoại.
- FK: `workspace_id`, `account_id`, `customer_id`, `assignee_user_id`
- Unique: `(workspace_id, account_id, customer_id, channel_type)`
- Soft delete: No

### message

- Mục đích: bản ghi tin nhắn inbound/outbound.
- FK: `conversation_id`, `account_id`
- Index chính: `(conversation_id, created_at)`
- Soft delete: No

### campaign

- Mục đích: cấu hình chiến dịch gửi tin.
- FK: `workspace_id`, `created_by`
- Unique: `(workspace_id, campaign_code)` (nếu có code)
- Soft delete: Yes

### delivery_attempt

- Mục đích: trạng thái gửi per-recipient/per-step.
- FK: `campaign_id`
- Unique quan trọng: `(campaign_id, recipient_id, step_no)` và `idempotency_key`
- Soft delete: No

### job_run

- Mục đích: lưu vết job async/sync liên quan agent.
- FK: `workspace_id`
- Unique: `(request_id)`
- Soft delete: No

### callback_event

- Mục đích: ingest callback, dedup và tracking.
- FK: `workspace_id`
- Unique: `event_id`
- Soft delete: No

### audit_log

- Mục đích: audit hành động người dùng/hệ thống.
- FK: `workspace_id`, `actor_id`
- Index: `(workspace_id, created_at)`, `(request_id)`
- Soft delete: No

## 3) Foreign key matrix

| Child | FK | Parent | On Delete |
|---|---|---|---|
| workspace | tenant_id | tenant | RESTRICT |
| user | workspace_id | workspace | RESTRICT |
| role_policy | workspace_id | workspace | CASCADE |
| zalo_account | workspace_id | workspace | RESTRICT |
| browser_profile | account_id | zalo_account | CASCADE |
| proxy_profile | workspace_id | workspace | RESTRICT |
| customer | workspace_id | workspace | RESTRICT |
| conversation | workspace_id | workspace | RESTRICT |
| conversation | account_id | zalo_account | RESTRICT |
| conversation | customer_id | customer | RESTRICT |
| message | conversation_id | conversation | CASCADE |
| campaign | workspace_id | workspace | RESTRICT |
| delivery_attempt | campaign_id | campaign | CASCADE |
| job_run | workspace_id | workspace | RESTRICT |
| callback_event | workspace_id | workspace | RESTRICT |
| audit_log | workspace_id | workspace | RESTRICT |

## 4) Index và unique policy cốt lõi

- `delivery_attempt`:
- `UNIQUE (campaign_id, recipient_id, step_no)`
- `UNIQUE (idempotency_key)`
- `callback_event`:
- `UNIQUE (event_id)`
- `job_run`:
- `UNIQUE (request_id)`
- `conversation`:
- `INDEX (workspace_id, account_id, customer_id)`
- `message`:
- `INDEX (conversation_id, created_at DESC)`
- `audit_log`:
- `INDEX (workspace_id, created_at DESC)`

## 5) Quy tắc retention / masking / audit

- Retention mặc định:
- `audit_log`: 180 ngày
- `callback_event.raw_payload`: 90 ngày
- `message`: 365 ngày
- Export artifacts: 30 ngày
- Masking:
- Staff chỉ xem phone masked trừ quyền `pii.read_full`.
- Secrets/token không lưu plaintext trong bảng nghiệp vụ.
- Audit:
- Mọi thao tác update/delete/configuration phải có audit record.

## 6) Data quality rules

- Phone chuẩn hóa E.164 trước khi lưu.
- Email lower-case trim trước unique check.
- `status` và `state` dùng enum/check constraints trong physical schema.
- `request_id`, `correlation_id` theo UUID format.

## 7) Definition of ready cho backend thi công

- [ ] Bảng/khóa/index đã đủ cho tất cả module.
- [ ] Đã khóa policy soft delete/retention/masking.
- [ ] FK policy không gây cascade ngoài ý muốn.
- [ ] Mapping hoàn chỉnh sang `03-physical-schema.sql`.
