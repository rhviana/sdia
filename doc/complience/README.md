# Audit Trail & Compliance — Integrated GDCR Model

## 1. Architectural Positioning
Audit in GDCR is not an external logging feature; it is generated at the **deterministic routing boundary** of the DDCR engine. 

Every request processed by GDCR passes through a structured pipeline where each stage produces specific audit metadata:
1. **Context Extraction**
2. **Action Normalization**
3. **Metadata Resolution**
4. **Fail-Fast Validation**
5. **Dynamic Binding**

> [!IMPORTANT]
> Audit is a direct derivative of deterministic routing. No routing decision occurs without a trace.

---

## 2. Deterministic Audit Injection (DDCR Stage-Level Emission)

During execution, the **DDCR** generates metadata at each step of the lifecycle:

| Stage | Audit Field | Context |
| :--- | :--- | :--- |
| **Context Extraction** | `correlation_id`, `sender_id` | Endpoint & Header source |
| **Normalization** | `canonical_action_code` | Action Normalization Pattern |
| **Route Guard** | `domain`, `entity` | DCRP Segmentation |
| **Metadata Lookup** | `routing_key`, `backend_id` | Metadata Control Plane |
| **Validation** | `validation_result` | ALLOWED / FORBIDDEN |
| **Binding** | `target_adapter` | Execution Path |
| **Response Handling** | `latency_ms`, `status_code` | Performance & Outcome |

---

## 3. Standard Audit Event Model (GDCR-Aligned)

### API Execution Event Example
```json
{
  "timestamp": "2026-02-15T13:42:17.324Z",
  "correlation_id": "uuid-v4",
  "event_type": "API_REQUEST",
  "domain": "sales",
  "entity": "orders",
  "canonical_action": "c",
  "sender_id": "ERP_PROD",
  "auth_method": "OAuth2",
  "routing_key": "dcrporderscsalesforceid01:http",
  "backend_target": "CPI_SALES",
  "validation_result": "ALLOWED",
  "status_code": 200,
  "total_latency_ms": 342
}
```

## 4. Fail-Fast Security Audit
Fail-Fast rejections are treated as first-class audit events to ensure domain isolation is provable.
```json
{
  "event_type": "ACCESS_DENIED",
  "correlation_id": "uuid-v4",
  "domain": "finance",
  "entity": "invoices",
  "canonical_action": "r",
  "sender_id": "ERP_PROD",
  "validation_result": "FORBIDDEN",
  "reason": "Sender not authorized for domain",
  "blocked_at_stage": "Route Guard",
  "http_status": 403
}
```
## 5. Storage Architecture (Reference Model)

GDCR supports a multi-tier retention strategy based on domain criticality to balance performance and compliance:

* **Layer 1:** Real-time stream (Operational monitoring/Alerting).
* **Layer 2:** Searchable hot storage (Operational troubleshooting - e.g., 90 days).
* **Layer 3:** Long-term compliance storage (Regulatory retention - e.g., 7-10 years).

### Retention Policy by Domain

| Domain Type | Retention Period | Reason |
| :--- | :--- | :--- |
| **Financial** | 7 Years | SOX / Tax Compliance |
| **Security Incidents** | 10 Years | Forensic Audit |
| **Operational Logs** | 90 Days | Performance Analysis |

---

## 6. Compliance Alignment

GDCR provides the **deterministic traceability primitives** required by global frameworks:

* **GDPR:** Supports per-sender traceability, right-to-access extraction, and pseudonymization via `sender_id` abstraction.
* **SOX:** Ensures financial domain access logging, immutable routing decisions, and change traceability via metadata updates.
* **HIPAA:** Enforces the "minimum necessary" principle via **Route Guards** and provides full incident traceability.

---

## 7. Audit Query Examples (Domain-Centric)

Because the `routing_key` and `domain` are deterministic, audit queries remain stable over time and across vendor migrations.

**Query by Domain & Action:**
```sql
SELECT * FROM gdcr_audit
WHERE domain = "finance" 
  AND canonical_action = "c" 
  AND timestamp >= now-30d
```

## Query by Blocked Sender:

```sql
SELECT correlation_id, reason FROM gdcr_audit
WHERE sender_id = "ERP_PROD" 
  AND validation_result = "FORBIDDEN"
```
## 8. Architectural Guarantee

In a GDCR-compliant implementation, the following invariants are strictly enforced:

* **No routing** occurs without metadata.
* **No metadata lookup** occurs without a trace.
* **No validation** occurs without structured audit.
* **No backend binding** occurs without a correlation ID.

> [!TIP]
> Audit is not optional logging; it is a **structural property** of deterministic routing.

---
## ⚖️ Attribution & Intellectual Property

Gateway Domain-Centric Routing (GDCR) is an original architectural framework authored by **Ricardo Luz Holanda Viana**.

**First Public Disclosure:** February 7, 2026  
**Canonical Version:** v6.0  
**DOI:** 10.5281/zenodo.xxxxx  
**ORCID:** 0009-0009-9549-5862  
**License:** CC BY 4.0  

---
