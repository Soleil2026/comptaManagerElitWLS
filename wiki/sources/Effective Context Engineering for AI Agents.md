---
created: 2026-05-01
updated: 2026-05-01
tags: [source, ai, engineering]
source_url: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
source_date: 2026-05-01
---

# [[Effective Context Engineering for AI Agents]]

**Author:** Anthropic Applied AI team
**Source:** Anthropic Engineering Blog
**Date:** 2026-05-01

## Summary
Article explainant l'évolution du prompt engineering vers le context engineering pour les agents IA. Définit les stratégies de curation et d'optimisation des tokens dans la fenêtre de contexte limitée des LLMs.

## Key Takeaways
1. **Context engineering vs Prompt engineering** — Context engineering = stratégies pour curer et maintenir les tokens optimaux pendant l'inférence LLM (vs écrire des prompts)
2. **Context rot** — Dégradation progressive de la performance LLM avec l'augmentation du contexte (budget d'attention fini)
3. **Principe clé** — Trouver le plus petit ensemble de tokens haute valeur qui maximise le résultat souhaité
4. **Just-in-time retrieval** — Identifiants légers (paths, liens) + chargement dynamique à runtime vs pré-traitement
5. **3 Techniques pour tâches longues:**
   - **Compaction** — Résumer la conversation, redémarrer avec le résumé
   - **Structured note-taking** — Écrire des notes hors contexte, les récupérer plus tard
   - **Sub-agent architectures** — Agents spécialisés avec contextes isolés
6. **CLAUDE.md** — Exemple de fichier drops naively dans le contexte, avec outils glob/grep pour navigation just-in-time

## Quotes
> "Context, therefore, must be treated as a finite resource with diminishing marginal returns."

> "Find the smallest set of high-signal tokens that maximize the likelihood of your desired outcome."

## Connections
- [[CLAUD.md]] — Contexte schéma utilisé dans ce projet
- [[BLAST]] — Charte utilisant Opencode comme agent orchestrateur
- [[Context Engineering]] — Concept résumant les principes clés
- [[BLAST Framework]] — Phase Architect où l'architecture système est formalisée

## Notes
Article directement applicable au projet: utilise Opencode comme Multi-Agent Orchestrator, donc les techniques de context engineering sont pertinentes pour optimiser les interactions.