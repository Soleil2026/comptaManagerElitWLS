# Skill Mapping — Sub-Agents

##Vue d'ensemble
1,424 skills répartis entre 3 sub-agents selon leur domaine de responsabilité.

---

## GSD — Get Shit Done

**Rôle:** Pilote d'exécution, organisation des tâches, planification

### Catégories
| Pattern | Description |
|---------|-------------|
| `task-*` | Gestion de tâches |
| `planning-*` | Planification projet |
| `project-*` | Management projet |
| `productivity-*` | Productivité |
| `workflow-*` | Flux de travail |
| `organization-*` | Organisation |
| `agile-*` | Méthodologies agiles |
| `roadmap-*` | Feuille de route |

### Skills clés (extraits)
- `task-breakdown`
- `project-planning`
- `productivity-optimization`
- `workflow-automation`
- `agile-sprint`
- `roadmap-creation`

---

## OpenSpec — Architecte des Contrats

**Rôle:** Architecture, schémas, validation des interfaces

### Catégories
| Pattern | Description |
|---------|-------------|
| `architecture-*` | Architecture système |
| `database-*` | Base de données |
| `api-*` | Design d'API |
| `schema-*` | Schémas de données |
| `specification-*` | Spécifications |
| `code-review-*` | Revue de code |
| `design-*` | Design système |
| `modeling-*` | Modélisation |

### Skills clés (extraits)
- `architecture-design`
- `database-schema`
- `api-design`
- `schema-validation`
- `code-review-guidelines`
- `system-modeling`

---

## Superpowers — Exécuteur de Précision

**Rôle:** Implémentation, tests, actions système

### Catégories
| Pattern | Description |
|---------|-------------|
| `implementation-*` | Implémentation |
| `testing-*` | Tests |
| `refactoring-*` | Refactoring |
| `devops-*` | DevOps |
| `debugging-*` | Débogage |
| `deployment-*` | Déploiement |
| `ci-cd-*` | Intégration continue |
| `security-*` | Sécurité |

### Skills clés (extraits)
- `implementation-guide`
- `testing-strategy`
- `refactoring-patterns`
- `devops-automation`
- `debugging-techniques`
- `deployment-pipeline`

---

## Shared — Transversaux

Skills utilisés par plusieurs sub-agents.

| Pattern | Description |
|---------|-------------|
| `agent-*` | Gestion des agents |
| `context-*` | Gestion du contexte |
| `prompt-*` | Optimisation des prompts |
| `llm-*` | Modèles de langage |
| `ai-*` | Intelligence artificielle |

---

## Utilisation

```bash
# GSD - Planification
opencode run @task-breakdown "Créer MVP"

# OpenSpec - Architecture
opencode run @architecture-design "Hub Documentaire"

# Superpowers - Implémentation
opencode run @implementation "module: Hub Documentaire"
```

---

## Mapping Automatique

| Sub-Agent | Préfixes | Count (~) |
|-----------|----------|-----------|
| GSD | task, planning, project, productivity, workflow, agile, roadmap, organization | ~150 |
| OpenSpec | architecture, database, api, schema, specification, code-review, design, modeling | ~120 |
| Superpowers | implementation, testing, refactoring, devops, debugging, deployment, ci-cd, security | ~200 |
| Shared | agent, context, prompt, llm, ai, general | ~100 |
| Others | Other patterns | ~850 |

---

*Generated from Antigravity Awesome Skills v10.8.0*