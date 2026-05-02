# LLM Wiki Schema — Context Engineering Aligned

This file defines the conventions for maintaining your personal knowledge base, aligned with Context Engineering principles from Anthropic.

## Context Engineering Principles

This project applies Context Engineering philosophy to optimize the LLM's attention budget:

1. **Finite Attention Budget** — Treat context as a finite resource. Every token depletes the budget.
2. **Minimal High-Signal Set** — Find the smallest set of tokens that maximize desired outcome.
3. **Just-in-Time Retrieval** — Load data dynamically at runtime, not all upfront.
4. **Compaction** — Summarize long contexts to preserve critical information.
5. **Structured Note-Taking** — Write notes outside context for persistence.
6. **Sub-Agent Architecture** — Use specialized agents with clean context windows.

---

This schema follows these principles:
- Wiki pages use minimal frontmatter (high-signal only)
- Cross-references use `[[page name]]` syntax (lightweight identifiers)
- Index enables just-in-time page discovery
- Log serves as external memory (notes outside context)
- Lint prevents context pollution (contradictions, orphans, stale claims)

## Global Rules

- All paths are relative to vault root (`/mnt/d/OBSIDIAN/comptaManagerElitWLS`)
- The LLM **never** modifies raw sources
- The LLM **never** writes your journal entries - only summaries/reflections you choose to file
- All wiki pages have YAML frontmatter with `created`, `updated`, `tags`
- Cross-references use Obsidian `[[page name]]` syntax (lightweight identifiers)
- Answers to queries should be filed back to wiki when valuable
- **Context Engineering**: Optimize for minimal high-signal tokens in every interaction
- **Compaction**: Summarize before adding to context if approaching limits

## Folder Structure (Sub-Agent Architecture)

```
/mnt/d/OBSIDIAN/comptaManagerElitWLS/
├── CLAUD.md              # This schema (System Prompt)
├── index.md              # Content catalog (Just-in-time discovery)
├── log.md                # Chronological record (External memory)
├── .claude/              # Commands (Sub-agents specialized tasks)
│   ├── commands/
│   └── memory/           # Structured notes outside context
├── .agents/              # Skills pour sub-agents
│   └── skills/           # 1,424 Antigravity Awesome Skills
│       ├── gsd/          # GSD: planification, tasks
│       ├── openspec/     # OpenSpec: architecture, schemas
│       ├── superpowers/  # Superpowers: tests, implémentation
│       └── blast-bundles.md  # Bundles par phase BLAST
├── Clippings/            # Web clips (Obsidian Web Clipper)
├── raw/                  # Immutable source documents
│   └── assets/           # Downloaded images, articles
└── wiki/                 # LLM-managed content
    ├── entities/         # People, places, organizations
    ├── concepts/         # Topics, theories, ideas
    ├── sources/          # Source summaries & notes
    │   └── Skill Management Guide.md  # Guide skills
    ├── queries/          # Q&A, analyses, comparisons
    ├── synthesis/        # Thematic synthesis pages
    └── tasks/            # Task tracking (structured notes)
```

## Page Templates

### Entity Page (entities)
```markdown
---
created: 2026-05-01
updated: 2026-05-01
tags: [entity, person]
---

# [[Page Name]]

**Type:** Person/Organization/Place
**Domain:** [area]

## Profile
[briefdescription]

## Key Facts
- [fact 1]
- [fact 2]

## Connections
- [[related entity]] - [relationship]
- [[related concept]] - [relationship]

## Sources
- [[source name]] (date)
```

### Concept Page (concepts)
```markdown
---
created: 2026-05-01
updated: 2026-05-01
tags: [concept, topic]
---

# [[Concept Name]]

**Domain:** [field]
**Related:** [[concept1]], [[concept2]]

## Definition
[clear definition]

## Key Points
1. [point 1]
2. [point 2]

## Applications
- [application 1]
- [application 2]

## Connected Ideas
- [[related concept]] - [how connected]
```

### Source Summary (sources)
```markdown
---
created: 2026-05-01
updated: 2026-05-01
tags: [source, article]
source_url: [url]
source_date: [date]
---

# [[Source Title]]

**Author:** [author]
**Source:** [publication]
**Date:** [date]

## Summary
[2-3 sentence summary]

## Key Takeaways
1. [takeaway 1]
2. [takeaway 2]
3. [takeaway 3]

## Quotes
> "[notable quote]"

## Connections
- [[entity]] - mentioned in
- [[concept]] - relates to

## Notes
[additional observations]
```

## Ingest Workflow (Context Engineering Optimized)

1. **Read source** - Load the raw file (minimal tokens)
2. **Extract high-signal** - Focus on key takeaways, not full content
3. **Create summary** - Write compact summary to `wiki/sources/`
4. **Update index** - Add entry to `index.md` (for just-in-time discovery)
5. **Update cross-references** - Link to relevant entities/concepts
6. **Log action** - Append to `log.md` (external memory)

**Principle:** Create minimal high-signal summaries, not verbose transcripts.

## Query Workflow (Just-in-Time Retrieval)

1. **Read index** - Find relevant pages (lightweight discovery)
2. **Read pages** - Load only needed content (minimal context)
3. **Synthesize** - Generate answer with citations
4. **File if valuable** - Save to `wiki/queries/`
5. **Log action** - Append to `log.md` (persist outside context)

**Principle:** Load only what's needed, not everything available.

## Lint Workflow (Context Health Check)

Check for:
- Contradictions between pages (context pollution)
- Stale claims superseded by newer sources
- Orphan pages with no inbound links
- Missing cross-references
- Data gaps to fill

**Principle:** Prevent context rot by keeping wiki clean and connected.

Run lint monthly or when wiki reaches ~50 pages.

## Index Format

```markdown
# Index

## Sources (sources)
| Page | Summary | Date |
|------|---------|------|
| [[Source Name]] | 1-line summary | 2026-05-01 |
```

## Log Format

```markdown
# Log

## [2026-05-01] ingest | Source Title
- Ingested source from raw/assets/
- Created summary: [[Source Title]]
- Updated: [[Entity A]], [[Concept B]]

## [2026-05-01] query | Your Question
- Answered question about x
- Filed answer: [[Query: X]]
```

## Git Configuration

```bash
# Git configuration for this project
git config user.name "Soleil2026"
git config user.email "smcleading@gmail.com"
```

| Setting | Value |
|---------|-------|
| Repository | https://github.com/Soleil2026/comptaManagerElitWLS |
| GitHub Account | https://github.com/Soleil2026 |
| Username | Soleil2026 |
| Email | smcleading@gmail.com |

## Version Control Workflow

1. **Stage** — `git add .` after significant changes
2. **Commit** — Descriptive message (use log.md as reference)
3. **Push** — `git push origin main` to remote
4. **Pull** — `git pull` before new session

**Note:** CLAUD.md rules apply — never commit raw sources, only wiki content.