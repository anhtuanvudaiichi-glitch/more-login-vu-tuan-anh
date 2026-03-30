# 04-oncall-playbook

- Owner role: **SRE/DevOps Lead**
- Status: **Ready v1.0**
- Last updated: **2026-03-30**
- Related docs: [02-alert-thresholds.md](./02-alert-thresholds.md), [../../10-CUTOVER-ROLLBACK-OPERATIONS.md](../../10-CUTOVER-ROLLBACK-OPERATIONS.md)

## 1) Quy trình chung khi nhận alert

1. Xác nhận severity và phạm vi ảnh hưởng.
2. Mở incident channel + gán Incident Commander.
3. Chạy triage checklist theo loại sự cố.
4. Quyết định mitigation hoặc rollback.
5. Cập nhật status mỗi 15 phút (Sev-1) hoặc 30 phút (Sev-2).

## 2) Playbook theo Sev

### Sev-1

- Điều kiện: outage diện rộng hoặc mất chức năng lõi.
- T0-5m: xác nhận alert và ảnh hưởng.
- T5-15m: lock risky features + kích hoạt rollback nếu cần.
- T15-60m: ổn định dịch vụ, xác thực flows P0.

### Sev-2

- Điều kiện: lỗi nặng một phần tính năng.
- Chặn luồng lỗi bằng feature flags.
- Tăng worker hoặc giảm throttle tạm thời.
- Escalate Sev-1 nếu lan rộng > 15 phút.

### Sev-3

- Điều kiện: lỗi cục bộ có workaround.
- Tạo ticket fix trong sprint gần nhất.
- Theo dõi trend 24h.

## 3) Runbook nhanh theo lỗi chính

| Sự cố | Kiểm tra nhanh | Hành động |
|---|---|---|
| auth_error tăng cao | clock drift, key mismatch, canonical path | rotate key/sync time/fix signing |
| rate_limit tăng cao | traffic burst, retry storm | throttle + queue shaping + Retry-After compliance |
| transport_error tăng cao | mạng Replit->agent/tunnel | failover URL/circuit breaker/rollback feature |
| callback verify fail | signature, nonce, timestamp | khóa endpoint tạm + audit raw payload |
| queue backlog tăng | worker down/slow command | scale worker + pause non-critical jobs |

## 4) Post-incident bắt buộc

- RCA trong 24h.
- Update docs liên quan (ops/testing/cutover/contract nếu cần).
- Theo dõi action items đến khi đóng.
