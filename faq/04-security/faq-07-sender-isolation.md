***

### 7) `04-security/faq-07-sender-isolation.md`

```markdown
# FAQ-07 – Sender Isolation and Domain Proxies

## Q1 – If 10 senders call `/sales/*`, how do we prevent cross-sender access?

GDCR separates:

- **semantic routing** – `domain/entity/action/variant`,
- **authorization** – sender × allowed operations matrix.

For each sender:

- KVM or policy store entry:

```yaml
senderA:
  tokenHash: "<sha256>"
  allowed:
    - sales/orders/c
    - sales/orders/r

senderB:
  tokenHash: "<sha256>"
  allowed:
    - sales/customers/r
At runtime:

Fast‑fail policy resolves the sender (by token hash, mTLS DN, or header).

Computes the requested semantic operation, e.g. sales/orders/c.

Checks if it is in the sender’s allowed list.

Rejects (401/403) if not allowed, before routing. [file:1][file:3]

Q2 – Does sharing one domain proxy break isolation?
No.

All senders hit the same façade (/sales/**), but:

each sender has its own credentials / tokens,

authorization rules are per sender.

The façade is shared; the allowed operations per sender are not.

Q3 – What about auditability?
Every call includes:

x-gdcr-sender-id

x-gdcr-domain

x-gdcr-entity

x-gdcr-action

x-gdcr-interface-id

x-gdcr-correlation-id [file:3]

You can audit:

which senders call which operations,

any attempt to access forbidden operations (blocked at fast‑fail step).
