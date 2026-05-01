---
created: 2026-05-01
updated: 2026-05-01
tags: [concept, governance, context-engineering]
---

# [[Context Engineering Governance]]

**Domain:** Gouvernance projet / Méthodologie
**Related:** [[Context Engineering]], [[Opencode]], [[BLAST Framework]]

## Vision

Ce projet adopte le Context Engineering comme philosophie fondatrice. Chaque décision, document et tâche doit être alignée avec les principes d'optimisation du contexte.

---

## Les 6 Piliers de Gouvernance

### 1. Finite Attention Budget
**Principe:** Chaque interaction avec l'agent consume des tokens. Chaque token a un coût.

**Application:**
- Documents minimalistes mais complets
- Frontmatter essential only
- Summaires au lieu de transcriptions intégrales
- Index pour découverte just-in-time

**Vérification:** Avant chaque action, demander "est-ce que j'utilise le minimum de tokens nécessaire?"

### 2. Minimal High-Signal Set
**Principe:** Trouver le plus petit ensemble de tokens haute valeur qui maximise le résultat souhaité.

**Application:**
- Wiki pages avec informations critiques uniquement
- Citations directes au lieu deParafrase lengthy
- Links explicites au lieu de contexte implicite
- Decisions documentées, pas les discussions

**Vérification:** Cette information est-elle critique pour la prochaine action?

### 3. Just-in-Time Retrieval
**Principe:** Charger les donnees dynamiquement au runtime, pas tout pre-charger.

**Application:**
- Index.md comme point d'entree, pas chargement systematique
- Liens `[[page]]` pour acces direct
- Pas de pre-loading de tous les fichiers
- Exploration agentique selon besoin

**Vérification:** Ai-je besoin de cette information maintenant ou puis-je la charger plus tard?

### 4. Compaction
**Principe:** Resumer les conversations et documents longs pour liberer du contexte.

**Application:**
- log.md comme memoire externe
- Summaries dans index au lieu de contenu integral
- Taches terminees Archivees, pas conservees dans contexte
- Nettoyage regulier des donnees obsoletes

**Vérification:** Cette information peut-elle etre compactee ou externalisee?

### 5. Structured Note-Taking
**Principe:** Ecrire des notes hors contexte pour persistance et recuperation laterale.

**Application:**
- log.md comme journal chronologique
- Fichiers de task separes du contexte principal
- Archivage des decisions dans fichiers dedies
- Memoire externe pour informations non-critiques

**Vérification:** Cette information doit-elle etre dans le contexte ou peut-elle etre externalisee?

### 6. Sub-Agent Architecture
**Principe:** Separation des responsabilites avec agents specialises a contextes isoles.

**Application:**
- Wiki structuree en sous-dossiers (entities, concepts, sources, queries, synthesis)
- Chaque type de page a un role defini
- Opencode orchestre, les sous-agents executent des taches specifiques
- Separation claire entre gouvernance (BLAST) et execution

**Vérification:** Cette tache peut-elle être delegatee a un sous-agent specialise?

---

## Application aux Artefacts du Projet

| Artefact | Role | Context Engineering |
|----------|------|---------------------|
| `CLAUD.md` | System prompt | Haute priorit, toujours en contexte |
| `index.md` | Catalogue | Just-in-time discovery |
| `log.md` | Memoire externe | Structured note-taking |
| `wiki/sources/` | Summaries | Minimal high-signal |
| `wiki/concepts/` | Definitions | Compact, linked |
| `wiki/entities/` | Profiles | Donnees cles uniquement |
| `wiki/synthesis/` | Syntheses | Resumes de haut niveau |

---

## Regles de Gouvernance

### Pour les Documents
1. **Jamais** de contenu redondant entre documents
2. **Toujours** des liens explicites vers sources
3. **Minimum** de frontmatter requis (created, updated, tags)
4. **Compaction** des documents de plus de 100 lignes

### Pour les Taches
1. **Externaliser** les notes dans log.md
2. **Resolver** avant de passer a la suivante
3. **Documenter** les decisions, pas les discussions
4. **Archiver** les taches terminees

### Pour les Interactions
1. **Lire index** avant tout
2. **Charger** seulement les fichiers necessaires
3. **Synthetiser** au lieu de copier-coller
4. **Logger** chaque action importante

---

## Sources

- [[Effective Context Engineering for AI Agents]] (Anthropic)
- [[Context Engineering]] (Concept)
- [[BLAST]] (Charte de gouvernance)