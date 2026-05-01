---
created: 2026-05-01
updated: 2026-05-01
tags: [source, specification, modules]
source_url: raw/assets/Modules.md
source_date: 2026-05-01
---

# [[Modules]]

**Source:** raw/assets/Modules.md
**Date:** 2026-05-01
**Type:** Référentiel fonctionnel des modules
**Statut:** Référentiel officiel
**Cadre de pilotage:** GSD (Get Shit Done)

## Summary
Document définissant les 11 modules fonctionnels du système avec règles communes, dépendances, statuts et contraintes. Complète le CDC en提供了 plus de détails techniques sur chaque module.

## Key Takeaways
1. **11 Modules** avec règles communes (but unique, besoin réel, testable, cohérence gemini.md)
2. **Entrées/Sorties** définies pour chaque module
3. **Statuts** standardisés (Brouillon, À analyser, Validé, Signé, Archivé, etc.)
4. **Dépendances** inter-modules documentées
5. **Contraintes** transverses: traçabilité, pas de duplication, cohérence

## Modules Detail

### Module 1 — Hub Documentaire
- **But:** Centraliser, classer, rechercher et archiver les documents
- **Utilisateurs:** Expert-comptable, Commissaire aux comptes, Collaborateur, Assistant, Client
- **Dépendances:** Client, Exercice, Utilisateur, Rôle, Action d'audit

### Module 2 — Veille Réglementaire & JORADP
- **But:** Centraliser textes réglementaires et les relier aux besoins métier
- **Utilisateurs:** Expert-comptable, Juriste, Fiscaliste, Commissaire aux comptes
- **Dépendances:** Document, Dossier fiscal, Recours, Mission

### Module 3 — Fiscalité et Déclarations
- **But:** Préparer, contrôler et suivre les déclarations fiscales
- **Utilisateurs:** Fiscaliste, Comptable, Responsable dossier, Expert-comptable
- **Dépendances:** Client, Exercice, Document, Texte réglementaire, KPI

### Module 4 — Commissariat aux Comptes
- **But:** Structurer les missions d'audit légal et suivi des contrôles
- **Utilisateurs:** Commissaire aux comptes, Chef de mission, Collaborateur audit
- **Dépendances:** Mission, Document, Anomalie, Action d'audit

### Module 5 — Recours Fiscaux C4
- **But:** Constituer et piloter les dossiers de réclamation et contentieux
- **Utilisateurs:** Fiscaliste, Juriste, Expert-comptable
- **Dépendances:** Texte réglementaire, Document, Client, Exercice

### Module 6 — Performance et KPI
- **But:** Fournir indicateurs financiers et opérationnels pour aide à la décision
- **Utilisateurs:** Expert-comptable, Dirigeant, Directeur financier

### Module 7 — Études Commerciales
- **But:** Produire études et devis pour les clients
- **Utilisateurs:** Responsable commercial, Consultant

### Module 8 — Bibliothèque Templates
- **But:** Centraliser les modèles de documents
- **Utilisateurs:** Tous

### Module 9 — Honoraires et Salaires
- **But:** Mesurer rentabilité des missions et coût humain
- **Utilisateurs:** Direction, RH, Gestionnaire, Responsable mission

### Module 10 — Gestion du Cabinet
- **But:** Organiser ressources humaines, missions et structure interne
- **Utilisateurs:** Administrateur, Responsable cabinet, Manager, Collaborateur

### Module 11 — Administration et Sécurité
- **But:** Assurer sécurité, conformité technique et audit des opérations
- **Utilisateurs:** Administrateur, Direction, Auditeur interne
- **Dépendances:** Tous les autres modules

## Règles Transverses
- Documenter entrées/sorties
- Respecter statuts définis
- Maintenir traçabilité
- Éviter duplication de logique
- Rester cohérent avec gemini.md
- Signaler dépendances critiques

## Connections
- [[CDC]] - Spécifications produit (complémentaire)
- [[Project Overview]] - Vue d'ensemble
- [[BLAST]] - Charte de gouvernance
- [[Product Requirements]] - Exigences commerciales
- [[BLAST Framework]] - Cycle de vie applicable
- [[Context Engineering Governance]] - Principes CE

## Gouvernance
- **Cadre de pilotage:** GSD (Get Shit Done) — Sub-agent selon BLAST section 5
- **Alignement CE:** Minimal high-signal, chaque module a but unique défini

## Notes
Document de référence fonctionnelle pour conception détaillée, priorisation développements, rédaction tâches, préparation tests.