# 04-rollback-by-version

- Owner role: **DevOps Lead**
- Status: **Ready v1.0**
- Last updated: **2026-03-30**
- Related docs: [02-release-flow.md](./02-release-flow.md), [../../10-CUTOVER-ROLLBACK-OPERATIONS.md](../../10-CUTOVER-ROLLBACK-OPERATIONS.md), [../db/04-migrations-plan.md](../db/04-migrations-plan.md)

## 1) Trigger rollback

- Sev-1 incident trong 60 phút đầu sau release.
- Tỷ lệ lỗi agent call vượt ngưỡng Sev-1 liên tục > 10 phút.
- Mismatch dữ liệu nghiêm trọng do migration/release.

## 2) Rollback theo version tag

1. Xác định `last_known_good_tag`.
2. Dừng rollout traffic mới.
3. Deploy lại artifact tại `last_known_good_tag`.
4. Disable feature flags mới nếu có.
5. Kiểm tra health/smoke test.

## 3) Data-safe checklist

- [ ] Xác định migration nào đã chạy sau tag ổn định.
- [ ] Chỉ rollback schema khi có runbook cho version đó.
- [ ] Nếu có rủi ro data loss: dùng forward-fix + block risky features.

## 4) Verification sau rollback

- [ ] Health checks pass.
- [ ] P0 business flows pass.
- [ ] Queue backlog trở về ngưỡng ổn định.
- [ ] Incident được cập nhật trạng thái và RCA opened.

## 5) Ownership

- Incident Commander: DevOps Lead.
- Technical decision: Tech Lead.
- Data decision: Backend Lead.
