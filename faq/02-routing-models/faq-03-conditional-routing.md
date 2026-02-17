# FAQ 03 — Conditional Routing (1:N)

## What It Solves
- Reduces proxy count
- Groups paths

## What It Does NOT Solve

Proxy
├── condition A -> target A
├── condition B -> target B
├── condition C -> target C


Issues:
- Routing logic embedded
- Change = redeploy
- No global semantic governance
- No late binding

This is **better engineering**, not **architectural transformation**.
