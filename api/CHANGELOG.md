# MoreLogin Agent API Changelog

> Owner role: Backend Lead  
> Status: [RELEASE HISTORY / REFERENCE] Active  
> Last updated: 2026-03-30  
> Related docs: guides/versioning.md, openapi/agent-v1.openapi.yaml, postman/MoreLogin-Agent.postman_collection.json, ../README.md

All notable changes to this API are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-25

### Added

- Core endpoints:
  - `GET /agent/v1/health`
  - `GET /agent/v1/health/upstream`
  - `GET /agent/v1/diagnostics/morelogin`
  - `POST /agent/v1/diagnostics/morelogin/refresh`
  - `POST /agent/v1/commands/{command_name}`
  - `GET /agent/v1/jobs/{job_id}`
  - `POST /agent/v1/callbacks/morelogin`
  - `POST /agent/v1/local-ops/callbacks/dead-letter/{event_id}/retry`

- Runtime command set:
  - `profile.list`
  - `profile.start`
  - `profile.stop`
  - `profile.status`
  - `browser.open_and_run`
  - `cloudphone.list`
  - `cloudphone.power_on`
  - `cloudphone.power_off`
  - `cloudphone.exec_command`
  - `file.attach_from_url`
  - `file.download`
  - `schedule.create`
  - `schedule.cancel`

- HMAC request authentication (`X-API-Key`, `X-Timestamp`, `X-Nonce`, `X-Signature`).
- Job queue and async execution tracking.
- Callback forwarding with retry and dead-letter handling.
- MoreLogin diagnostics snapshot and refresh trigger.
- Release pipeline artifacts: portable EXE, setup EXE, manifest, SHA256 checksums, release bundle ZIP.

### Changed

- Docs and contract artifacts are generated from runtime contract to prevent endpoint/command drift.
- Cloudphone diagnostics metrics parse proxy/tag data on a best-effort basis when upstream fields exist.

---

## Versioning Policy

- API versioning: URL-based (`/agent/v1/*`).
- Breaking changes require a new major API version path.
- Contract artifacts (OpenAPI/Postman/examples) are released with each version.
