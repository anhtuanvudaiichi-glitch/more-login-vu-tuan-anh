# 02-release-flow

- Owner role: **Tech Lead**
- Status: **Ready v1.0**
- Last updated: **2026-03-30**
- Related docs: [03-ci-cd-pipeline.md](./03-ci-cd-pipeline.md), [04-rollback-by-version.md](./04-rollback-by-version.md), [../../10-CUTOVER-ROLLBACK-OPERATIONS.md](../../10-CUTOVER-ROLLBACK-OPERATIONS.md)

## 1) Flow phát hành chuẩn

`Dev -> PR -> Staging Deploy -> UAT -> Production Deploy -> Post-release Monitoring`

## 2) Release artifact và tagging

- Mỗi release gắn tag semantic: `vMAJOR.MINOR.PATCH`.
- Artifact ghi rõ:
- commit SHA
- build timestamp UTC
- schema migration version
- config bundle version

## 3) Approval gates

| Gate | Điều kiện | Người duyệt |
|---|---|---|
| G1: Staging Deploy | Build+test+contract pass | Tech Lead |
| G2: UAT Exit | UAT sign-off + Sev-1/2 = 0 | QA Lead + PM |
| G3: Production Deploy | Cutover checklist ready | Tech Lead + DevOps Lead |

## 4) Release checklist

- [ ] Tag release đã tạo.
- [ ] Migration plan đã review.
- [ ] Feature flags đã cấu hình theo kế hoạch.
- [ ] Rollback version đã xác định.
- [ ] On-call roster đã active.

## 5) Post-release

- Theo dõi 60 phút đầu: error rate, latency, queue backlog, callback fail.
- Nếu vượt ngưỡng alert Sev-1/2: kích hoạt rollback-by-version.
