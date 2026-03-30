# MoreLogin Agent API - Versioning Policy

> Owner role: Tech Lead + Backend Lead  
> Status: [SOURCE OF TRUTH] Approved v1.1  
> Last updated: 2026-03-30  
> Related docs: ../CHANGELOG.md, ../openapi/agent-v1.openapi.yaml, ../../docs-build-replit-ts/05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md

## 1) API versioning format

URL-based versioning:

```text
/agent/v1/{resource}
```

## 2) Lifecycle

| Stage | Description |
|---|---|
| Current | stable and fully supported |
| Deprecated | still works, sunset announced |
| Sunset | removed |

## 3) Support window policy

- Minimum support window for a major version: **24 months** from GA.
- Deprecation notice lead time: **>= 180 days** before sunset.
- Deprecated phase supports critical fixes/security only.

## 4) Current timeline

| Version | Status | GA Date | Deprecation Start | Sunset |
|---|---|---|---|---|
| v1 | Current | 2026-03-25 | 2028-01-01 | 2028-07-01 |

## 5) Communication requirements

When deprecating:
- emit response warning header
- publish migration guide
- update `CHANGELOG.md`
- update OpenAPI + Postman + docs mapping + test vectors (document-control gate)

## 6) Breaking-change rule

Breaking changes require new major version (`v2`, `v3`, ...):
- remove fields/endpoints
- change field types
- change requiredness/behavior incompatibly

Non-breaking additions may stay in same major version.
