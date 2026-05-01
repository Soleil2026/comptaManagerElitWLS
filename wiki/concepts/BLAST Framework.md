---
created: 2026-05-01
updated: 2026-05-01
tags: [concept, framework, methodology]
---

# [[BLAST Framework]]

**Domain:** Méthodologie de développement logiciel
**Related:** [[A.N.T. Architecture]], [[System Pilot]], [[Opencode]]

## Définition

B.L.A.S.T. est le framework de cycle de vie (Lifecycle) du projet comptaManagerDZ. Il définit les cinq phases par lesquelles chaque fonctionnalité doit passer before being considered complete.

## Les 5 Phases

### B — Blueprint (Planification)
**Objectif:** Définir la vision, les besoins, la structure fonctionnelle et les contrats critiques.

**Livrables:**
- Objectif business central
- Contraintes de conformité algérienne
- Cas d'usage prioritaires
- Schémas de données
- Diagrammes métier
- Contrats d'entrée et de sortie

### L — Link (Connexion)
**Objectif:** Vérifier les liaisons techniques et l'intégrité de l'infrastructure.

**Livrables:**
- Validation de la connexion PostgreSQL
- Vérification de la configuration
- Test du canal Flutter ↔ Python
- Résultats des health checks

### A — Architect (Architecture)
**Objectif:** Formaliser l'architecture système selon le paradigme A.N.T.

**Livrables:**
- Spécifications d'architecture
- Découpage des modules
- SOPs par composant
- Modèle de navigation
- Règles de routage

### S — Stylize (Style/UX)
**Objectif:** Qualité de rendu, ergonomie et conformité de sortie.

**Livrables:**
- Rapports financiers exploitables (PDF/Excel)
- UX professionnelle pour les comptables
- Cohérence visuelle et fonctionnelle des écrans

### T — Trigger (Déploiement)
**Objectif:** Préparer et contrôler le déploiement opérationnel.

**Livrables:**
- Packaging desktop Windows 10/11
- Automatisations
- Sauvegardes planifiées
- Documentation finale à jour

## Principes directeurs

1. **Déterminisme** — Chaque action doit résulter d'une règle explicite
2. **Contrats avant code** — Aucune implémentation sans schéma validé
3. **Séparation des responsabilités** — Conception, pilotage, exécution isolés
4. **Traçabilité totale** — Tout doit être documenté
5. **Architecture d'abord** — Formaliser avant d'implémenter
6. **Qualité vérifiable** — Donnée persistée + action journalisée + résultat validé

## Sources

- [[BLAST]] (source: raw/assets/BLAST.md, 2026-05-01)