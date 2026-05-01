# Context Engineering Governance

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

---

### 2. Minimal High-Signal Set
**Principe:** Trouver le plus petit ensemble de tokens haute valeur qui maximise le résultat souhaité.

**Application:**
- Wiki pages avec informations critiques uniquement
- Citations directes au lieu de parafrase lengthy
- Liens explicites au lieu de contexte implicite
- Décisions documentées, pas les discussions

**Vérification:** Cette information est-elle critique pour la prochaine action?

---

### 3. Just-in-Time Retrieval
**Principe:** Charger les données dynamiquement au runtime, pas tout pré-charger.

**Application:**
- index.md comme point d'entrée, pas chargement systématique
- Liens [[page]] pour accès direct
- Pas de pre-loading de tous les fichiers
- Exploration agentique selon besoin

**Vérification:** Ai-je besoin de cette information maintenant ou puis-je la charger plus tard?

---

### 4. Compaction
**Principe:** Résumer les conversations et documents longs pour libérer du contexte.

**Application:**
- log.md comme mémoire externe
- Summaries dans index au lieu de contenu intégral
- Tâches terminées archivées, pas conservées dans contexte
- Nettoyage régulier des données obsolètes

**Vérification:** Cette information peut-elle être compactée ou externalisée?

---

### 5. Structured Note-Taking
**Principe:** Écrire des notes hors contexte pour persistance et récupération latérale.

**Application:**
- log.md comme journal chronologique
- Fichiers de task séparés du contexte principal
- Archivage des décisions dans fichiers dédiés
- Mémoire externe pour informations non-critiques

**Vérification:** Cette information doit-elle être dans le contexte ou peut-elle être externalisée?

---

### 6. Sub-Agent Architecture
**Principe:** Séparation des responsabilités avec agents spécialisés à contextes isolés.

**Application:**
- Wiki structurée en sous-dossiers (entities, concepts, sources, queries, synthesis)
- Chaque type de page a un rôle défini
- Opencode orchestre, les sous-agents exécutent des tâches spécifiques
- Séparation claire entre gouvernance (BLAST) et exécution

**Vérification:** Cette tâche peut-elle être déléguée à un sous-agent spécialisé?

---

## Application aux Artefacts du Projet

| Artefact | Rôle | Context Engineering |
|----------|------|---------------------|
| CLAUD.md | System prompt | Haute priorité, toujours en contexte |
| index.md | Catalogue | Just-in-time discovery |
| log.md | Mémoire externe | Structured note-taking |
| wiki/sources/ | Summaries | Minimal high-signal |
| wiki/concepts/ | Définitions | Compact, linked |
| wiki/entities/ | Profiles | Données clés uniquement |
| wiki/synthesis/ | Synthèses | Résumés de haut niveau |

---

## Règles de Gouvernance

### Pour les Documents
1. **Jamais** de contenu redondant entre documents
2. **Toujours** des liens explicites vers sources
3. **Minimum** de frontmatter requis (created, updated, tags)
4. **Compaction** des documents de plus de 100 lignes

### Pour les Tâches
1. **Externaliser** les notes dans log.md
2. **Résoudre** avant de passer à la suivante
3. **Documenter** les décisions, pas les discussions
4. **Archiver** les tâches terminées

### Pour les Interactions
1. **Lire index** avant tout
2. **Charger** seulement les fichiers nécessaires
3. **Synthétiser** au lieu de copier-coller
4. **Logger** chaque action importante

---

## Système Multi-Agents

| Agent | Rôle | Fonction |
|-------|------|----------|
| **Opencode** | Multi-Agent Orchestrator | Coordonne l'ensemble du système |
| **OpenSpec** | Sub-Agent Architecte | Définit schémas, valide interfaces |
| **GSD** | Sub-Agent Pilote | Organise tâches atomiques (Get Shit Done) |
| **Superpowers** | Sub-Agent Exécuteur | Transforme specs en outils testables |

---

## Sources

- Effective Context Engineering for AI Agents (Anthropic)
- Context Engineering (Concept)
- BLAST (Charte de gouvernance)