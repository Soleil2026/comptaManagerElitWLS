---
created: 2026-05-02
updated: 2026-05-02
tags: [source, skills, methodology]
source_url: .agents/skills/
---

# [[Skill Management Guide]]

**Source:** Antigravity Awesome Skills (v10.8.0)
**Date:** 2026-05-02
**Type:** Guide méthodologique

## Summary
Guide pour gérer 1,424 skills avec les sub-agents du projet (GSD, OpenSpec, Superpowers).

## Key Takeaways
1. **Architecture 3-sub-agents:** GSD (exécution), OpenSpec (architecture), Superpowers (implémentation)
2. **Organisation recommandée:** Sous-dossiers par sub-agent + skill-mapping.yaml
3. **Bundles par phase BLAST:** Blueprint, Link, Architect, Stylize, Trigger

## Méthode Optimale

### Sous-dossiers
```
.agents/skills/
├── gsd/           ← GSD: Planification, Exécution
├── openspec/      ← OpenSpec: Schémas, Validation
├── superpowers/   ← Superpowers: Tests, Implémentation
└── shared/        ← Transversal (commun à tous)
```

### Skill Mapping
| Sub-Agent | Catégories |
|-----------|------------|
| GSD | task-*, planning-*, project-*, productivity-* |
| OpenSpec | architecture-*, database-*, api-*, schema-*, code-review-* |
| Superpowers | implementation-*, testing-*, refactoring-*, devops-* |

### Bundles par Phase
| Phase | Sub-Agent | Skills |
|-------|-----------|--------|
| Blueprint | GSD+OpenSpec | task-planning, requirement-gathering |
| Link | OpenSpec | database-schema, api-definition |
| Architect | OpenSpec | system-architecture, module-design |
| Stylize | Superpowers | frontend-implementation, testing |
| Trigger | Superpowers | deployment, release-automation |

## Connections
- [[GSD]] - Pilote d'exécution
- [[OpenSpec]] - Architecte des contrats
- [[Superpowers]] - Exécuteur de précision
- [[Task Plan]] - Plan de tâches

## Notes
Document généré depuis Antigravity Awesome Skills - 1,424 skills disponibles