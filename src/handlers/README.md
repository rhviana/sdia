# handlers/

DDCR Engine — Kong Plugin evolution history.

| File | Version | Description |
|------|---------|-------------|
| `handler-v1.0-hardcoded.lua` | v1.0.0 | First working version. KVM hardcoded in Lua. No Redis. Proof of concept. |
| `handler-v1.1-mock.lua` | v1.0.1 | Mock mode. Generates CPI URL and returns 200 JSON without calling backend. Used for URL validation. |
| `handler-v2.0-redis.lua` | v2.0.0 | Redis integration. Dynamic KVM lookup via `resty.redis`. First production-grade version. |
| `handler-v2.2-production.lua` | v2.2.0 | **Production. This is what ran 100,002 requests with zero failures.** Redis + Action Map + SOAP/HTTP auto-detection + RESOURCE_MAP normalization. |

## Which one to use

Use `handler-v2.2-production.lua`. The others are kept for historical reference.

## Key fixes between v2.0 and v2.2

- Redis key pattern corrected to use `/` prefix and `/` separator
- SOAP protocol auto-detection → `cxf` prefix, `text/xml` Content-Type
- RESOURCE_MAP for path normalization (`manifests` → `manifest`)
- Action Map expanded with full variants
- ngx.log order fixed (was referencing `cpi_path` before declaration)

## The domain never lies.

Author: Ricardo Luz Holanda Viana | March 2026
DOI: https://doi.org/10.5281/zenodo.18619641
