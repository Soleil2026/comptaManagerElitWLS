# BLAST Phase Bundles — Skill Selection

Ce document définit les bundles de skills recommandés pour chaque phase du cycle BLAST.

---

## Phase B — Blueprint (Planification)

**Objectif:** Définir le scope, les exigences, la roadmap

### Sub-Agent Principal
**GSD** (Get Shit Done)

### Skills Recommandés

| Category | Skills | Description |
|----------|--------|-------------|
| **Planning** | `requirement-gathering`, `feature-specification`, `project-scope` | Définition des besoins |
| **Productivity** | `task-breakdown`, `prioritization-framework`, `work-breakdown` | Décomposition des tâches |
| **Project** | `project-planning`, `roadmap-creation`, `milestone-setting` | Planification projet |
| **Analysis** | `market-analysis`, `competitive-analysis`, `feasibility-study` | Analyse de faisabilité |

### Commande
```bash
opencode run @requirement-gathering
opencode run @project-planning
```

---

## Phase L — Link (Connexion)

**Objectif:** Connecter les composants, définir les intégrations

### Sub-Agent Principal
**OpenSpec** (Architecte des Contrats)

### Skills Recommandés

| Category | Skills | Description |
|----------|--------|-------------|
| **Architecture** | `system-architecture`, `integration-architecture`, `data-flow-design` | Architecture système |
| **Database** | `database-schema`, `data-modeling`, `er-diagram` | Design base de données |
| **API** | `api-design`, `rest-api-spec`, `graphql-schema` | Design API |
| **Integration** | `api-integration`, `service-connection`, `webhook-setup` | Intégrations |

### Commande
```bash
opencode run @system-architecture
opencode run @database-schema
opencode run @api-design
```

---

## Phase A — Architect (Architecture)

**Objectif:** Concevoir les détails techniques, valider les contrats

### Sub-Agent Principal
**OpenSpec**

### Skills Recommandés

| Category | Skills | Description |
|----------|--------|-------------|
| **Design** | `module-design`, `component-architecture`, `interface-definition` | Design modules |
| **Spec** | `technical-spec`, `contract-design`, `invariant-definition` | Spécifications |
| **Validation** | `schema-validation`, `type-checking`, `constraint-validation` | Validation contrats |
| **Code Review** | `code-review-guide`, `architecture-review`, `design-patterns` | Revues architecture |

### Commande
```bash
opencode run @module-design
opencode run @technical-spec
opencode run @schema-validation
```

---

## Phase S — Stylize (Interface)

**Objectif:** Implémenter l'interface utilisateur, le styling

### Sub-Agent Principal
**Superpowers** (Exécuteur de Précision)

### Skills Recommandés

| Category | Skills | Description |
|----------|--------|-------------|
| **Frontend** | `frontend-implementation`, `responsive-design`, `ui-component` | Implémentation UI |
| **Styling** | `css-architecture`, `design-system`, `theme-creation` | Style et theming |
| **UX** | `ux-improvement`, `user-experience`, `accessibility` | Expérience utilisateur |
| **Testing** | `ui-testing`, `visual-regression`, `accessibility-testing` | Tests UI |

### Commande
```bash
opencode run @frontend-implementation
opencode run @responsive-design
opencode run @ui-testing
```

---

## Phase T — Trigger (Déploiement)

**Objectif:** Déployer, tester en production, livrer

### Sub-Agent Principal
**Superpowers**

### Skills Recommandés

| Category | Skills | Description |
|----------|--------|-------------|
| **DevOps** | `deployment-automation`, `infrastructure-code`, `container-setup` | Automatisation déploiement |
| **CI/CD** | `ci-pipeline`, `cd-pipeline`, `release-automation` | Pipelines CI/CD |
| **Testing** | `integration-testing`, `e2e-testing`, `performance-testing` | Tests d'intégration |
| **Monitoring** | `logging-setup`, `monitoring-dashboard`, `alert-configuration` | Monitoring |

### Commande
```bash
opencode run @deployment-automation
opencode run @ci-pipeline
opencode run @integration-testing
```

---

## Résumé des Bundles

| Phase | Sub-Agent | # Skills | Focus |
|-------|-----------|----------|-------|
| **Blueprint** | GSD | ~30 | Planification, exigences |
| **Link** | OpenSpec | ~25 | Architecture, intégrations |
| **Architect** | OpenSpec | ~20 | Design, validation |
| **Stylize** | Superpowers | ~25 | UI, UX, styling |
| **Trigger** | Superpowers | ~30 | Déploiement, tests |

---

## Utilisation

```bash
# Phase B - Blueprint
opencode run @project-planning
opencode run @requirement-gathering

# Phase L - Link
opencode run @database-schema
opencode run @api-design

# Phase A - Architect
opencode run @module-design
opencode run @schema-validation

# Phase S - Stylize
opencode run @frontend-implementation

# Phase T - Trigger
opencode run @deployment-automation
```

---

*Bundle basé sur Antigravity Awesome Skills v10.8.0*