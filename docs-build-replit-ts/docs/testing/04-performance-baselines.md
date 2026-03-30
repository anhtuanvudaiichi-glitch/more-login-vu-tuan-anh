# 04-performance-baselines

- Owner role: **QA Performance + Backend Lead**
- Status: **Ready v1.0**
- Last updated: **2026-03-30**
- Related docs: [../ops/01-metrics-catalog.md](../ops/01-metrics-catalog.md), [../ops/02-alert-thresholds.md](../ops/02-alert-thresholds.md)

## 1) Baseline targets

| Metric | Baseline Pass |
|---|---|
| API p95 latency (non-campaign) | <= 400ms |
| Agent call p95 latency (sync) | <= 800ms |
| Async job completion p95 | <= 90s |
| Callback processing p95 | <= 20s |
| Queue backlog under normal load | <= 1,000 |
| Campaign delivery success rate | >= 98% |

## 2) Throughput scenarios

| Scenario | Load | Duration | Pass Criteria |
|---|---|---|---|
| PERF-API-001 | 100 RPS mixed API | 15m | error rate < 1% |
| PERF-CMP-001 | 10k recipients campaign | 30m | no duplicate send |
| PERF-CBK-001 | 200 callback/min | 20m | verify fail < 0.5% |
| PERF-RETRY-001 | Inject 429/503 | 15m | retries respect policy |

## 3) Retry behavior pass/fail

- Pass khi:
- 429 dùng `Retry-After` đúng.
- 503/transport dùng backoff+jitter và không gây retry storm.
- Non-retryable errors không retry.

- Fail khi:
- Retry vượt max attempts không kiểm soát.
- Duplicate execution do idempotency key sai.

## 4) Evidence bắt buộc

- Benchmark report raw + summary.
- Metrics dashboard export trong thời gian test.
- Sample logs với request_id/correlation_id/job_id.
- Kết luận pass/fail có chữ ký QA Lead.
