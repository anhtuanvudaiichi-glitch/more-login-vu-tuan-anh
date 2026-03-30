# MoreLogin Agent API — Error Model

> Owner role: Backend Lead  
> Status: [SOURCE OF TRUTH] Approved v1.1  
> Last updated: 2026-03-30  
> Related docs: authentication.md, rate-limit-retry.md, ../../docs-build-replit-ts/06-AGENT-API-CONTRACT-MAPPING.md

## Response Envelope

All API responses follow a consistent envelope format.

### Success Response

```json
{
  "success": true,
  "data": { "...command-specific result..." },
  "error": null,
  "request_id": "550e8400-e29b-41d4-a716-446655440000",
  "agent_id": "agent-001",
  "job_id": null,
  "upstream_code": 0,
  "upstream_msg": "ok"
}
```

### Error Response

```json
{
  "success": false,
  "data": null,
  "error": {
    "type": "validation_error",
    "message": "Profile ID is required for browser commands",
    "details": {
      "field": "target.profile_id",
      "reason": "missing_required"
    },
    "retryable": false
  },
  "request_id": "550e8400-e29b-41d4-a716-446655440000",
  "agent_id": "agent-001",
  "job_id": null,
  "upstream_code": 400,
  "upstream_msg": "Bad Request"
}
```

## Envelope Fields

| Field | Type | Description |
|-------|------|-------------|
| `success` | boolean | `true` if operation succeeded |
| `data` | object \| null | Response payload (null on error) |
| `error` | ErrorDetail \| null | Error detail (null on success) |
| `request_id` | string \| null | Echo of client-provided `request_id` |
| `agent_id` | string | Agent identifier |
| `job_id` | integer \| null | Job ID for async commands |
| `upstream_code` | integer | MoreLogin upstream code (0 = no upstream call) |
| `upstream_msg` | string | MoreLogin upstream message |

## ErrorDetail Schema

| Field | Type | Description |
|-------|------|-------------|
| `type` | string | Error type identifier (see table below) |
| `message` | string | Human-readable error message |
| `details` | object \| null | Additional context (field names, upstream codes, etc.) |
| `retryable` | boolean | `true` if client should retry with backoff |

## Error Types

| Type | HTTP Code | Retryable | Description |
|------|-----------|-----------|-------------|
| `validation_error` | 400 | No | Invalid request parameters or missing required fields |
| `auth_error` | 401 | No | Authentication failed (bad key, expired timestamp, nonce reuse) |
| `auth_error` | 403 | No | Forbidden — endpoint only accessible from loopback |
| `not_found_error` | 404 | No | Resource not found (job ID, event ID) |
| `replay_error` | 409 | No | Idempotency key conflict |
| `validation_error` | 413 | No | Request body exceeds 2 MB limit |
| `rate_limit_error` | 429 | Yes | Rate limit exceeded (60 req/min per key) |
| `internal_error` | 500 | No | Internal server error |
| `upstream_business_error` | 502 | Maybe | MoreLogin API returned a business error |
| `transport_error` | 503 | Yes | Network/connectivity issue to MoreLogin |

## HTTP Status Code Reference

| Code | Meaning | When |
|------|---------|------|
| 200 | OK | Request succeeded |
| 400 | Bad Request | Validation error, missing required field |
| 401 | Unauthorized | HMAC auth failed |
| 403 | Forbidden | Non-loopback access to local-only endpoint |
| 404 | Not Found | Job or resource not found |
| 409 | Conflict | Idempotency key used with different payload |
| 413 | Payload Too Large | Request body > 2 MB |
| 422 | Unprocessable Entity | FastAPI request validation (malformed JSON, wrong types) |
| 429 | Too Many Requests | Rate limit exceeded (check `Retry-After` header) |
| 500 | Internal Server Error | Unexpected server error |
| 502 | Bad Gateway | MoreLogin API returned error |
| 503 | Service Unavailable | Cannot reach MoreLogin API |

## Error Handling Examples

### Python

```python
import requests
import time

def call_agent(method, url, headers, data=None, max_retries=3):
    """Call agent with automatic retry for retryable errors."""
    for attempt in range(max_retries):
        if method == "GET":
            response = requests.get(url, headers=headers)
        else:
            response = requests.post(url, headers=headers, json=data)

        result = response.json()

        if result.get("success"):
            return result.get("data")

        error = result.get("error", {})
        error_type = error.get("type")
        message = error.get("message")
        retryable = error.get("retryable", False)

        if error_type == "auth_error":
            raise AuthError(f"Authentication failed: {message}")
        elif error_type == "validation_error":
            raise ValidationError(f"Invalid request: {message}")
        elif error_type == "replay_error":
            existing_job = error.get("details", {}).get("existing_job_id")
            raise IdempotencyError(f"Conflict: {message}", existing_job_id=existing_job)
        elif error_type == "not_found_error":
            raise NotFoundError(f"Not found: {message}")
        elif error_type == "rate_limit_error":
            retry_after = int(response.headers.get("Retry-After", 30))
            time.sleep(retry_after)
            continue
        elif retryable and attempt < max_retries - 1:
            time.sleep(2 ** attempt)  # exponential backoff
            continue
        else:
            raise AgentError(f"Agent error [{error_type}]: {message}")

    raise AgentError("Max retries exceeded")
```

### JavaScript

```javascript
async function callAgent(method, url, headers, data = null, maxRetries = 3) {
    for (let attempt = 0; attempt < maxRetries; attempt++) {
        const options = { method, headers };
        if (data) options.body = JSON.stringify(data);

        const response = await fetch(url, options);
        const result = await response.json();

        if (result.success) return result.data;

        const { type, message, retryable, details } = result.error || {};

        switch (type) {
            case 'auth_error':
                throw new Error(`Auth failed: ${message}`);
            case 'validation_error':
                throw new Error(`Validation: ${message}`);
            case 'replay_error':
                throw new Error(`Idempotency conflict: ${message} (existing: ${details?.existing_job_id})`);
            case 'not_found_error':
                throw new Error(`Not found: ${message}`);
            case 'rate_limit_error': {
                const retryAfter = parseInt(response.headers.get('Retry-After') || '30');
                await new Promise(r => setTimeout(r, retryAfter * 1000));
                continue;
            }
            default:
                if (retryable && attempt < maxRetries - 1) {
                    await new Promise(r => setTimeout(r, 2 ** attempt * 1000));
                    continue;
                }
                throw new Error(`Agent error [${type}]: ${message}`);
        }
    }
    throw new Error('Max retries exceeded');
}
```

## Common Error Scenarios

### Missing Required Field (400)

```json
{
  "success": false,
  "error": {
    "type": "validation_error",
    "message": "profile_id is required for browser commands",
    "details": { "field": "target.profile_id", "reason": "missing_required" },
    "retryable": false
  }
}
```

**Resolution:** Include the required `target.profile_id` field in your request.

### Authentication Failed (401)

```json
{
  "success": false,
  "error": {
    "type": "auth_error",
    "message": "Invalid HMAC signature",
    "details": {},
    "retryable": false
  }
}
```

**Resolution:**
1. Verify API Key ID and Secret are correct
2. Check timestamp is within 120-second window
3. Ensure nonce is fresh (not reused within 300s)
4. Verify canonical string uses PATH only (no query string)
5. Verify SHA-256 body hash is lowercase hex

### Idempotency Conflict (409)

```json
{
  "success": false,
  "error": {
    "type": "replay_error",
    "message": "Idempotency key conflict",
    "details": { "existing_job_id": 12345 },
    "retryable": false
  }
}
```

**Resolution:** The same `idempotency_key` was used with a different payload. Check `existing_job_id` for the original job.

### Payload Too Large (413)

```json
{
  "success": false,
  "error": {
    "type": "validation_error",
    "message": "Request body too large (max 2MB)",
    "details": {},
    "retryable": false
  }
}
```

**Resolution:** Reduce request body size to under 2 MB.

### Rate Limited (429)

```json
{
  "success": false,
  "error": {
    "type": "rate_limit_error",
    "message": "Rate limit exceeded. Try again in 30 seconds.",
    "details": { "limit": 60, "window_seconds": 60 },
    "retryable": true
  }
}
```

**Resolution:** Wait for `Retry-After` header value (seconds), then retry. Limit: 60 requests/minute per API key.

### Upstream Error (502)

```json
{
  "success": false,
  "error": {
    "type": "upstream_business_error",
    "message": "Profile not found",
    "details": { "upstream_code": 1001, "profile_id": "INVALID_ID" },
    "retryable": false
  }
}
```

**Resolution:** The MoreLogin API returned an error. Verify the profile/resource ID exists.

### Transport Error (503)

```json
{
  "success": false,
  "error": {
    "type": "transport_error",
    "message": "Connection timeout to MoreLogin API",
    "details": {},
    "retryable": true
  }
}
```

**Resolution:** Network issue. Retry with exponential backoff. Check that MoreLogin desktop app is running.

## Best Practices

1. **Always check `success` field** before accessing `data`
2. **Log `request_id`** and `agent_id` for debugging and support
3. **Implement retry logic** for `retryable: true` errors with exponential backoff
4. **Respect `Retry-After` header** on 429 responses
5. **Use `idempotency_key`** to safely retry commands without duplicate execution
6. **Monitor `upstream_code`** to track MoreLogin API health
7. **Handle all error types** — don't assume only certain errors will occur
