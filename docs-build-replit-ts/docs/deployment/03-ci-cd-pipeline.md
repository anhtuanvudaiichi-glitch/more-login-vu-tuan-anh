# 03-ci-cd-pipeline

- Owner role: **DevOps Lead**
- Status: **Ready v1.0**
- Last updated: **2026-03-30**
- Related docs: [02-release-flow.md](./02-release-flow.md), [../testing/02-contract-test-vectors.md](../testing/02-contract-test-vectors.md)

## 1) Pipeline stages

1. `lint` - static quality gates
2. `typecheck` - TS strict checks
3. `unit-test`
4. `integration-test`
5. `contract-test` (agent auth/envelope/retry)
6. `build`
7. `deploy-staging`
8. `smoke-test-staging`
9. `deploy-production` (manual approval)
10. `smoke-test-production`

## 2) Fail-fast rules

- Dừng pipeline ngay nếu `lint/typecheck/unit/integration/contract` fail.
- Không cho deploy production nếu smoke-test staging fail.

## 3) CI quality gates

| Gate | Ngưỡng |
|---|---|
| Unit test pass | 100% required suites |
| Integration pass | 100% P0 paths |
| Contract pass | 100% endpoint/command in-use |
| Build | Zero compile errors |

## 4) CD rules

- Staging deploy tự động sau main merge pass gates.
- Production deploy yêu cầu manual approval từ Tech Lead + DevOps.
- Rollback script bắt buộc có sẵn trước bước deploy production.

## 5) Smoke test tối thiểu sau deploy

- `GET /health`
- `GET /health/dependencies`
- Agent `GET /agent/v1/health`
- 1 command sync (`profile.status`) mock-safe
- 1 command async (`browser.open_and_run`) mock-safe + poll job

## 6) Evidence lưu trữ pipeline

- Build logs
- Test reports
- Contract test output
- Release artifact metadata
- Smoke test logs
