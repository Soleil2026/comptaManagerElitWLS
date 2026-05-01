---
created: 2026-05-01
updated: 2026-05-01
version: 1.1 (lint correction)
tags: [source, specification]
source_url: raw/assets/CDC.md
source_date: 2026-05-01
---

# [[CDC]]

**Source:** raw/assets/CDC.md
**Date:** 2026-05-01
**Type:** Cahier des charges fonctionnel
**Statut:** Finalisé

## Summary
Cahier des charges définissant les besoins fonctionnels, les objectifs produit, les utilisateurs visés, les modules métiers et les critères d'acceptation de comptaManagerDZ. Application Desktop de gestion documentaire, réglementaire, fiscale, juridique et décisionnelle pour cabinets d'expertise comptable en Algérie.

## Key Takeaways
1. **11 Modules fonctionnels:** Hub Documentaire, Veille Réglementaire, Fiscalité, Commissariat aux Comptes, Recours Fiscaux C4, Performance/KPI, Études Commerciales, Bibliothèque Templates, Gestion Honoraires, Gestion Cabinet, Administration/Sécurité
2. **6 Types utilisateurs:** Expert-comptable, Commissaire aux comptes, Collaborateur, Fiscaliste/Juriste, Responsable cabinet, Administrateur, Client
3. **Positionnement:** Système de pilotage métier — ne remplace pas la saisie comptable primaire
4. **Contraintes:** Réglementaires (conservation, archivage), Sécurité (journalisation, droits), Techniques (Desktop Windows 10/11), Gouvernance (documentation, contrats)
5. **Priorisation:** MVP (4 modules) → V1 (3 modules) → V2 (enrichissements)

## Périmètre par Phase

### MVP (Phase 1 — Mois 1-6)
| Module | Priorité |
|--------|----------|
| Hub Documentaire | P0 |
| Administration & Sécurité | P0 |
| Gestion du Cabinet | P0 |
| Veille Réglementaire | P1 (basique) |

### V1 (Phase 2 — Mois 7-12)
| Module | Priorité |
|--------|----------|
| Fiscalité et Déclarations | P1 |
| Commissariat aux Comptes | P2 |
| Performance/KPI | P2 |

### V2 (Phase 3 — Mois 13-24)
| Module | Priorité |
|--------|----------|
| Recours Fiscaux C4 | P2 |
| Études Commerciales | P3 |
| Bibliothèque Templates | P3 |

6. **Objets de base:** Client, Exercice, Document, Mission, Déclaration, Recours, KPI, Template, Utilisateur, Rôle
## Modules détail

| Module | But |
|--------|-----|
| Hub Documentaire | Centraliser tous documents, recherche, archivage |
| Veille Réglementaire | Surveiller, archiver textes juridiques et réglementaires |
| Fiscalité | Préparer, suivre déclarations (G50, TVA, IBS, TAP) |
| Commissariat aux Comptes | Missions d'audit, feuilles de travail, anomalies |
| Recours Fiscaux C4 | Dossiers de contentieux, réponses C4, suivi procédures |
| Performance/KPI | Tableaux de bord, simulations, indicateurs |
| Études Commerciales | Devis, calculs honoraires, études techniques |
| Bibliothèque Templates | Modèles documents, courriers, rapports |
| Gestion Honoraires/Salaires | Calcul, suivi, facturation |
| Gestion Cabinet | Planning, affectation missions, répertoire clients |
| Administration | Journal audit, gestion accès, traçabilité |

## Exclusions (hors périmètre)
- Tenue comptable primaire
- Production d'écritures comptables
- Services de paie complets
- Services bancaires
- CRM générique non lié au métier

## Connections
- [[BLAST]] - charte de gouvernance (complémentaire)
- [[BLAST Framework]] - cycle de vie applicable

## Notes
Document référence: CDC-Final / comptaManagerDZ