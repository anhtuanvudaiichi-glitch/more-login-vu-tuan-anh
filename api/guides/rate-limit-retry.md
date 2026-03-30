# MoreLogin Agent API — Rate Limiting and Retry Strategy

> Owner role: Backend Lead  
> Status: [SOURCE OF TRUTH] Approved v1.1  
> Last updated: 2026-03-30  
> Related docs: authentication.md, error-model.md, ../../docs-build-replit-ts/appendices/hmac-golden-vectors.md

## Rate Limits

| Limit | Value |
|-------|-------|
| Requests per minute | **60** per API key |
| Max request body size | **2 MB** (HTTP 413 if exceeded) |
| Timestamp replay window | **120 seconds** |
| Nonce TTL | **300 seconds** |

## Rate Limit Response (HTTP 429)

When the rate limit is exceeded, the agent returns:

```json
{
  "success": false,
  "data": null,
  "error": {
    "type": "rate_limit_error",
    "message": "Rate limit exceeded. Try again in 30 seconds.",
    "details": {
      "limit": 60,
      "window_seconds": 60
    },
    "retryable": true
  },
  "request_id": null,
  "agent_id": "agent-001",
  "job_id": null,
  "upstream_code": 429,
  "upstream_msg": "Too Many Requests"
}
```

### `Retry-After` Header

The 429 response includes a `Retry-After` header with the number of seconds to wait:

```
HTTP/1.1 429 Too Many Requests
Retry-After: 30
Content-Type: application/json
```

**Always respect this header** — do not retry before the indicated time.

## Payload Too Large (HTTP 413)

Requests with body larger than 2 MB are rejected:

```json
{
  "success": false,
  "error": {
    "type": "validation_error",
    "message": "Request body too large (max 2MB)",
    "details": {},
    "retryable": false
  },
  "agent_id": "agent-001"
}
```

This is **not retryable** — reduce your payload size.

## Retryable vs Non-Retryable Errors

| Error Type | HTTP Code | Retryable | Retry Strategy |
|------------|-----------|-----------|----------------|
| `validation_error` | 400 | ❌ No | Fix request and resend |
| `auth_error` | 401 | ❌ No | Fix credentials/signature |
| `auth_error` | 403 | ❌ No | Use loopback address |
| `not_found_error` | 404 | ❌ No | Check resource ID |
| `replay_error` | 409 | ❌ No | Use different idempotency key |
| `validation_error` | 413 | ❌ No | Reduce payload size |
| `rate_limit_error` | 429 | ✅ Yes | Wait for `Retry-After` |
| `internal_error` | 500 | ❌ No | Contact support |
| `upstream_business_error` | 502 | ⚠️ Maybe | Check `retryable` field |
| `transport_error` | 503 | ✅ Yes | Exponential backoff |

## Recommended Retry Strategy

### Exponential Backoff with Jitter

```python
import time
import random

def retry_with_backoff(func, max_retries=5, base_delay=1.0, max_delay=30.0):
    """Retry a function with exponential backoff and jitter."""
    for attempt in range(max_retries):
        try:
            result = func()
            if result.get("success"):
                return result

            error = result.get("error", {})
            retryable = error.get("retryable", False)

            if not retryable:
                raise NonRetryableError(error)

            # For rate limit, use Retry-After header
            if error.get("type") == "rate_limit_error":
                retry_after = error.get("details", {}).get("window_seconds", 60)
                time.sleep(retry_after)
                continue

        except ConnectionError:
            pass  # Network error — retry

        if attempt < max_retries - 1:
            delay = min(base_delay * (2 ** attempt), max_delay)
            jitter = random.uniform(0, delay * 0.1)
            time.sleep(delay + jitter)

    raise MaxRetriesExceeded(f"Failed after {max_retries} attempts")
```

### JavaScript Implementation

```javascript
async function retryWithBackoff(fn, maxRetries = 5, baseDelay = 1000, maxDelay = 30000) {
    for (let attempt = 0; attempt < maxRetries; attempt++) {
        try {
            const result = await fn();

            if (result.success) return result;

            const { type, retryable, details } = result.error || {};

            if (!retryable) throw new Error(`Non-retryable: ${result.error?.message}`);

            if (type === 'rate_limit_error') {
                const retryAfter = (details?.window_seconds || 60) * 1000;
                await new Promise(r => setTimeout(r, retryAfter));
                continue;
            }
        } catch (e) {
            if (e.message.startsWith('Non-retryable')) throw e;
            // Network error — retry
        }

        if (attempt < maxRetries - 1) {
            const delay = Math.min(baseDelay * (2 ** attempt), maxDelay);
            const jitter = Math.random() * delay * 0.1;
            await new Promise(r => setTimeout(r, delay + jitter));
        }
    }
    throw new Error(`Failed after ${maxRetries} attempts`);
}
```

## Retry Schedule Example

With `base_delay=1s`, `max_delay=30s`:

| Attempt | Delay | Cumulative |
|---------|-------|------------|
| 1 | 1s | 1s |
| 2 | 2s | 3s |
| 3 | 4s | 7s |
| 4 | 8s | 15s |
| 5 | 16s | 31s |
| 6 | 30s (capped) | 61s |

## Idempotency for Safe Retries

Use `idempotency_key` in command requests to safely retry without duplicate execution:

```json
{
  "request_id": "550e8400-e29b-41d4-a716-446655440000",
  "idempotency_key": "unique-operation-001",
  "target": { "profile_id": "[PLACEHOLDER:PROFILE_ID]" },
  "payload": { "script": "return document.title;" },
  "options": { "async": true }
}
```

| Scenario | Result |
|----------|--------|
| Same key + same payload | Returns cached result (`idempotent: true`) |
| Same key + different payload | Returns `replay_error` (409) with `existing_job_id` |
| No key | No idempotency protection |

**Window:** 24 hours — after that, the key can be reused.

## Callback Retry Behavior

Failed callback forwards use their own retry schedule:

| Parameter | Value |
|-----------|-------|
| Initial delay | 1 second |
| Multiplier | 2.0× |
| Max delay | 30 seconds |
| Max attempts | 8 |

After all retries fail → event marked as `dead_letter`.
Retry manually: `POST /agent/v1/local-ops/callbacks/dead-letter/{event_id}/retry`

## Best Practices

1. **Always check `retryable` field** before retrying
2. **Respect `Retry-After` header** on 429 responses
3. **Use exponential backoff with jitter** to avoid thundering herd
4. **Set a max retry count** (recommended: 3–5 for API calls)
5. **Use idempotency keys** for all mutating operations
6. **Log all retry attempts** with `request_id` for debugging
7. **Monitor retry rates** — high retry rates indicate systemic issues
8. **Don't retry 400/401/403/404/409/413** — these require fixing the request

