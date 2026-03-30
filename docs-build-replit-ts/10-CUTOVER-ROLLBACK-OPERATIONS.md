# 10-CUTOVER-ROLLBACK-OPERATIONS

> Owner role: DevOps Lead + Tech Lead  
> Status: [SOURCE OF TRUTH] Approved v1.1  
> Last updated: 2026-03-30  
> Related docs: 11-REPLIT-BLUEPRINT.md, 08-REPLIT-DEPLOYMENT-AND-ENV-SETUP.md, 09-TEST-PLAN-AND-UAT.md

## 1) Pre-cutover gate

- [ ] Blueprint lock check pass theo `11-REPLIT-BLUEPRINT.md`.
- [ ] Replit templates da dung (`.replit`, `replit.nix`, env matrix).
- [ ] Golden vectors pass (HMAC + callback).
- [ ] Fixture matrix P0 pass.

## 2) Cutover sequence

1. Freeze merge ngoai pham vi release.
2. Tag release artifact cho `web`, `api`, `worker`.
3. Deploy `api` -> `worker` -> `web`.
4. Chay smoke suite bat buoc.
5. Mo traffic theo canary.
6. Theo doi 60 phut dau voi dashboard va alerts.

## 3) Rollback-by-version

### Trigger

- Loi Sev-1 tren luong P0.
- auth_error tang dot bien > 5% trong 10 phut.
- callback verify fail lien tuc > 3%.

### Trinh tu rollback

1. Tam dung luong async high-risk (feature flag).
2. Rollback `web`, `api`, `worker` ve tag on dinh gan nhat.
3. Xac nhan health + smoke.
4. Neu can, restore du lieu theo migration rollback plan.

## 4) Muc tieu MTTR

- Sev-1: <= 60 phut.
- Sev-2: <= 120 phut.

## 5) Bang chung sau cutover

- [ ] Log theo doi co `correlation_id`.
- [ ] Khong co queue backlog vuot nguong 500.
- [ ] Callback process latency trong threshold.
- [ ] Co bien ban “ky su thu 2 bring-up proof”.
