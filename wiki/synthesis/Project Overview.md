---
created: 2026-05-01
updated: 2026-05-01
tags: [synthesis, project, overview]
---

# [[Project Overview]] — comptaManagerDZ

**Projet:** comptaManagerDZ
**Version:** 1.0 (CDC) / 2.2 (BLAST)
**Nature:** Application Desktop de gestion pour cabinets comptables en Algérie

---

## Résumé du projet

comptaManagerDZ est une plateforme Desktop de gestion documentaire, juridique, réglementaire et décisionnelle destinée aux cabinets d'expertise comptable et de commissariat aux comptes en Algérie.

**Positionnement:** Système de pilotage métier — ne remplace pas la saisie comptable primaire mais valorise les documents produits par les outils existants.

---

## Architecture détaillée

### Stack technique
- **Frontend:** Flutter (Desktop)
- **Backend:** Python
- **Base de données:** PostgreSQL
- **Agent IA:** Opencode (Multi-Agent Orchestrator)

### Méthodologie
- **Lifecycle:** B.L.A.S.T. (Blueprint → Link → Architect → Stylize → Trigger)
- **Architecture:** A.N.T. (Architecture, Navigation, Tools)

---

## Les 11 Modules

### Module 1 — Hub Documentaire
Centraliser, classer, rechercher et archiver l'ensemble des documents du cabinet et de ses clients.

**Fonctionnalités:** Classement par client/exercice/type, statuts (à analyser, validé, signé, archivé), recherche multicritères, liaison documents/missions/dossiers, historique versions, archivage longue durée.

### Module 2 — Veille Réglementaire & JORADP
Surveiller, archiver et exploiter les textes réglementaires et juridiques applicables.

**Fonctionnalités:** Import/archivage textes officiels, classement par thème/date/type, rattachement texte à dossier, recherche par article/mot-clé, suivi mises à jour.

### Module 3 — Fiscalité et Déclarations
Préparer, suivre et contrôler les déclarations fiscales périodiques.

**Fonctionnalités:** Pré-remplissage (CSV/XLSX), suivi G50/TVA/IBS/TAP, calendrier fiscal, rappels/alertes, contrôle montants, historique déclarations.

### Module 4 — Commissariat aux Comptes
Organiser les missions d'audit légal et documenter les travaux du commissaire aux comptes.

**Fonctionnalités:** Gestion mandats, feuilles de travail, suivi anomalies, checklists contrôle, génération rapports types, archivage preuves.

### Module 5 — Recours Fiscaux C4
Structurer les dossiers de recours et de contentieux fiscal.

**Fonctionnalités:** Gestion réponses C4, dossier redressement, suivi montants/pénalités, historique procédure, modèles courriers, journal étapes contentieuses.

### Module 6 — Performance et KPI Décisionnels
Offrir une vision synthétique de la performance financière et opérationnelle.

**Fonctionnalités:** Tableaux de bord, KPI financiers, simulations scénarios.

### Module 7 — Études Techniques et Commerciales
Produire des études de faisabilité et des devis pour les clients.

**Fonctionnalités:** Calculs honoraires, études rentabilité, gestion devis.

### Module 8 — Bibliothèque de Templates
Centraliser les modèles de documents.

**Fonctionnalités:** Modèles courriers, rapports, documents-types.

### Module 9 — Gestion des Honoraires et Salaires
Suivre et calculer les honoraires et rémunérations.

**Fonctionnalités:** Calcul honoraires, suivi facturation, gestion paie légère.

### Module 10 — Gestion du Cabinet
Administrer les ressources internes du cabinet.

**Fonctionnalités:** Planning, affectation missions, répertoire clients, suivi responsabilités.

### Module 11 — Administration et Sécurité
Assurer la sécurité, la conformité technique et l'audit des opérations.

**Fonctionnalités:** Journal audit, gestion accès, suivi connexions, historique actions, paramétrage sécurité, exports contrôle.

---

## Utilisateurs

| Rôle | Description |
|------|-------------|
| Expert-comptable | Supervise, valide, contrôle conformité |
| Commissaire aux comptes | Pilote missions audit, suit anomalies |
| Collaborateur | Classe documents, prépare dossiers |
| Fiscaliste/Juriste | Déclarations, recours, textes juridiques |
| Responsable cabinet | Productivité, honoraires, performance |
| Administrateur | Comptes, rôles, sécurité, paramètres |
| Client | Dépose/consultation selon droits |

---

## Contraintes

### Réglementaires
Conservation des pièces, tenue informatisée, archivage probant, obligations fiscales, textes JORADP.

### Sécurité
Journalisation actions sensibles, protection accès, droits par rôle, intégrité données, audit opérations.

### Techniques
Application Desktop Windows 10/11, export/import données structurées, architecture modulaire.

### Gouvernance
Documentation, contrats de données, historique préservé, pas de sources concurrentes.

---

## Priorisation

| Phase | Modules |
|-------|---------|
| **MVP** | Hub Documentaire, Administration, Gestion Cabinet, Veille Réglementaire (basique), Déclarations (base) |
| **V1** | Commissariat aux Comptes, Recours Fiscaux C4, Performance/KPI, Bibliothèque Templates |
| **V2** | Études techniques/commerciales, Simulations avancées, Automatisations, UX enrichie |

---

## Entités clés

### Objets de données
`Client`, `Exercice`, `Document`, `Type de document`, `Texte réglementaire`, `Mission`, `Déclaration`, `Dossier fiscal`, `Recours`, `KPI`, `Template`, `Utilisateur`, `Rôle`, `Action d'audit`

### Agents du système
- **Opencode** — Multi-Agent Orchestrator
- **OpenSpec** — Architecte des contrats
- **GSD** — Pilote d'exécution
- **Superpowers** — Exécuteur de précision
- **System Pilot** — Moteur de pilotage

---

## Context Engineering Alignment

Ce projet adopte le Context Engineering comme philosophie fondatrice:

| Principe | Application |
|----------|--------------|
| Finite Attention Budget | Documents minimalistes, frontmatter essential |
| Minimal High-Signal | Summaries compacts, pas de transcriptions integrales |
| Just-in-Time Retrieval | Index pour discovery, liens `[[page]]` |
| Compaction | log.md comme memoire externe |
| Structured Note-Taking | Separation tasks/contexte |
| Sub-Agent Architecture | Wiki structure (entities, concepts, sources, etc.) |

---

## Sources

- [[CDC]] — Cahier des charges fonctionnel v1.0
- [[BLAST]] — Charte de gouvernance v2.2
- [[BLAST Framework]] — Méthodologie lifecycle
- [[A.N.T. Architecture]] — Architecture système
- [[Context Engineering]] — Optimisation contexte IA
- [[Context Engineering Governance]] — 6 piliers de gouvernance
- [[Task Plan]] — Plan de taches CE-aligned