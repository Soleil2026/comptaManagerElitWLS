---
created: 2026-05-01
updated: 2026-05-01
tags: [concept, ai, methodology]
---

# [[Context Engineering]]

**Domain:** Ingénierie IA / Méthodologie agent
**Related:** [[CLAUD.md]], [[BLAST Framework]], [[Effective Context Engineering for AI Agents]]

## Définition

Le context engineering est l'art et la science de curer et optimiser les tokens (informations) passés au LLM pendant l'inférence. C'est l'évolution naturelle du prompt engineering pour les agents autonomes.

## Principes clés

1. **Budget d'attention fini** — Les LLMs ont une capacité d'attention limitée (comme la mémoire de travail humaine)
2. **Context rot** — La performance dégrade quand le contexte grandit
3. **Minimal set** — Trouver le plus petit ensemble de tokens haute valeur qui maximise le résultat

## Techniques pour tâches longues

### Compaction
Résumer la conversation, redémarrer avec le résumé. Préserve décisions architecturales, bugs non résolus, détails d'implémentation.

### Structured Note-taking (Mémoire agent)
Écrire des notes persistées hors contexte, les récupérer plus tard. Permet de suivre la progression sur des tâches complexes.

### Sub-agent Architectures
Agents spécialisés avec contextes isolés. L'agent principal coordonne, les sous-agents font le travail profond.

## Application au projet

Le projet utilise Opencode comme **Multi-Agent Orchestrator**. Les techniques de context engineering s'appliquent à:
- Optimisation des interactions avec l'agent
- Gestion du contexte pour les tâches longues
- Utilisation efficace de CLAUDE.md

## Sources

- [[Effective Context Engineering for AI Agents]] (Anthropic)
- [[BLAST]] — Charte utilisant Opencode comme orchestrateur