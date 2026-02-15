# src – Core Runtime Components

This folder contains the **core runtime components** of the architecture.

Everything inside `src` is responsible for **executing the metadata-driven logic**, enabling:
- Domain-centric routing
- Fast-fail mechanisms
- Secure and deterministic endpoint resolution

This is the **heart of the architecture**.

---

## Structure

src/
├── javascript/
└── key-value-mapping/

---

## javascript/

This folder contains the **execution engine**.

### Responsibilities
- Read metadata provided by Key Value Mapping
- Apply routing logic based on:
  - Business Domain
  - Business Process
  - Operation context
- Execute decisions **at runtime**, without hardcoded endpoints

### Key Characteristics
- No static routing
- No environment-specific logic
- Fully metadata-driven
- Deterministic execution
- Designed for **fast-fail** behavior

If metadata is missing or inconsistent, execution **fails immediately**.

---

## key-value-mapping/

This folder contains the **architecture brain**.

### Responsibilities
- Store all routing metadata
- Define:
  - Domains
  - Business Processes
  - Target endpoints
  - Security and routing parameters
- Act as the **single source of truth**

### Key Characteristics
- Centralized governance
- Zero duplication
- No logic execution
- Pure configuration and semantics

---

## How It Works (High Level)

1. **Key Value Mapping**
   - Holds all domain and process semantics
   - Defines *what* should happen

2. **JavaScript**
   - Loads metadata at runtime
   - Executes *how* it should happen

3. **Execution Flow**
   - Metadata is resolved
   - Logic is applied
   - Target endpoint is generated dynamically
   - No endpoint is exposed or hardcoded

---

## Architecture Principles

- Metadata-driven architecture
- Domain-centric design
- Business-process awareness
- Fast-fail by design
- Maximum security through indirection
- Transparent destination resolution

---

## Security Model

- No direct endpoint exposure
- No static routing rules
- No environment leakage
- All destinations resolved dynamically via metadata
- Fail-fast if metadata is invalid or missing

---

## Important Notes

- Both folders are mandatory
- JavaScript without metadata has no meaning
- Metadata without execution logic is inert
- Together, they form a **deterministic, secure, and scalable architecture core**

---

**Scope:** Runtime Core  
**Audience:** Enterprise Integration Architects  
**Status:** Active
