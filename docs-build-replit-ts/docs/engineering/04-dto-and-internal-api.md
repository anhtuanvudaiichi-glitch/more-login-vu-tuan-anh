# 04-dto-and-internal-api

- Owner role: **Backend Lead**
- Status: **Ready v1.0**
- Last updated: **2026-03-30**
- Related docs: [02-module-boundaries.md](./02-module-boundaries.md), [../../06-AGENT-API-CONTRACT-MAPPING.md](../../06-AGENT-API-CONTRACT-MAPPING.md)

## 1) Mục tiêu

Chốt DTO và internal API giữa `apps/web`, `apps/api`, `apps/worker`, `packages/shared`, `packages/agent-client` để đội kỹ thuật code không tự suy đoán wire contract.

## 2) Core shared DTO

```ts
export interface BaseRequestContextDto {
  requestId: string;
  correlationId: string;
  actorId?: string;
  workspaceId: string;
  tenantId: string;
}

export interface PaginationDto {
  page: number;
  pageSize: number;
}

export interface ErrorResponseDto {
  code: string;
  message: string;
  retryable: boolean;
  requestId: string;
}
```

## 3) Module DTO contracts

### IAM

- `LoginRequestDto { email, password }`
- `LoginResponseDto { accessToken, refreshToken, role, workspaceId }`

### Account

- `CreateAccountDto { externalUid, displayName, ownerUserId }`
- `StartProfileDto { accountId, isHeadless? }`
- `AccountStatusDto { accountId, profileState, healthState, lastSeenAt }`

### Inbox/CRM

- `UpsertConversationDto { accountId, customerId, channelType, lastMessageAt }`
- `CreateMessageDto { conversationId, direction, contentText, senderRef }`
- `TagCustomerDto { customerId, tags[] }`

### Campaign

- `CreateCampaignDto { name, segmentQuery, templateRef, scheduleAt, throttlePerMin }`
- `DeliveryAttemptDto { attemptId, campaignId, recipientId, stepNo, state, retryCount }`
- `CampaignProgressDto { campaignId, total, queued, running, sent, delivered, failed }`

### Admin

- `AuditQueryDto { from, to, actorId?, action?, page, pageSize }`
- `AuditItemDto { auditId, actorId, action, targetType, targetId, requestId, result, createdAt }`

## 4) Internal service interfaces

```ts
export interface AccountService {
  createAccount(ctx: BaseRequestContextDto, dto: CreateAccountDto): Promise<AccountStatusDto>;
  startProfile(ctx: BaseRequestContextDto, dto: StartProfileDto): Promise<AccountStatusDto>;
  stopProfile(ctx: BaseRequestContextDto, accountId: string): Promise<AccountStatusDto>;
}

export interface CampaignService {
  createCampaign(ctx: BaseRequestContextDto, dto: CreateCampaignDto): Promise<{ campaignId: string }>;
  pauseCampaign(ctx: BaseRequestContextDto, campaignId: string): Promise<void>;
  resumeCampaign(ctx: BaseRequestContextDto, campaignId: string): Promise<void>;
}
```

## 5) Worker contract

```ts
export interface JobPayloadDto {
  jobType: 'campaign_delivery' | 'job_polling' | 'callback_retry' | 'retention_cleanup';
  workspaceId: string;
  requestId: string;
  correlationId: string;
  data: Record<string, unknown>;
}
```

## 6) AgentClient usage contract

- Chỉ nhận input đã validate.
- Bắt buộc truyền `request_id`.
- Với luồng có khả năng retry duplicate, bắt buộc truyền `idempotency_key`.
- Chuẩn hóa error thành `ErrorResponseDto` ở lớp API facade.

## 7) Acceptance checklist DTO/API nội bộ

- [ ] Shared DTO compile strict và không có circular import.
- [ ] API handlers chỉ dùng DTO đã định nghĩa.
- [ ] Worker payload schema được validate trước enqueue.
- [ ] AgentClient usage tuân thủ rule request_id/idempotency.
