
# Audit Trail & Compliance

## 🎯 Problem Statement

**Question from community:**
> *"How is per-sender audit trail maintained for compliance?"*

**Answer:**
> **Every request is logged with sender context, endpoint, timestamp, action, and result. Logs are immutable and retained per compliance policy (e.g., 7 years for financial data).**

---

## 📊 Audit Log Structure

### Standard Audit Entry

```json
{
  "timestamp": "2026-02-15T13:42:17.324Z",
  "correlation_id": "7f3e9c2d-8a4b-11ec-a8a3-0242ac120002",
  "event_type": "API_REQUEST",
  "severity": "INFO",
  
  "sender": {
    "sender_id": "SENDER_A",
    "client_name": "ERP_Production",
    "ip_address": "203.0.113.45",
    "user_agent": "SAP-ERP/1.5"
  },
  
  "request": {
    "method": "POST",
    "endpoint": "/sales/orders",
    "path": "/v1/sales/orders",
    "query_params": {},
    "headers": {
      "Content-Type": "application/json",
      "Authorization": "Bearer [REDACTED]"
    }
  },
  
  "security": {
    "token_hash": "sha256:7f3e9c2d8a4b11eca8a30242ac120002",
    "scopes": ["sales:read", "sales:write"],
    "auth_method": "OAuth2",
    "validation_result": "SUCCESS"
  },
  
  "routing": {
    "backend_name": "CPI_SALES",
    "backend_url": "https://cpi.company.com/sales/orders",
    "routing_decision": "ALLOWED",
    "latency_ms": 14
  },
  
  "response": {
    "status_code": 200,
    "body_size_bytes": 2048,
    "latency_ms": 342
  },
  
  "compliance": {
    "data_classification": "CONFIDENTIAL",
    "retention_years": 7,
    "gdpr_applicable": true,
    "auditor_notes": null
  }
}
```

---

## 🔒 Security Violation Audit Entry

```json
{
  "timestamp": "2026-02-15T14:18:03.112Z",
  "correlation_id": "9e2f1b4c-8a4b-11ec-a8a3-0242ac120003",
  "event_type": "ACCESS_DENIED",
  "severity": "WARNING",
  
  "sender": {
    "sender_id": "SENDER_A",
    "client_name": "ERP_Production",
    "ip_address": "203.0.113.45"
  },
  
  "request": {
    "method": "GET",
    "endpoint": "/finance/invoices",
    "attempted_at": "2026-02-15T14:18:03.112Z"
  },
  
  "security": {
    "token_hash": "sha256:7f3e9c2d8a4b11eca8a30242ac120002",
    "scopes": ["sales:read", "sales:write"],
    "required_scopes": ["finance:admin"],
    "auth_method": "OAuth2",
    "validation_result": "FORBIDDEN"
  },
  
  "violation": {
    "type": "UNAUTHORIZED_ENDPOINT_ACCESS",
    "reason": "Sender not in allowed_senders list for /finance/invoices",
    "action_taken": "Request blocked, HTTP 403 returned",
    "alert_triggered": true
  },
  
  "compliance": {
    "data_classification": "SECURITY_INCIDENT",
    "retention_years": 10,
    "reported_to": ["security-team@company.com"],
    "investigation_required": true
  }
}
```

---

## 🗂️ Audit Log Storage

```
┌─────────────────────────────────────────────────────────────┐
│                  Audit Log Architecture                     │
├─────────────────────────────────────────────────────────────┤
│ Layer 1: Real-time Stream (Kafka / Azure Event Hub)        │
│   - Latency: <50ms                                          │
│   - Retention: 7 days                                       │
│   - Use: Monitoring, alerting                               │
├─────────────────────────────────────────────────────────────┤
│ Layer 2: Hot Storage (Elasticsearch)                        │
│   - Latency: <1s query                                      │
│   - Retention: 90 days                                      │
│   - Use: Operational dashboards, troubleshooting            │
├─────────────────────────────────────────────────────────────┤
│ Layer 3: Warm Storage (S3 / Azure Blob)                     │
│   - Latency: <5s query                                      │
│   - Retention: 1-3 years                                    │
│   - Use: Compliance reports, investigations                 │
├─────────────────────────────────────────────────────────────┤
│ Layer 4: Cold Storage (Glacier / Archive)                   │
│   - Latency: Hours to retrieve                              │
│   - Retention: 7 years (regulatory requirement)             │
│   - Use: Legal holds, audits                                │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔍 Audit Queries

### Query 1: All Requests by Sender

```json
GET /audit-logs/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "sender.sender_id": "SENDER_A" }},
        { "range": { "timestamp": { "gte": "now-7d" }}}
      ]
    }
  },
  "sort": [{ "timestamp": "desc" }],
  "size": 1000
}
```

---

### Query 2: Security Violations (Last 24h)

```json
GET /audit-logs/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "event_type": "ACCESS_DENIED" }},
        { "range": { "timestamp": { "gte": "now-24h" }}}
      ]
    }
  },
  "aggs": {
    "by_sender": {
      "terms": { "field": "sender.sender_id" }
    }
  }
}
```

---

### Query 3: Compliance Report (Per-Sender Activity)

```sql
-- SQL-style query for reporting (using Elasticsearch SQL API)

SELECT 
  sender.sender_id,
  COUNT(*) as total_requests,
  AVG(response.latency_ms) as avg_latency,
  SUM(CASE WHEN response.status_code >= 400 THEN 1 ELSE 0 END) as error_count,
  SUM(CASE WHEN event_type = 'ACCESS_DENIED' THEN 1 ELSE 0 END) as security_violations
FROM audit_logs
WHERE timestamp >= '2026-02-01' AND timestamp < '2026-03-01'
GROUP BY sender.sender_id
ORDER BY total_requests DESC;
```

**Sample Output:**
```
┌─────────────┬────────────────┬─────────────┬─────────────┬─────────────────────┐
│ sender_id   │ total_requests │ avg_latency │ error_count │ security_violations │
├─────────────┼────────────────┼─────────────┼─────────────┼─────────────────────┤
│ SENDER_A    │ 45,230         │ 287ms       │ 12          │ 2                   │
│ SENDER_B    │ 32,104         │ 412ms       │ 8           │ 0                   │
│ SENDER_C    │ 18,567         │ 195ms       │ 3           │ 1                   │
│ SENDER_D    │ 9,821          │ 523ms       │ 42          │ 15                  │ ⚠️
└─────────────┴────────────────┴─────────────┴─────────────┴─────────────────────┘
```

---

## 🚨 Alerting Rules

### Rule 1: Repeated Security Violations

```yaml
alert: RepeatedAccessDenied
expr: |
  rate(audit_logs{event_type="ACCESS_DENIED"}[5m]) > 5
for: 10m
labels:
  severity: warning
annotations:
  summary: "Sender {{ $labels.sender_id }} triggered multiple access denials"
  description: "{{ $value }} violations in the last 5 minutes"
actions:
  - notify: security-team@company.com
  - create_incident: PagerDuty
```

---

### Rule 2: Unusual Request Volume

```yaml
alert: AnomalousRequestVolume
expr: |
  rate(audit_logs{event_type="API_REQUEST", sender_id="SENDER_A"}[1h]) > 
  (avg_over_time(rate(audit_logs{sender_id="SENDER_A"}[1h])[7d]) * 3)
for: 15m
labels:
  severity: info
annotations:
  summary: "Sender {{ $labels.sender_id }} has 3x normal traffic"
actions:
  - notify: operations-team@company.com
```

---

## 📋 Compliance Requirements

### GDPR (General Data Protection Regulation)

```
✅ Right to Access: Audit logs enable "show me my data" requests
✅ Right to Erasure: Pseudonymization of sender_id after data retention
✅ Data Breach Notification: Security violation logs trigger alerts within 72h
✅ Audit Trail: Immutable logs for DPA inspections
```

**GDPR-Specific Fields:**
```json
{
  "compliance": {
    "gdpr_applicable": true,
    "data_subject": "customer-12345",
    "processing_purpose": "order_management",
    "legal_basis": "contract"
  }
}
```

---

### SOX (Sarbanes-Oxley Act)

```
✅ Segregation of Duties: Audit logs show who accessed financial data
✅ Change Management: All API routing changes logged with approver
✅ Access Controls: Per-sender authorization enforced and logged
✅ Retention: 7-year retention for financial transaction logs
```

---

### HIPAA (Health Insurance Portability and Accountability Act)

```
✅ Access Logging: Every access to PHI (Protected Health Information) logged
✅ Minimum Necessary: Audit logs show only authorized senders accessed data
✅ Breach Notification: Security violations trigger investigation workflow
✅ Audit Controls: Read-only access to audit logs for compliance officers
```

---

## ✅ Best Practices

1. **Log everything** - every request, regardless of success/failure
2. **Immutable logs** - use append-only storage (e.g., S3 with versioning)
3. **Structured logging** - JSON format for easy parsing
4. **Correlation IDs** - trace requests across systems
5. **Sensitive data redaction** - mask Authorization headers, passwords
6. **Real-time alerting** - security violations trigger immediate notifications
7. **Regular audits** - quarterly reviews of audit logs for anomalies
8. **Access control** - audit logs readable only by compliance team

---

**See also:**
- [Security Model](../security/README.md)
- [Access Control](../security/ACCESS-CONTROL.md)
