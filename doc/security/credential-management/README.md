# Credential Management Architecture

## Problem Statement

**Question:**  
With 4 proxies serving 40 backends, how many credentials exist?

**Answer:**  

```
Total Credentials = (N senders × OAuth2 credentials) + (M backends × Service Accounts)
```

Example:

- 10 senders → 10 OAuth2 credential pairs  
- 40 backends → 40 service account credentials  
- **Total: 50 credential sets**

> Credential count scales with senders + backends — not with proxies.

---

# Architecture Overview

```plaintext
┌─────────────────────────────────────────────────────────────┐
│                    Credential Vault                         │
│           (HashiCorp Vault / Azure Key Vault)              │
├──────────────────────────┬──────────────────────────────────┤
│  Per-Sender Credentials  │  Backend Service Accounts        │
│  (OAuth2 Client Pairs)   │  (API Keys / Basic Auth / mTLS)  │
├──────────────────────────┼──────────────────────────────────┤
│  SENDER_A                │  CPI_SALES                       │
│  SENDER_B                │  CPI_FINANCE                     │
│  ... (N senders)         │  ... (M backends)                │
└──────────────────────────┴──────────────────────────────────┘
```

---

# Credential Types

## Per-Sender OAuth2 Credentials

Used by sender systems to obtain access tokens.

```json
{
  "path": "gdcr/senders/SENDER_A",
  "client_id": "...",
  "client_secret": "...",
  "rotate_at": "2026-04-15T00:00:00Z",
  "status": "active"
}
```

**Rotation Policy**
- Frequency: 90 days
- 7-day overlap period
- Automated via Vault

---

## Backend Service Accounts

Used by APIM/DDCR to authenticate with backends.

```json
{
  "path": "gdcr/backends/CPI_SALES",
  "type": "basic_auth",
  "username": "svc_sales",
  "rotate_at": "2026-04-20T00:00:00Z"
}
```

Supported backend types:
- SAP CPI (Basic Auth / OAuth2)
- REST APIs (API Keys / Bearer)
- SOAP (WS-Security)
- mTLS certificates

---

# Credential Scaling Scenarios

### Basic Setup
- 10 senders
- 40 backends
- Total: **50 credentials**

### High Security (OAuth2 + mTLS)
- 10 senders × 2 credentials = 20  
- 40 backends = 40  
- Total: **60 credentials**

### Enterprise Scale
- 100 senders
- 500 backends
- Total: **600 credentials**

> Domain-centric routing prevents proxy explosion. Credentials scale linearly.

---

# Rotation Lifecycle

```plaintext
Day 0   → Active credential
Day 83  → Pre-rotation alert
Day 90  → New credential issued
Day 90–97 → Grace period (both valid)
Day 97  → Old credential revoked
```

Zero downtime rotation supported.

---

# Vault Access Model (Least Privilege)

### Runtime Role
```plaintext
READ: gdcr/senders/*
READ: gdcr/backends/*
DENY: gdcr/admin/*
```

### Admin Role
```plaintext
READ/WRITE: gdcr/*
ROTATE: gdcr/*
```

### Auditor Role
```plaintext
READ: gdcr/audit/*
DENY: gdcr/senders/*
DENY: gdcr/backends/*
```

---

# Example: Vault Setup

```bash
vault secrets enable -path=gdcr kv-v2

vault kv put gdcr/senders/SENDER_A \
  client_id="..." \
  client_secret="..."

vault kv put gdcr/backends/CPI_SALES \
  username="svc_sales" \
  password="..."
```

---

# Example: APIM Vault Integration

```javascript
var backendName = context.getVariable("target.backend_name");

var vaultURL = "https://vault.company.com/v1/gdcr/backends/" + backendName;
var vaultToken = context.getVariable("vault.token");

var response = httpClient.send({
    method: "GET",
    url: vaultURL,
    headers: { "X-Vault-Token": vaultToken }
});

if (response.status !== 200) {
    throw new Error("Vault credential fetch failed");
}

var credentials = JSON.parse(response.content).data.data;

context.setVariable("target.username", credentials.username);
context.setVariable("target.password", credentials.password);
```

---

# Credential Health Dashboard (Conceptual)

```plaintext
Total Senders:      10
Total Backends:     40
Total Credentials:  50

Up to date:         84%
Expiring soon:      12%
Expired:             4%
```

---

# Incident Response (Credential Leak)

```plaintext
1. Detect anomalous usage in audit logs
2. Revoke compromised credential
3. Issue new credential (new ID + secret)
4. Notify system owner
5. Audit historical usage
```

---

# Best Practices

- Never hardcode credentials in proxies
- Use Vault dynamic secrets where possible
- Rotate every 90 days (30 for high-security)
- Log all credential access
- Encrypt at rest (Vault default)
- Monitor expiration with alerts

---

GDCR separates:

- Sender identity
- Backend credentials
- Routing logic

Credentials scale with systems — not with proxies.
Domain-centric routing prevents credential sprawl.

---
## ⚖️ Attribution & Intellectual Property

Gateway Domain-Centric Routing (GDCR) is an original architectural framework authored by **Ricardo Luz Holanda Viana**.

**First Public Disclosure:** February 7, 2026  
**Canonical Version:** v6.0  
**DOI:** 10.5281/zenodo.xxxxx  
**ORCID:** 0009-0009-9549-5862  
**License:** CC BY 4.0  

---
