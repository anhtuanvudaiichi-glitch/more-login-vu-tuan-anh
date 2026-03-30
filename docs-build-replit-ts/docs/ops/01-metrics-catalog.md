# 01-metrics-catalog

- Owner role: **SRE/DevOps**
- Status: **Ready v1.0**
- Last updated: **2026-03-30**
- Related docs: [02-alert-thresholds.md](./02-alert-thresholds.md), [03-dashboard-spec.md](./03-dashboard-spec.md), [04-oncall-playbook.md](./04-oncall-playbook.md)

## 1) Metrics bắt buộc

| Metric key | Công thức | Nguồn | Owner |
|---|---|---|---|
| `auth_error_rate` | auth_error / total_agent_calls | API logs | Backend Lead |
| `rate_limit_error_rate` | 429_count / total_agent_calls | API logs | Backend Lead |
| `transport_error_rate` | transport_error / total_agent_calls | API logs | Backend Lead |
| `callback_verify_fail_rate` | callback_verify_fail / total_callbacks | Callback handler logs | Backend Lead |
| `queue_backlog_size` | pending_jobs per queue | Redis/BullMQ | DevOps Lead |
| `async_job_latency_p95` | p95(completed_at-created_at) | Job table/metrics | Backend Lead |
| `callback_processing_latency_p95` | p95(processed_at-received_at) | callback_event | Backend Lead |
| `campaign_delivery_success_rate` | delivered / total_attempts | delivery_attempt | QA + Backend |

## 2) Sampling và retention metrics

- Sampling interval: 15s (runtime), aggregation 1m/5m/1h.
- Retention: 30 ngày raw, 180 ngày aggregated.

## 3) Labels chuẩn

- `env`, `service`, `workspace_id`, `module`, `command_name`, `error_type`.
