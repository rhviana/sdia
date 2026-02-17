***

### 9) `04-security/faq-09-credentials-sprawl.md`

```markdown
# FAQ-09 – Credential Sprawl and GDCR

## Q1 – How does GDCR reduce credential sprawl?

By consolidating proxies and packages:

- you no longer need one technical user per tiny proxy per endpoint,
- you can manage credentials at the level of:
  - backend system,
  - trust boundary,
  - or domain package. [file:3]

Sandbox/trial results:

- technical users reduced from 39 to 12 (≈69%). [file:3]

---

## Q2 – Is it safe to reuse credentials across multiple operations?

Yes, when:

- they target the same backend system and trust boundary,
- operations are part of the same integration contract,
- you maintain proper least‑privilege scopes/roles on the backend.

GDCR doesn’t force “one user for everything”; it removes **unnecessary duplication** created by system‑driven, per‑proxy credentialing.

---

## Q3 – How are credentials stored and used?

Typical pattern:

- Credentials stored securely in:
  - APIM secure stores or KVM with encryption,
  - CPI credential stores. [file:3]
- Each KVM routing entry references:
  - the target CPI endpoint,
  - and optionally the credential alias or profile to use.

This keeps credentials and routing configuration **decoupled from façade URLs**.
