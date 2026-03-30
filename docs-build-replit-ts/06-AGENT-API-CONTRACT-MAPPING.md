# 06-AGENT-API-CONTRACT-MAPPING

> Owner role: Backend Lead + Tech Lead  
> Status: [SOURCE OF TRUTH] Approved v1.1  
> Last updated: 2026-03-30  
> Related docs: ../api/openapi/agent-v1.openapi.yaml, ../api/guides/authentication.md, ../api/guides/callbacks.md

## 1) Scope

Tai lieu nay khoa contract tich hop giua Web Tools va Agent Python MoreLogin.
Nguon tham chieu:
- `../api/openapi/agent-v1.openapi.yaml`
- `../api/openapi/agent-v1.openapi.json`
- `../api/guides/*.md`

## 2) Endpoint catalog

| Method | Path | Muc dich |
|---|---|---|
| GET | `/agent/v1/health` | health agent |
| GET | `/agent/v1/health/upstream` | health upstream MoreLogin |
| GET | `/agent/v1/diagnostics/morelogin` | diagnostics snapshot |
| POST | `/agent/v1/diagnostics/morelogin/refresh` | refresh diagnostics |
| POST | `/agent/v1/commands/{command_name}` | execute command |
| GET | `/agent/v1/jobs/{job_id}` | poll async job |
| POST | `/agent/v1/callbacks/morelogin` | ingest callback tu MoreLogin |
| POST | `/agent/v1/local-ops/callbacks/dead-letter/{event_id}/retry` | retry dead-letter callback |

## 3) Command matrix

### 3.1 Sync commands

- `profile.list`
- `profile.start`
- `profile.stop`
- `profile.status`
- `cloudphone.list`
- `cloudphone.power_on`
- `cloudphone.power_off`
- `cloudphone.exec_command`
- `schedule.cancel`

### 3.2 Always async commands

- `browser.open_and_run`
- `file.attach_from_url`
- `file.download`
- `schedule.create`

## 4) Interface docs for packages/agent-client

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

export interface CommandRequest<TPayload = unknown, TTarget = unknown> {
  request_id: string;
  idempotency_key?: string;
  target?: TTarget;
  payload?: TPayload;
  options?: { async?: boolean; callback_url?: string; timeout_seconds?: number };
}

export interface ErrorDetail {
  type: 'validation_error' | 'auth_error' | 'not_found_error' | 'replay_error' | 'rate_limit_error' | 'internal_error' | 'upstream_business_error' | 'transport_error';
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

export interface JobStatus {
  job_id: number;
  status: 'queued' | 'running' | 'completed' | 'failed';
  command_name: CommandName;
  result?: Record<string, unknown> | null;
  error?: ErrorDetail | null;
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

## 5) Auth and retry policy

- Headers: `X-API-Key`, `X-Timestamp`, `X-Nonce`, `X-Signature`.
- Canonical: `{METHOD}\n{PATH}\n{TIMESTAMP}\n{NONCE}\n{SHA256(BODY)}`.
- Retry policy:
  - `rate_limit_error` (429): retry theo `Retry-After`.
  - `transport_error` (5xx/network): exponential backoff + jitter.
  - `auth_error`, `validation_error`, `not_found_error`: no retry.

## 6) Mapping tinh nang -> command

| Module | Command/Endpoint | Mode |
|---|---|---|
| Account | `profile.list/start/stop/status` | Sync |
| Campaign | `browser.open_and_run`, `schedule.create`, poll `/jobs/{job_id}` | Async |
| Inbox | callback ingest + dedupe event | Async event |
| Admin Ops | diagnostics + retry dead-letter | Sync |

## 7) Rule dong bo contract

Moi thay doi contract phai cap nhat dong bo 5 nguon:
1. OpenAPI
2. Postman collection/environment
3. Tai lieu nay (`06-...`)
4. Golden vectors
5. Test/UAT + cutover docs
