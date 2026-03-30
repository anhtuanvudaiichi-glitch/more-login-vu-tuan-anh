# 03-dashboard-spec

- Owner role: **SRE/DevOps**
- Status: **Ready v1.0**
- Last updated: **2026-03-30**
- Related docs: [01-metrics-catalog.md](./01-metrics-catalog.md), [02-alert-thresholds.md](./02-alert-thresholds.md)

## 1) Dashboard bắt buộc

### A. Executive Health

- System health (web/api/worker/agent)
- Total request volume
- Error rate tổng
- Campaign success rate

### B. Agent Integration

- auth_error_rate
- rate_limit_error_rate
- transport_error_rate
- Top commands by latency/error

### C. Async/Queue

- queue_backlog_size by queue
- async_job_latency_p50/p95/p99
- failed jobs by type

### D. Callback Pipeline

- callback ingest rate
- callback verify fail rate
- callback processing latency p95
- dead-letter count

### E. Business KPI

- Inbox throughput
- CRM update volume
- Campaign delivery funnel (queued->sent->delivered->read)

## 2) Dashboard widget metadata

| Widget | Refresh | Owner |
|---|---|---|
| Health Summary | 15s | DevOps |
| Agent Errors | 30s | Backend |
| Queue Latency | 15s | DevOps |
| Callback Health | 30s | Backend |
| Delivery Funnel | 60s | Product Analytics |
