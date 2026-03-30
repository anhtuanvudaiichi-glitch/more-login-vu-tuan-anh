# Web Tools TypeScript on Replit + MoreLogin Agent

> Onboarding entrypoint for the full implementation package.
> Owner role: Tech Lead + PM/Technical Writer  
> Status: [SOURCE OF TRUTH] Approved v1.0  
> Last updated: 2026-03-30  
> Related docs: docs-build-replit-ts/00-INDEX.md, docs-build-replit-ts/00-DOCS-MANIFEST.md, docs-build-replit-ts/11-REPLIT-BLUEPRINT.md, docs-build-replit-ts/08-REPLIT-DEPLOYMENT-AND-ENV-SETUP.md

## Mục lục

1. [Tên dự án](#1-tên-dự-án)
2. [Mục tiêu dự án](#2-mục-tiêu-dự-án)
3. [Phạm vi chức năng chính](#3-phạm-vi-chức-năng-chính)
4. [Kiến trúc triển khai đã chốt](#4-kiến-trúc-triển-khai-đã-chốt)
5. [Thứ tự đọc tài liệu bắt buộc](#5-thứ-tự-đọc-tài-liệu-bắt-buộc)
6. [Source of truth và precedence](#6-source-of-truth-và-precedence)
7. [Cấu trúc thư mục package](#7-cấu-trúc-thư-mục-package)
8. [Quick bring-up path](#8-quick-bring-up-path)
9. [Tài liệu bắt buộc trước khi code](#9-tài-liệu-bắt-buộc-trước-khi-code)
10. [Phân loại template/example/source-of-truth](#10-phân-loại-templateexamplesource-of-truth)
11. [Tiêu chí hoàn thành build](#11-tiêu-chí-hoàn-thành-build)
12. [Chủ sở hữu kỹ thuật](#12-chủ-sở-hữu-kỹ-thuật)
13. [Nhãn tài liệu phụ trợ](#13-nhãn-tài-liệu-phụ-trợ)

## 1. Tên dự án

Web Tools TypeScript on Replit - Zalo Marketing Tools Platform.

## 2. Mục tiêu dự án

Xây dựng bộ công cụ web chạy trên Replit để vận hành các luồng marketing/automation,
tích hợp với Agent Python MoreLogin và MoreLogin Local API theo contract chuẩn.
Đối tượng sử dụng chính: Tech Lead, Backend, DevOps/Replit Engineer, QA và đội vận hành.

## 3. Phạm vi chức năng chính

- Quản lý profile/account và trạng thái phiên làm việc.
- Gửi command từ Web Tools sang Agent qua `AgentClient`.
- Xử lý callback có verify chữ ký.
- Quản lý job async, polling, retry, idempotency.
- Quan sát hệ thống, kiểm thử/UAT, cutover và rollback.

## 4. Kiến trúc triển khai đã chốt

Mô hình triển khai chính thức: **1 workspace + 3 deployment services** gồm:
- `web`
- `api`
- `worker`

Luồng tích hợp chuẩn:
`Web Tools TypeScript (Replit) -> Agent Python MoreLogin -> MoreLogin Local API`

## 5. Thứ tự đọc tài liệu bắt buộc

1. `README.md` (file này)
2. `docs-build-replit-ts/00-INDEX.md`
3. `docs-build-replit-ts/11-REPLIT-BLUEPRINT.md`
4. `docs-build-replit-ts/08-REPLIT-DEPLOYMENT-AND-ENV-SETUP.md`
5. `api/guides/quickstart.md`
6. `docs-build-replit-ts/09-TEST-PLAN-AND-UAT.md`
7. `docs-build-replit-ts/10-CUTOVER-ROLLBACK-OPERATIONS.md`

## 6. Source of truth và precedence

Nguồn chuẩn ưu tiên cao nhất:
1. `docs-build-replit-ts/11-REPLIT-BLUEPRINT.md`
2. `docs-build-replit-ts/00-DOCS-MANIFEST.md`
3. `docs-build-replit-ts/05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md`
4. `api/openapi/agent-v1.openapi.yaml` và `api/openapi/agent-v1.openapi.json`
5. `docs-build-replit-ts/06-AGENT-API-CONTRACT-MAPPING.md`

Nếu xung đột giữa root và `docs-build-replit-ts/docs/*`, luôn ưu tiên tài liệu root-level.

## 7. Cấu trúc thư mục package

- `api/`: OpenAPI, guides, Postman, changelog, fixtures examples.
- `docs-build-replit-ts/`: bộ build docs chính (source-of-truth thi công).
- `docs-build-replit-ts/docs/`: deep-dive theo domain (db/engineering/deployment/ops/testing).
- `docs-build-replit-ts/appendices/`: templates, vectors, fixture matrix, proof/checklists.
- `deep-research-report (1).md`: báo cáo nền tảng tham khảo ban đầu.

## 8. Quick bring-up path

1. Đọc `docs-build-replit-ts/11-REPLIT-BLUEPRINT.md`.
2. Copy template phù hợp:
   - dev orchestrator: `docs-build-replit-ts/appendices/.replit.example`
   - service-specific: `.replit.web.example`, `.replit.api.example`, `.replit.worker.example`
3. Cấu hình env theo `docs-build-replit-ts/appendices/.env.example.md`.
4. Xác nhận secrets theo `docs-build-replit-ts/appendices/replit-secrets-matrix.md`.
5. Chạy kiểm tra HMAC/callback theo golden vectors.
6. Chạy bring-up checklist: `docs-build-replit-ts/appendices/replit-bringup-proof-checklist.md`.

## 9. Tài liệu bắt buộc trước khi code

- `docs-build-replit-ts/11-REPLIT-BLUEPRINT.md`
- `docs-build-replit-ts/08-REPLIT-DEPLOYMENT-AND-ENV-SETUP.md`
- `api/guides/quickstart.md`
- `api/guides/authentication.md`
- `api/guides/callbacks.md`
- `docs-build-replit-ts/09-TEST-PLAN-AND-UAT.md`
- `docs-build-replit-ts/10-CUTOVER-ROLLBACK-OPERATIONS.md`

## 10. Phân loại template/example/source-of-truth

- `SOURCE OF TRUTH`: `11-REPLIT-BLUEPRINT.md`, root manifest/document-control, OpenAPI, `06-AGENT-API-CONTRACT-MAPPING.md`.
- `TEMPLATE`: các file `.replit*.example`, `.env.example.md`, issue/risk/change templates.
- `EXAMPLE/TEST ARTIFACT`: `api/examples/fixtures/*`, postman runtime examples.

## 11. Tiêu chí hoàn thành build

- Healthcheck pass cho `web/api/worker`.
- HMAC golden vectors pass.
- Callback signature vectors pass.
- Fixture JSON parse pass.
- Bring-up proof pass.
- Rollback simulation/drill pass.

## 12. Chủ sở hữu kỹ thuật

- Tech Lead: kiến trúc + source-of-truth governance.
- Backend Lead: API contract, auth/callback, agent integration.
- DevOps/Replit Engineer: deployment model, env/secrets, rollback.
- QA Lead: fixture vectors, test/UAT, acceptance evidence.

## 13. Nhãn tài liệu phụ trợ

- `deep-research-report (1).md` = `BACKGROUND ONLY / NOT SOURCE OF TRUTH`.
- `api/CHANGELOG.md` = `RELEASE HISTORY / REFERENCE`.
- `api/openapi/*` = `MACHINE-READABLE CONTRACT`.
- `api/postman/*` = `TEST/EXECUTION AID`.
- `docs-build-replit-ts/*` (root-level) = `SOURCE OF TRUTH FOR IMPLEMENTATION`.
