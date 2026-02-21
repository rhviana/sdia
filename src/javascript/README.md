# DDCR Engine – Maverick Style Evolution (JavaScript PoC)

This folder contains the JavaScript policy Proof of Concept implementation of the **Domain-Centric Routing Pattern (DCRP)** for **SAP Integration Suite – API Management (APIM)**.[web:33][web:36]

O objetivo deste engine é demonstrar, em JavaScript puro, como aplicar roteamento totalmente orientado a domínio em cima de KVMs APIM, reduzindo proxies, padronizando governança e mantendo latência de gateway em nível de milissegundos.[web:33][web:42]

---
```text
Latência (ms)
50 |                    v5.0 ████████████████████████████████████████
40 |                         █
30 |              v7.1 ██████████████████████████████
25 |                         █
20 |                         █
15 |    v8.0/v14.2 ████████████████          v15.0/v15.1 ████████████████
10 |              █           █                         █
 5 |              █           █                         █
 2 |    v15.2 🔒 ██          █                         █
 0 +----+----+----+----+----+----+----+----+----+----+----+----+
     Q1   Q2   Q3   Q4   Jan  Fev  2025 2026
```

## Evolution Timeline

**Evolution path:**  
`v5.0 → v7.1 → v8.0 → v14.2 → v15.0 → v15.1 → v15.2`[web:33][web:42]

### v5.0 – POC (Proof of Concept)

- **Released:** Q1 2025  
- **Status:** Open‑source (GitHub + DOI)  
- **Features:**
  - Flexible delimiter detection (11 delimiters suportados)
  - Path matching com ordenação dinâmica
  - Parsing manual de KVM (`split + loop`)
  - Tratamento de erro básico (`try/catch`)
- **Performance aproximada:**
  - Latência: 30–50 ms
  - Memória: ~10 KB por request
  - Alocações: ~50 objetos/request
- **Uso recomendado:** POC acadêmico, cenários pequenos (< 100 rotas)  
- **Status:** POC validado, **não** recomendado para produção.[web:42]

---

### v7.1 – Baseline

- **Released:** Q2 2025  
- **Status:** Deprecated  
- **Principais mudanças:**
  - Delimitador fixo (`,`), padronizando governança
  - Chaves domain‑centric prefixadas com `dcrp`
  - 2 loops (match estendido + match compacto)
  - Uso de regex para operações de string
  - Arrays para armazenamento de matches
  - Sem caching (parse do KVM a cada request)
- **Performance:**
  - Latência: 20–30 ms (~40% melhor que v5.0)
- **Marco:** consolida o padrão **domain‑centric** como modelo principal.[web:33][web:42]

---

### v8.0 – Speed Boost

- **Released:** Q3 2025  
- **Status:** Deprecated  
- **Otimizações:**
  - Loop único com early exit (~40% de ganho)
  - `indexOf` + `substring` no lugar de regex (~30% de ganho)
  - Substituição de arrays por variáveis primitivas (~15% de ganho)
- **Performance:**
  - Latência: 8–15 ms (≈ 50% mais rápido que v7.1)
- **Limitações:** Ainda sem caching ou observabilidade avançada.[web:33]

---

### v14.2 – Enterprise Ready (Panzer Edition)

- **Released:** Q4 2025  
- **DOI:** `10.5281/zenodo.18582469`  
- **Status:** Stable (deprecated por versões posteriores)  
- **Novos recursos:**
  - Cache global (TTL 60s) → parse de KVM cai de 8–12 ms para 0–1 ms
  - Cache multi‑node seguro (hash de validação)
  - 7 fases de medição de tempo (observabilidade detalhada)
  - 241 variações de verbos (normalização universal de ações)
  - Hooks de debug comentados (zero overhead em produção)
- **Performance:**
  - Latência: 8–15 ms (similar ao v8.0, porém com observabilidade completa)
  - Taxa de acerto de cache: ~95%
  - 33.000+ chamadas validadas com ~99,9% de sucesso
- **Status:** Enterprise ready, multi‑nó e altamente observável.[web:33][web:42]

---

### v15.0 – Algorithmic Upgrade

- **Released:** January 2026  
- **Status:** Superseded  
- **Correções críticas:**
  - Ajuste de binary search (prefix match → comparação CI completa)
  - Remoção de duplicata para `"retrieve"` no action map
  - Correção do claim de “zero allocation” (remoção de `segments.push()`)
  - Hardening de `extractIdFast()` (match correto de `"id"`)
  - Remoção de shadowing de contexto (`var context = context`)
- **Novos recursos:**
  - Binary search para KVM → `O(log n)` em vez de `O(n)`
  - Zero allocation “real” (sem `toLowerCase()` e sem `split()` em hot path)
  - `Map` ES6 para ações, garantindo `O(1)` em normalização
  - KVM cache ordenado e normalizado (case‑insensitive)
- **Performance:**
  - Latência: 15–25 ms
  - Scan de KVM com 500 entradas: ~0,6 ms (antes ~12 ms em v14.2, ~20x melhor)
- **Foco:** escalabilidade em grandes KVMs com semântica de busca mais rigorosa.[web:33]

---

### v15.1 – Maverick Ghost Edition (Academic Gold)

- **Released:** February 2026  
- **DOI:** `10.5281/zenodo.18661136`  
- **Status:** Stable (Academic / DOI)  
- **Hardening completo:**
  - Lookup case‑insensitive de ações (`/Create`, `/DELETE`, etc.)
  - `extractIdFast()` semântico (busca antes do último `:` → seguro para produção)
  - Validação de path: hard‑fail quando há mais de 4 segmentos
- **Observabilidade:**
  - Tracking de 7 fases de latência (parse, lookup, validate, construct, cache, total)
  - Métricas de cache hit/miss
  - Perfil de performance por rota
- **Performance:**
  - Latência: 15–26 ms
  - ~39% de melhora vs v14.2
- **Arquitetura:**
  - Normalização de ações `O(1)` para 241 variações em 15 códigos centrais
  - Overhead de gateway < 2 ms no hot path
  - Cache multi‑nó com invalidação por TTL
  - Alinhamento com PDCP (naming de pacotes por domínio)
  - Detecção de conflitos (rotas sobrepostas, erro HTTP 409)
- **Security Shield Edition (v15.1):**
  - Bloqueio de padrões de path traversal, SQLi, XSS, command injection
  - Whitelist de domínios no primeiro segmento de URL
  - Validação de headers críticos
  - Detecção de scanners/bots via User‑Agent
  - Metadados ricos de ameaça para uso em `RaiseFault`.[web:33][web:36]

---

### v15.2 – Maverick Phantom Edition 🔒

> **Status:** Enterprise‑only, não público.  
> Esta pasta contém a implementação JavaScript da arquitetura Maverick Phantom como PoC técnico, com ênfase máxima em performance e em compatibilidade com SAP APIM.[web:33][web:36]

- **Released:** February 2026  
- **Arquitetura revolucionária:**
  - ZERO regex no hot path
  - ZERO arrays alocados em tempo de execução
  - ZERO objetos alocados em tempo de execução
  - Lookup de KVM em único passe, com early exit
  - Split de strings baseado em índice (~80% mais rápido que regex)
  - Extração inline de variáveis (sem overhead de chamadas de função)
  - Concatenação direta de strings para construção de URL
  - Suporte a sufixos regionais (`salesforceus`, `salesforceemea`, etc.)
  - Cache multi‑camada (L1, L2, L3) em topologia de produção
- **Métricas de performance:**
  - Latência de roteamento: 1,5–4 ms (avg ~2,5 ms)
  - P95: 8 ms
  - P99: 12 ms
  - Memória por request: < 1 KB
  - CPU: ~50k ciclos por operação de roteamento
  - Throughput: 100k+ req/min por instância
  - Taxa de acerto de cache: 90%+ (L1) em cenários distribuídos
- **Ganho vs versões anteriores:**
  - ~–75% vs v15.1 (15–26 ms → 1,5–4 ms)
  - ~–90% vs v14.2 (8–15 ms → 1,5–4 ms)
  - ~–95% vs v5.0 (30–50 ms → 1,5–4 ms)
- **Validação em produção/sandbox SAP BTP:**
  - 73.000+ mensagens roteadas
  - ~99,92% de sucesso
  - Latência fim a fim média ~68 ms (inclui CPI backend ~50–60 ms)
  - Overhead “puro” de roteamento: 1,5–4 ms em tenants reais.[web:33][web:42]

---

## Arquitetura em Alto Nível

- **DCRP (Domain‑Centric Routing Pattern):** engine de roteamento no APIM, baseado em metadados (KVM), que resolve `/domínio/entidade/ação/vendor` para endpoints do CPI, sem precisar alterar ou redeployar proxies para adicionar novas rotas.[web:33][web:36]
- **PDCP (Package Domain‑Centric Pattern):** organização de pacotes e iFlows no CPI por domínio, alinhados às chaves de roteamento do DCRP.[web:36][web:42]

A combinação DCRP + PDCP permite reduzir drasticamente o número de proxies e iFlows, tratar conflitos de rota como metadados e garantir governança declarativa em ambientes de grande escala.[web:33][web:42]

---

## Créditos

- **Autor:** Ricardo Luz Holanda Viana  
- **Ambiente alvo:** SAP BTP – Integration Suite (API Management + Cloud Integration)  
- **Status:** Sandbox validado, com evidências publicadas em blogs técnicos, GitHub e registros DOI.[web:33][web:36][web:42]
