# 02-alert-thresholds

- Owner role: **SRE/DevOps**
- Status: **Ready v1.0**
- Last updated: **2026-03-30**
- Related docs: [01-metrics-catalog.md](./01-metrics-catalog.md), [04-oncall-playbook.md](./04-oncall-playbook.md)

## 1) Alert thresholds theo severity

| Metric | Sev-3 | Sev-2 | Sev-1 |
|---|---|---|---|
| auth_error_rate | >2% trong 10m | >5% trong 10m | >10% trong 5m |
| rate_limit_error_rate | >3% trong 15m | >8% trong 10m | >15% trong 5m |
| transport_error_rate | >1% trong 10m | >3% trong 10m | >7% trong 5m |
| callback_verify_fail_rate | >0.5% trong 15m | >2% trong 10m | >5% trong 5m |
| queue_backlog_size | >1,000 trong 10m | >3,000 trong 10m | >6,000 trong 5m |
| async_job_latency_p95 | >30s trong 15m | >90s trong 10m | >180s trong 5m |
| callback_processing_latency_p95 | >15s trong 15m | >45s trong 10m | >120s trong 5m |
| campaign_delivery_success_rate | <98% trong 1h | <95% trong 30m | <90% trong 15m |

## 2) Routing người nhận alert

- Sev-1: on-call primary + secondary + Tech Lead + PM.
- Sev-2: on-call primary + Tech Lead.
- Sev-3: on-call primary (ticket hóa nếu kéo dài > 24h).

## 3) Alert hygiene rules

- Mọi alert phải có runbook link.
- Không tạo alert không có owner.
- Alert flapping > 3 lần/ngày phải tuning threshold.
