# Credential Management Architecture

![Credential Vault](../../images/security/credential-vault.png)

## 🎯 Problem Statement

**Question from community:**
> *"With 4 proxies serving 40 backends, how many unique credentials exist?"*

**Answer:**
```
Total Credentials = (N senders × OAuth2 credentials) + (M backends × Service accounts)

Example:
- 10 senders → 10 OAuth2 client credential pairs
- 40 backends → 40 service account credential pairs
- Total: 50 unique credential sets
```

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Credential Vault                         │
│                    (HashiCorp Vault / Azure Key Vault)      │
├──────────────────────────┬──────────────────────────────────┤
│  Per-Sender Credentials  │  Backend Service Accounts        │
│  (OAuth2 Client ID/Sec)  │  (API Keys / Basic Auth)         │
├──────────────────────────┼──────────────────────────────────┤
│  SENDER_A:               │  CPI_SALES:                      │
│    client_id: xxx        │    username: svc_sales           │
│    client_secret: ***    │    password: ***                 │
│    rotation: 90 days     │    rotation: 90 days             │
│                          │                                  │
│  SENDER_B:               │  CPI_FINANCE:                    │
│    client_id: yyy        │    username: svc_finance         │
│    client_secret: ***    │    password: ***                 │
│    rotation: 90 days     │    rotation: 90 days             │
│                          │                                  │
│  ... (N senders)         │  ... (M backends)                │
└──────────────────────────┴──────────────────────────────────┘
```

---

## 🔐 Credential Types

### 1. Per-Sender OAuth2 Credentials

**What:** Client credentials for each sender system to obtain OAuth2 tokens.

**Storage:**
```json
{
  "path": "gdcr/senders/SENDER_A",
  "data": {
    "client_id": "7f8e9d2c-4b3a-11ec-81d3-0242ac130003",
    "client_secret": "3xAmPl3S3cr3tK3y!2026",
    "issued_at": "2026-01-15T00:00:00Z",
    "rotate_at": "2026-04-15T00:00:00Z",
    "status": "active"
  }
}
```

**Rotation Policy:**
- **Frequency:** Every 90 days
- **Overlap:** 7-day grace period (old + new credentials both valid)
- **Automation:** Triggered by Vault policy engine

---

### 2. Backend Service Account Credentials

**What:** Credentials used by APIM to authenticate with backend systems (CPI, APIs).

**Storage:**
```json
{
  "path": "gdcr/backends/CPI_SALES",
  "data": {
    "type": "basic_auth",
    "username": "svc_sales_integration",
    "password": "C0mpl3xP@ssw0rd!2026",
    "endpoint": "https://cpi.company.com/sales",
    "issued_at": "2026-01-20T00:00:00Z",
    "rotate_at": "2026-04-20T00:00:00Z",
    "status": "active"
  }
}
```

**Backend Types:**
- SAP CPI: Basic Auth or OAuth2
- REST APIs: API Keys or Bearer tokens
- SOAP Services: WS-Security credentials

---

## 🔄 Credential Rotation Workflow

```
┌────────────────────────────────────────────────────────────┐
│ Day 0: Current credentials active                          │
│   Credential Set A (valid until Day 90)                    │
└────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌────────────────────────────────────────────────────────────┐
│ Day 83: Pre-rotation alert triggered                       │
│   Email sent to integration team                           │
└────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌────────────────────────────────────────────────────────────┐
│ Day 90: New credentials generated                          │
│   Credential Set B created                                 │
│   Overlap period starts (A + B both valid)                 │
└────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌────────────────────────────────────────────────────────────┐
│ Day 90-97: Grace period                                    │
│   Senders gradually migrate to Credential Set B            │
│   APIM accepts both A and B                                │
└────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌────────────────────────────────────────────────────────────┐
│ Day 97: Old credentials revoked                            │
│   Credential Set A deleted from Vault                      │
│   Only Set B remains valid                                 │
└────────────────────────────────────────────────────────────┘
```

---

## 📊 Credential Count Formula

### Scenario 1: Basic Setup
- **Senders:** 10
- **Backends:** 40
- **Proxies:** 4 (domain-based)

**Calculation:**
```
Per-Sender Credentials:
  10 senders × 1 OAuth2 credential pair = 10 credentials

Backend Service Accounts:
  40 backends × 1 service account = 40 credentials

Total: 50 unique credentials
```

---

### Scenario 2: High-Security Setup (Mutual TLS + OAuth2)
- **Senders:** 10
- **Backends:** 40
- **Additional:** Client certificates for mTLS

**Calculation:**
```
Per-Sender Credentials:
  10 senders × (1 OAuth2 + 1 Client Cert) = 20 credentials

Backend Service Accounts:
  40 backends × 1 service account = 40 credentials

Total: 60 unique credentials
```

---

### Scenario 3: GDCR @ Scale
- **Senders:** 100
- **Backends:** 500
- **Proxies:** 20 (multi-domain)

**Calculation:**
```
Per-Sender Credentials:
  100 senders × 1 OAuth2 credential pair = 100 credentials

Backend Service Accounts:
  500 backends × 1 service account = 500 credentials

Total: 600 unique credentials
```

**Key Insight:** Credential count scales **linearly** with senders + backends, **NOT** with proxies.

> **Why?** Domain-centric routing consolidates proxies. You don't create 1 proxy per integration.

---

## 🛡️ Vault Access Control

### Least Privilege Model

```
┌──────────────────────────────────────────────────────┐
│ Role: GDCR_Proxy_Runtime                             │
├──────────────────────────────────────────────────────┤
│ Permissions:                                         │
│   - READ: gdcr/senders/*                             │
│   - READ: gdcr/backends/*                            │
│   - DENY: gdcr/admin/*                               │
└──────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────┐
│ Role: GDCR_Admin                                     │
├──────────────────────────────────────────────────────┤
│ Permissions:                                         │
│   - READ/WRITE: gdcr/*                               │
│   - ROTATE: gdcr/senders/*                           │
│   - ROTATE: gdcr/backends/*                          │
└──────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────┐
│ Role: GDCR_Auditor                                   │
├──────────────────────────────────────────────────────┤
│ Permissions:                                         │
│   - READ: gdcr/audit/*                               │
│   - DENY: gdcr/senders/*                             │
│   - DENY: gdcr/backends/*                            │
└──────────────────────────────────────────────────────┘
```

---

## 🔧 Implementation: SAP APIM + HashiCorp Vault

### Step 1: Vault Setup

```bash
# Enable KV v2 secrets engine
vault secrets enable -path=gdcr kv-v2

# Create sender credential
vault kv put gdcr/senders/SENDER_A \
  client_id="7f8e9d2c-4b3a-11ec-81d3-0242ac130003" \
  client_secret="3xAmPl3S3cr3tK3y!2026" \
  issued_at="2026-01-15T00:00:00Z" \
  rotate_at="2026-04-15T00:00:00Z"

# Create backend credential
vault kv put gdcr/backends/CPI_SALES \
  username="svc_sales_integration" \
  password="C0mpl3xP@ssw0rd!2026" \
  endpoint="https://cpi.company.com/sales"
```

---

### Step 2: APIM Policy (Vault Integration)

```javascript
// Policy: Fetch-Backend-Credentials
// Execution: Before routing to backend

var backendName = context.getVariable("target.backend_name"); // e.g., "CPI_SALES"

// Call Vault API
var vaultURL = "https://vault.company.com/v1/gdcr/backends/" + backendName;
var vaultToken = context.getVariable("vault.token"); // From secure KVM

var vaultRequest = {
    method: "GET",
    url: vaultURL,
    headers: {
        "X-Vault-Token": vaultToken
    }
};

var response = httpClient.send(vaultRequest);

if (response.status !== 200) {
    throw new Error("Failed to fetch credentials from Vault");
}

var credentials = JSON.parse(response.content).data.data;

// Set credentials for backend call
context.setVariable("target.username", credentials.username);
context.setVariable("target.password", credentials.password);
```

---

## 🔄 Automated Rotation Script

```python
#!/usr/bin/env python3
# gdcr-rotate-credentials.py

import hvac
import datetime

VAULT_ADDR = "https://vault.company.com"
VAULT_TOKEN = "s.xxxxxxxxxxxxx"
ROTATION_DAYS = 90

client = hvac.Client(url=VAULT_ADDR, token=VAULT_TOKEN)

# Get all sender credentials
senders = client.secrets.kv.v2.list_secrets(path="gdcr/senders")

for sender in senders['data']['keys']:
    cred = client.secrets.kv.v2.read_secret_version(path=f"gdcr/senders/{sender}")
    
    rotate_at = datetime.datetime.fromisoformat(cred['data']['data']['rotate_at'])
    now = datetime.datetime.utcnow()
    
    # Check if rotation is due
    if now >= rotate_at:
        print(f"[ROTATE] {sender} - credentials expired")
        
        # Generate new credentials
        new_client_secret = generate_secure_secret()
        
        # Update Vault
        client.secrets.kv.v2.create_or_update_secret(
            path=f"gdcr/senders/{sender}",
            secret={
                "client_id": cred['data']['data']['client_id'],
                "client_secret": new_client_secret,
                "issued_at": now.isoformat(),
                "rotate_at": (now + datetime.timedelta(days=ROTATION_DAYS)).isoformat()
            }
        )
        
        # Notify sender system
        send_notification(sender, new_client_secret)
        
        print(f"[SUCCESS] {sender} - new credentials issued")
```

---

## 📊 Credential Inventory Dashboard

```
┌────────────────────────────────────────────────────────────┐
│ GDCR Credential Health Dashboard                          │
├────────────────────────────────────────────────────────────┤
│ Total Senders:           10                                │
│ Total Backends:          40                                │
│ Total Credentials:       50                                │
│                                                            │
│ Rotation Status:                                           │
│   ✅ Up to date:         42 (84%)                          │
│   ⚠️  Expiring soon:     6  (12%)                          │
│   ❌ Expired:            2  (4%)                           │
│                                                            │
│ Last Rotation:           2026-02-10                        │
│ Next Scheduled:          2026-05-10                        │
└────────────────────────────────────────────────────────────┘
```

---

## ✅ Best Practices

1. **Never hardcode credentials** in proxy configurations
2. **Use Vault dynamic secrets** where possible (generate on-demand)
3. **Rotate every 90 days** (or 30 days for high-security environments)
4. **Monitor expiry dates** with automated alerts
5. **Log all credential access** (who accessed which credential when)
6. **Encrypt credentials at rest** (Vault does this by default)

---

## 🚨 Incident Response: Credential Leak

```
┌────────────────────────────────────────────────────────────┐
│ 1. Detect: Anomalous credential usage in audit logs       │
├────────────────────────────────────────────────────────────┤
│ 2. Revoke: Immediately invalidate compromised credential  │
│    vault kv metadata delete gdcr/senders/SENDER_A         │
├────────────────────────────────────────────────────────────┤
│ 3. Rotate: Generate new credential with new client_id     │
│    (prevents replay attacks)                               │
├────────────────────────────────────────────────────────────┤
│ 4. Notify: Alert sender system administrator              │
├────────────────────────────────────────────────────────────┤
│ 5. Audit: Review all requests made with leaked credential │
└────────────────────────────────────────────────────────────┘
```

---

**Next:** [AUDIT-COMPLIANCE.md](../compliance/AUDIT-COMPLIANCE.md) for audit trail architecture.
