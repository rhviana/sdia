***

### 8) `04-security/faq-08-oauth-vs-fastfail.md`

```markdown
# FAQ-08 – OAuth2 vs KVM Fast-Fail

## Q1 – Where does OAuth2 fit in GDCR?

OAuth2/OIDC is recommended for:

- public or user‑centric APIs,
- scenarios with delegated consent and short‑lived tokens.

In GDCR:

- OAuth is a **layer around** DCRP, not part of the core routing formula.
- The core routing only needs `domain/entity/action/variant`.

---

## Q2 – What is KVM fast-fail and why use it?

KVM fast‑fail:

- stores sender metadata and allowed operations in KVM,
- validates sender/token locally at the gateway,
- rejects unauthorized calls (401/403) before routing. [file:1][file:3]

Benefits for M2M:

- no external IdP round‑trip on every call,
- lower latency,
- fewer runtime dependencies.

---

## Q3 – Can OAuth2 scopes be mapped to domain/entity/action?

Yes.

- Scopes can be defined in terms of semantic operations:

```text
scope: sales.orders.c
scope: finance.invoices.a
Gateway checks:

token validity,

scope → allowed domain/entity/action.

Fast‑fail with KVM and OAuth2 scopes can coexist, depending on security requirements.
