# 06-AGENT-API-CONTRACT-MAPPING

## 1) Phạm vi tài liệu

Tài liệu này là chuẩn tích hợp giữa web tools (TypeScript) và agent Python MoreLogin, sử dụng nguồn sự thật từ:
- `C:\Users\Admin\Desktop\tools mkt zalo\api\openapi\agent-v1.openapi.json`
- `C:\Users\Admin\Desktop\tools mkt zalo\api\guides\*.md`

Mục tiêu: đảm bảo 100% tính năng web tools có endpoint mapping rõ ràng.

## 2) Endpoint catalog sử dụng trong dự án

| Method | Path | Mục đích |
|---|---|---|
| GET | `/agent/v1/health` | Health agent |
| GET | `/agent/v1/health/upstream` | Health upstream MoreLogin |
| GET | `/agent/v1/diagnostics/morelogin` | Snapshot chẩn đoán |
| POST | `/agent/v1/diagnostics/morelogin/refresh` | Làm mới chẩn đoán |
| POST | `/agent/v1/commands/{command_name}` | Gọi command chính |
| GET | `/agent/v1/jobs/{job_id}` | Poll trạng thái async job |
| POST | `/agent/v1/callbacks/morelogin` | Ingest callback từ MoreLogin |
| POST | `/agent/v1/local-ops/callbacks/dead-letter/{event_id}/retry` | Retry dead-letter callback |

## 3) Command matrix bắt buộc

### 3.1 Command sync

- `profile.list`
- `profile.start`
- `profile.stop`
- `profile.status`
- `cloudphone.list`
- `cloudphone.power_on`
- `cloudphone.power_off`
- `cloudphone.exec_command`
- `schedule.cancel`

### 3.2 Command always async

- `browser.open_and_run`
- `file.attach_from_url`
- `file.download`
- `schedule.create`

## 4) Interface chuẩn phía web tools (TypeScript)

```ts
export type CommandName =
  | 'profile.list'
  | 'profile.start'
  | 'profile.stop'
  | 'profile.status'
  | 'browser.open_and_run'
  | 'cloudphone.list'
  | 'cloudphone.power_on'
  | 'cloudphone.power_off'
  | 'cloudphone.exec_command'
  | 'file.attach_from_url'
  | 'file.download'
  | 'schedule.create'
  | 'schedule.cancel';

export interface CommandRequest<TPayload = unknown, TTarget = unknown> {
  request_id: string;
  idempotency_key?: string;
  target?: TTarget;
  payload?: TPayload;
  options?: {
    async?: boolean;
    callback_url?: string;
    timeout_seconds?: number;
  };
}

export interface ErrorDetail {
  type:
    | 'validation_error'
    | 'auth_error'
    | 'not_found_error'
    | 'replay_error'
    | 'rate_limit_error'
    | 'internal_error'
    | 'upstream_business_error'
    | 'transport_error';
  message: string;
  details?: Record<string, unknown> | null;
  retryable: boolean;
}

export interface CommandEnvelope<TData = unknown> {
  success: boolean;
  data: TData | null;
  error: ErrorDetail | null;
  request_id?: string | null;
  agent_id: string;
  job_id?: number | null;
  upstream_code?: number;
  upstream_msg?: string;
}

export type JobStatusValue = 'queued' | 'running' | 'completed' | 'failed';

export interface JobStatus {
  job_id: number;
  status: JobStatusValue;
  command_name: CommandName;
  result?: Record<string, unknown> | null;
  error?: ErrorDetail | null;
  created_at?: string;
  updated_at?: string;
}

export interface CallbackOutbound {
  event_id: string;
  event_type: string;
  source: string;
  trace_id?: string | null;
  job_id?: number | null;
  status?: string;
  callback_url?: string | null;
  raw_event?: Record<string, unknown>;
}
```

## 5) Chuẩn AgentClient

```ts
export interface AgentClient {
  health(): Promise<CommandEnvelope>;
  healthUpstream(): Promise<CommandEnvelope>;
  diagnostics(): Promise<CommandEnvelope>;
  diagnosticsRefresh(): Promise<CommandEnvelope>;
  execute<TData = unknown>(command: CommandName, body: CommandRequest): Promise<CommandEnvelope<TData>>;
  getJob(jobId: number): Promise<CommandEnvelope<JobStatus>>;
  retryDeadLetter(eventId: string): Promise<CommandEnvelope>;
}
```

Ràng buộc:
- Mọi module nghiệp vụ chỉ dùng `AgentClient`.
- Cấm gọi `fetch/axios` trực tiếp tới agent từ module business.

## 6) Mapping tính năng -> endpoint/command

| Nhóm tính năng | Endpoint/Command | Mode | Ghi chú thi công |
|---|---|---|---|
| Health hệ thống | `GET /health`, `/health/upstream` | Sync | Dùng cho readiness/liveness và cảnh báo |
| Quản lý profile account | `profile.list/start/stop/status` | Sync | Bắt buộc với module Account & Session |
| Job async campaign/browser | `browser.open_and_run`, `schedule.create` + `GET /jobs/{job_id}` | Async | Lưu `job_id`, poll hoặc callback |
| Hủy lịch | `schedule.cancel` | Sync | Dùng cho pause/stop campaign kế hoạch |
| File thao tác cloudphone | `file.attach_from_url`, `file.download` | Async | Chỉ bật khi workflow yêu cầu |
| Callback ingest | `POST /callbacks/morelogin` | Async event | Verify signature trước xử lý |
| Dead-letter recovery | `POST /local-ops/callbacks/dead-letter/{event_id}/retry` | Sync | Chạy từ admin operation |
| Diagnostic vận hành | `GET /diagnostics/morelogin`, `POST /diagnostics/morelogin/refresh` | Sync | Dashboard vận hành/triage |

## 7) Chuẩn auth và signing

Bắt buộc gửi 4 headers cho endpoint yêu cầu auth:
- `X-API-Key`
- `X-Timestamp`
- `X-Nonce`
- `X-Signature`

Canonical string:

```text
{METHOD}\n{PATH}\n{TIMESTAMP}\n{NONCE}\n{SHA256(BODY)}
```

## 8) Chuẩn lỗi và retry

| Error type | Retry? | Hành động |
|---|---|---|
| validation_error | No | Sửa request/schema |
| auth_error | No | Sửa key/signature/time sync |
| not_found_error | No | Kiểm tra id/resource |
| replay_error | No | Tạo idempotency/request_id mới theo rule |
| rate_limit_error | Yes | Đợi `Retry-After`, retry backoff |
| transport_error | Yes | Retry exponential backoff + jitter |
| upstream_business_error | Maybe | Dựa theo `retryable` và details |
| internal_error | No | Escalate và mở incident |

## 9) Ví dụ request command sync

```http
POST /agent/v1/commands/profile.status
```

```json
{
  "request_id": "550e8400-e29b-41d4-a716-446655440111",
  "target": { "profile_id": "PROFILE_123" },
  "options": { "async": false }
}
```

## 10) Ví dụ request command async

```http
POST /agent/v1/commands/browser.open_and_run
```

```json
{
  "request_id": "550e8400-e29b-41d4-a716-446655440222",
  "idempotency_key": "cmp-1001-user-999-step-1",
  "target": { "profile_id": "PROFILE_123" },
  "payload": { "script": "return document.title" },
  "options": { "async": true }
}
```

## 11) Acceptance checklist contract

- [ ] Có lớp `AgentClient` duy nhất và được dùng xuyên suốt.
- [ ] 100% feature có mapping endpoint/command.
- [ ] Auth signing pass với test vector.
- [ ] Retry behavior đúng cho 429/503/retryable.
- [ ] Callback verification pass với signature thực tế.
