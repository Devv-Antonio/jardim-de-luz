# Graph Report - jardim-de-luz  (2026-11-06)

## Corpus Check
- 28 files · ~25,588 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 13 file(s) not represented in the graph (top: (none) 4, .elm 4, .pl 3)

## Summary
- 420 nodes · 848 edges · 18 communities (16 shown, 2 thin omitted)
- Extraction: 94% EXTRACTED · 6% INFERRED · 0% AMBIGUOUS · INFERRED: 54 edges (avg confidence: 0.86)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `308e37d2`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- validar_entrega.py
- metricas.py
- ✦ Jardim de Luz
- rubrica.py
- agregar_360.py
- main.py
- package.json
- direct
- 1. Nota do grupo (G)
- auditar.py
- test_api.py
- with
- Avaliação 360 graus
- Os scripts
- run.cjs
- Apresentação — proposta de 14 minutos
- jardim-de-luz-backend

## God Nodes (most connected - your core abstractions)
1. `Document` - 34 edges
2. `normalize()` - 32 edges
3. `unfilled()` - 20 edges
4. `main()` - 18 edges
5. `aggregate()` - 15 edges
6. `load()` - 15 edges
7. `check_effort()` - 15 edges
8. `check_identification()` - 14 edges
9. `Jardim de Luz` - 14 edges
10. `run()` - 13 edges

## Surprising Connections (you probably didn't know these)
- `9. Limitações e problemas conhecidos` --references--> `Puzzle`  [INFERRED]
  RELATORIO.md → backend/app/main.py
- `5.3 Trecho em destaque` --references--> `Solution`  [INFERRED]
  RELATORIO.md → backend/app/main.py
- `title_of()` --uses--> `Document`  [INFERRED]
  scripts/agregar_360.py → scripts/validar_entrega.py
- `read_members()` --calls--> `normalize()`  [EXTRACTED]
  scripts/agregar_360.py → scripts/validar_entrega.py
- `read_members()` --calls--> `unfilled()`  [EXTRACTED]
  scripts/agregar_360.py → scripts/validar_entrega.py

## Import Cycles
- None detected.

## Communities (18 total, 2 thin omitted)

### Community 0 - "validar_entrega.py"
Cohesion: 0.09
Nodes (40): check_ai_field(), check_choice_field(), check_comments(), check_comments_per_colleague(), check_contributions(), check_effort(), check_evaluator(), check_field_present() (+32 more)

### Community 1 - "metricas.py"
Cohesion: 0.11
Nodes (24): checkout_declared(), declared_revision(), gh_classroom(), main(), repositories(), run(), write_lots(), commits() (+16 more)

### Community 2 - "✦ Jardim de Luz"
Cohesion: 0.05
Nodes (36): Checklist de entrega, Comandos finais, Estado atual, O que vocês precisam completar, Prazos e rubrica, 1. Experimente o domínio sem servidor, 2. Leia garden.pl nesta ordem, 3. Leia Garden.elm sem olhar a tela (+28 more)

### Community 3 - "rubrica.py"
Cohesion: 0.09
Nodes (20): status(), summarize(), ask_ai(), ask_comprehension(), ask_criterion(), ask_scope(), Criterion, decimal() (+12 more)

### Community 4 - "agregar_360.py"
Cohesion: 0.13
Nodes (19): aggregate(), find_files(), fmt(), grade_for(), grade_value(), individual_grade(), main(), match_member() (+11 more)

### Community 5 - "main.py"
Cohesion: 0.06
Nodes (35): generate(), GenerateRequest, Hint, hint(), PlayRequest, Puzzle, Request, Solution (+27 more)

### Community 6 - "package.json"
Cohesion: 0.10
Nodes (22): devDependencies, elm@0.19.2-0, elm-format@^0.8.8, @fontsource-variable/fraunces@^5.3.0, @fontsource-variable/outfit@^5.3.0, vite@^8.3.3, name, private (+14 more)

### Community 7 - "direct"
Cohesion: 0.10
Nodes (19): dependencies, direct, indirect, elm/browser, elm/core, elm/html, elm/http, elm/json (+11 more)

### Community 8 - "1. Nota do grupo (G)"
Cohesion: 0.18
Nodes (10): 1.1 Níveis de cada critério, 1.2 Métricas, 1.3 Faltas que invalidam o trabalho, 1.4 Penalidades, 1.5 Escopo, originalidade e uso de IA, 1. Nota do grupo (G), 2.1 Verificação de compreensão, 2. Nota individual (I) (+2 more)

### Community 9 - "auditar.py"
Cohesion: 0.27
Nodes (10): Finding, is_comment(), main(), project_files(), repositories(), scan_manifests(), scan_repo(), scan_text() (+2 more)

### Community 10 - "test_api.py"
Cohesion: 0.21
Nodes (8): puzzle(), test_complete_hint(), test_forced_hint(), test_generate_unique(), test_impossible(), test_malformed(), test_possible_hint(), test_solve()

### Community 11 - "with"
Cohesion: 0.13
Nodes (14): jobs, verificar, name, on, name, run, uses, with (+6 more)

### Community 12 - "Avaliação 360 graus"
Cohesion: 0.15
Nodes (12): 1. Escala, 2. Notas, 3. Divisão do esforço, 4. Comentários sobre cada colega, 5. Autoavaliação, 6. Sobre o grupo (opcional), Avaliação 360 graus, [Colega 1] (+4 more)

### Community 13 - "Os scripts"
Cohesion: 0.18
Nodes (10): `agregar_360.py`, `auditar.py`, `baixar.py`, Ferramentas de correção, Fluxo de correção, `metricas.py`, Os scripts, Regras espelhadas em código (+2 more)

### Community 14 - "run.cjs"
Cohesion: 0.20
Nodes (6): app, assert, fs, sandbox, timer, vm

### Community 15 - "Apresentação — proposta de 14 minutos"
Cohesion: 0.33
Nodes (5): Apresentação — proposta de 14 minutos, Código para explicar, Limitações que precisam ser ditas, Preparação antes de começar, Sequência de demonstração

## Knowledge Gaps
- **1 isolated node(s):** `jardim-de-luz-backend`
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 190 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Jardim de Luz` connect `main.py` to `✦ Jardim de Luz`?**
  _High betweenness centrality (0.203) - this node is a cross-community bridge._
- **What connects `jardim-de-luz-backend` to the rest of the system?**
  _1 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `validar_entrega.py` be split into smaller, more focused modules?**
  _Cohesion score 0.09399585921325052 - nodes in this community are weakly interconnected._
- **Should `metricas.py` be split into smaller, more focused modules?**
  _Cohesion score 0.1072463768115942 - nodes in this community are weakly interconnected._
- **Should `✦ Jardim de Luz` be split into smaller, more focused modules?**
  _Cohesion score 0.046511627906976744 - nodes in this community are weakly interconnected._
- **Should `rubrica.py` be split into smaller, more focused modules?**
  _Cohesion score 0.09411764705882353 - nodes in this community are weakly interconnected._
- **Should `agregar_360.py` be split into smaller, more focused modules?**
  _Cohesion score 0.13012477718360071 - nodes in this community are weakly interconnected._