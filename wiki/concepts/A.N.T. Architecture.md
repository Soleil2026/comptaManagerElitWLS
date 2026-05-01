---
created: 2026-05-01
updated: 2026-05-01
tags: [concept, architecture, framework]
---

# [[A.N.T. Architecture]]

**Domain:** Architecture logicielle
**Related:** [[BLAST Framework]], [[System Pilot]]

## Définition

A.N.T. (Architecture, Navigation, Tools) est le framework d'architecture du projet comptaManagerDZ. Il définit l'organisation en trois couches distinctes qui structurent l'ensemble du système.

## Les 3 Couches

### 1. Architecture
**Emplacement:** `/architecture`

Contient les spécifications, les SOPs, les contrats et les décisions structurantes. Cette couche définit le comportement attendu, les responsabilités et les limites fonctionnelles.

### 2. Navigation
Cette couche orchestre les flux et les décisions de routage. Elle ne doit pas contenir de logique métier lourde. Elle sert de point de contrôle pour la circulation des données et l'activation des règles.

### 3. Tools
**Emplacement:** `/tools`

Contient les scripts Python atomiques, déterministes et testables. Chaque outil doit respecter une responsabilité unique, être traçable et pouvoir être testé indépendamment.

## Principes clés

- Séparation stricte des préoccupations
- La couche Navigation ne contient pas de logique métier
- Outils Python avec responsabilité unique
- Testabilité indépendante de chaque composant

## Sources

- [[BLAST]] (source: raw/assets/BLAST.md, section 9)