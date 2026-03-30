# 00-INDEX

> Owner role: Tech Lead + PM  
> Status: [SOURCE OF TRUTH] Approved v1.2  
> Last updated: 2026-03-30  
> Related docs: 00-DOCS-MANIFEST.md, 11-REPLIT-BLUEPRINT.md, 05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md

## 1) Muc tieu

Bo tai lieu nay dat muc implementation-ready cho thi cong Web Tools tren Replit,
voi kien truc bat buoc:

`Web Tools TypeScript (Replit) -> Agent Python MoreLogin -> MoreLogin Local API`

## 2) Thu tu doc bat buoc

1. `00-DOCS-MANIFEST.md`
2. `11-REPLIT-BLUEPRINT.md`
3. `01-PROJECT-CHARTER-AND-SUCCESS.md`
4. `02-TARGET-ARCHITECTURE-REPLIT-AGENT.md`
5. `03-IMPLEMENTATION-ROADMAP-WBS.md`
6. `04-MODULE-BUILD-SPECS.md`
7. `05-DATA-MODEL-AND-STATE-MACHINES.md`
8. `06-AGENT-API-CONTRACT-MAPPING.md`
9. `07-SECURITY-AUTH-COMPLIANCE.md`
10. `08-REPLIT-DEPLOYMENT-AND-ENV-SETUP.md`
11. `09-TEST-PLAN-AND-UAT.md`
12. `10-CUTOVER-ROLLBACK-OPERATIONS.md`
13. `05-DOCUMENT-CONTROL-AND-CHANGE-RULES.md`
14. `appendices/.replit.example`
15. `appendices/.replit.web.example`
16. `appendices/.replit.api.example`
17. `appendices/.replit.worker.example`
18. `appendices/replit-service-deployment-mapping.md`
19. `appendices/replit.nix.example`
20. `appendices/.env.example.md`
21. `appendices/replit-secrets-matrix.md`
22. `appendices/hmac-golden-vectors.md`
23. `appendices/callback-signature-golden-vectors.md`
24. `appendices/fixture-samples.md`
25. `appendices/test-fixture-matrix.csv`
26. `appendices/replit-bringup-proof-checklist.md`
27. `appendices/internal-acceptance-report-100.md`

## 3) Rule bat buoc

- Moi feature Web Tools phai goi qua `packages/agent-client`.
- Cam call truc tiep MoreLogin Local API tu Web Tools.
- Khong commit secret that vao docs/postman/openapi.
- Khong dung path tuyet doi may ca nhan.

## 4) Deep-dive docs

Thu muc `docs-build-replit-ts/docs/*` duoc giu lai nhu tai lieu chi tiet bo sung
(DB/engineering/deployment/ops/testing), nhung source-of-truth de thi cong
duoc khoa o root-level files va `appendices/*`.
