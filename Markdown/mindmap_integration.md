your goal is to build very large, automatically generated mind maps from Markdown, with reliable cross-links, backlinks, references, source provenance, and incremental updates, I would not make the mind map itself the primary data structure.

Instead, use a graph-first Markdown architecture:

                    ┌─────────────────────┐
                    │     Source Material │
                    │ PDFs / Web / Notes   │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │  Knowledge Extractor │
                    │   LLM + parsers      │
                    └──────────┬──────────┘
                               │
                               ▼
              ┌─────────────────────────────────┐
              │      Knowledge Graph Model      │
              │                                 │
              │ Nodes + Edges + References      │
              │ IDs + hierarchy + provenance    │
              └──────────────┬──────────────────┘
                             │
                ┌────────────┼─────────────┐
                ▼            ▼             ▼
          Markdown       Mind Map       Database
          notes          Mermaid        SQLite/Qdrant
                │            │             │
                └────────────┼─────────────┘
                             ▼
                         Obsidian

The important design decision is:

Markdown should be the human-readable representation of your knowledge graph, not the graph database itself.

That makes very large maps much easier to automate.

1. The fundamental architecture

I would divide the system into six layers:

Layer 1   Sources
             ↓
Layer 2   Concepts
             ↓
Layer 3   Relationships
             ↓
Layer 4   Markdown knowledge base
             ↓
Layer 5   Generated visualizations
             ↓
Layer 6   Navigation / backlinks / references

For example, suppose you're studying:

Corporate Finance

You might automatically discover:

Corporate Finance
│
├── Capital Budgeting
│   ├── NPV
│   ├── IRR
│   ├── Payback Period
│   └── WACC
│
├── Capital Structure
│   ├── Debt
│   ├── Equity
│   ├── Cost of Debt
│   └── Cost of Equity
│
└── Working Capital
    ├── Accounts Receivable
    ├── Inventory
    └── Accounts Payable

But don't store that entire structure in one giant Markdown file.

Instead:

Corporate Finance.md
Capital Budgeting.md
NPV.md
IRR.md
WACC.md
Capital Structure.md
Debt.md
Equity.md
...

and connect them.

2. Give every concept a permanent ID

This is extremely important for automation.

Don't use the Markdown filename as the unique identifier.

Instead:

---
id: concept-finance-npv
type: concept
title: Net Present Value
---

Another:

---
id: concept-finance-wacc
type: concept
title: Weighted Average Cost of Capital
---

Now you can rename:

Net Present Value.md

to:

NPV.md

without breaking your conceptual identity.

Your system internally knows:

concept-finance-npv

is still the same object.

3. Use Markdown + YAML frontmatter

I'd use a standard template like:

---
id: concept-finance-npv
type: concept
title: Net Present Value
status: active

parent:
  - concept-finance-capital-budgeting

children:
  - concept-finance-discount-rate
  - concept-finance-cash-flow

related:
  - concept-finance-irr
  - concept-finance-wacc

sources:
  - source-brealey-finance
  - source-cfa-curriculum

tags:
  - finance
  - valuation
  - capital-budgeting

created: 2026-09-23
updated: 2026-09-23
---

# Net Present Value

## Definition

Net Present Value measures the present value of expected
future cash flows minus the initial investment.

## Formula

$$
NPV = \sum_{t=0}^{n} \frac{CF_t}{(1+r)^t}
$$

## Parent

[[Capital Budgeting]]

## Children

- [[Discount Rate]]
- [[Cash Flow]]

## Related concepts

- [[Internal Rate of Return]]
- [[WACC]]

## References

- [[Brealey - Principles of Corporate Finance]]
- [[CFA Curriculum - Capital Budgeting]]

This gives you both:

machine-readable structure

and

human-readable knowledge.

4. Separate hierarchy from relationships

This is one of the most important design principles.

A mind map has a hierarchy:

Finance
└── Valuation
    └── NPV

But knowledge itself is not hierarchical.

NPV might also relate to:

NPV
 ├── WACC
 ├── IRR
 ├── Discount Rate
 ├── Free Cash Flow
 ├── Capital Budgeting
 └── DCF

Therefore distinguish:

Parent/child
parent:
  - concept-valuation

from:

Related
related:
  - concept-irr
  - concept-wacc

from:

References
sources:
  - source-cfa

This prevents your mind map from becoming a giant tangled tree.

5. Use different edge types

I'd actually formalize relationships.

For example:

relationships:

  - type: parent
    target: concept-capital-budgeting

  - type: prerequisite
    target: concept-time-value-money

  - type: related
    target: concept-irr

  - type: depends_on
    target: concept-wacc

  - type: contrasts_with
    target: concept-payback-period

  - type: example
    target: example-acme-project

  - type: source
    target: source-cfa

Now your knowledge graph isn't merely:

A → B

It knows:

A --prerequisite--> B

A --contrasts_with--> C

A --supported_by--> D

That becomes extremely powerful when generating maps automatically.

6. Use Obsidian Wikilinks as the navigation layer

If you're using Obsidian, use:

[[Net Present Value]]

instead of ordinary Markdown:

[Net Present Value](Net%20Present%20Value.md)

Wikilinks give you natural:

forward link
     ↓
[[NPV]]
     ↓
backlink

Obsidian can then show:

Linked mentions

and:

Backlinks

automatically.

This is one of the reasons I would make individual Markdown files the canonical knowledge representation.

7. Don't manually generate backlinks

This is another important optimization.

Suppose:

NPV.md

contains:

[[WACC]]

Don't modify WACC.md every time you add a reference to it.

Let the graph engine calculate:

WACC
← NPV
← DCF
← Capital Budgeting
← Project Valuation

This avoids massive amounts of unnecessary file rewriting.

8. Create a separate graph index

For automation, maintain a machine-readable index.

For example:

knowledge/
├── concepts/
├── sources/
├── examples/
├── indexes/
│   ├── nodes.yaml
│   ├── edges.yaml
│   └── sources.yaml

nodes.yaml:

- id: concept-npv
  title: Net Present Value
  file: concepts/finance/NPV.md

- id: concept-irr
  title: Internal Rate of Return
  file: concepts/finance/IRR.md

edges.yaml:

- source: concept-npv
  target: concept-capital-budgeting
  type: parent

- source: concept-npv
  target: concept-irr
  type: related

- source: concept-npv
  target: source-cfa
  type: source

Now your automation system doesn't need to parse every Markdown file every time.

9. Better yet: use SQLite as the graph's index

For a large knowledge base, I'd go one step further.

Use:

Markdown
    +
SQLite
    +
Vector database

rather than Markdown alone.

For example:

CREATE TABLE nodes (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    type TEXT,
    path TEXT,
    created TEXT,
    updated TEXT
);

Relationships:

CREATE TABLE edges (
    source_id TEXT,
    target_id TEXT,
    relationship TEXT,
    PRIMARY KEY (
        source_id,
        target_id,
        relationship
    )
);

Sources:

CREATE TABLE sources (
    id TEXT PRIMARY KEY,
    title TEXT,
    uri TEXT,
    author TEXT,
    publication_date TEXT
);

Citations:

CREATE TABLE citations (
    node_id TEXT,
    source_id TEXT,
    location TEXT,
    quote TEXT
);

Now you have:

Markdown = human interface
SQLite   = structural index
Qdrant   = semantic search
Obsidian = visualization/navigation

This is particularly compatible with the kind of Obsidian + SQLite + Qdrant knowledge architecture you've been working toward.

10. Build the mind map dynamically

Don't permanently store a huge mind-map diagram.

Instead, generate it from the graph.

For example:

ROOT
 ↓
Corporate Finance
 ↓
Capital Budgeting
 ↓
NPV

The generator can produce:

But there is a major problem with giant Mermaid mind maps:

One enormous diagram eventually becomes difficult to render and navigate.

So I would use hierarchical maps.

11. Use a "zoomable map" architecture

Instead of:

Finance
 ├── Accounting
 │   ├── ...
 │   └── ...
 ├── Economics
 │   ├── ...
 │   └── ...
 └── Investments
     ├── ...
     └── ...

Create:

Finance/
│
├── 00 - Finance.md
│
├── Accounting/
│   ├── Accounting.md
│   ├── Financial Statements.md
│   └── ...
│
├── Economics/
│   ├── Economics.md
│   └── ...
│
└── Investments/
    ├── Investments.md
    ├── Valuation.md
    └── ...

Each parent page becomes a map of its children.

For example:

Finance
   │
   ├── Accounting
   ├── Economics
   ├── Corporate Finance
   └── Investments

Click:

Corporate Finance

and you get another map:

Corporate Finance
   │
   ├── Capital Budgeting
   ├── Capital Structure
   ├── Working Capital
   └── Valuation

Then:

Capital Budgeting
   │
   ├── NPV
   ├── IRR
   ├── Payback
   └── WACC

This gives you effectively:

infinite zoom without creating one gigantic diagram.

12. Every node should have a standard "navigation footer"

For example:

---

## Navigation

**Parent**

[[Capital Budgeting]]

**Children**

- [[Discount Rate]]
- [[Cash Flow]]
- [[Terminal Value]]

**Related**

- [[IRR]]
- [[WACC]]

**Prerequisites**

- [[Time Value of Money]]

**Sources**

- [[CFA Curriculum]]
- [[Brealey - Corporate Finance]]

This makes every node independently useful.

13. Add provenance to every piece of knowledge

This becomes extremely important if an LLM is generating the knowledge map.

Don't let the AI say:

NPV is better than IRR.

without knowing where that came from.

Instead:

## Claim

NPV and IRR can produce conflicting project rankings
under certain cash-flow structures.

## References

- [[CFA Curriculum]]
  - Chapter: Capital Budgeting
  - Section: NPV vs IRR

Even better:

claims:

  - id: claim-npv-001
    source: source-cfa
    location: chapter-8-section-4
    confidence: high

Now your system can answer:

"Where did this concept come from?"

14. Give every source a permanent ID

Example:

---
id: source-cfa-curriculum-2026
type: source
title: CFA Program Curriculum
author: CFA Institute
year: 2026
url: ...
---

Then:

NPV
 ├── supported_by → CFA Curriculum
 ├── supported_by → Brealey
 └── discussed_in → Annual Report

You can therefore trace:

Mind-map node
      ↓
Concept
      ↓
Claim
      ↓
Citation
      ↓
Source
      ↓
Original document

That's knowledge provenance.

15. Automate with an ingestion pipeline

I'd design your automation like this:

                    ┌───────────────┐
                    │ PDF / Web /   │
                    │ Book / Notes  │
                    └───────┬───────┘
                            ↓
                    ┌───────────────┐
                    │ Text Extractor│
                    └───────┬───────┘
                            ↓
                    ┌───────────────┐
                    │ Chunker       │
                    └───────┬───────┘
                            ↓
                    ┌───────────────┐
                    │ LLM Extractor │
                    └───────┬───────┘
                            ↓
                 ┌──────────────────────┐
                 │ Concepts             │
                 │ Relationships        │
                 │ Claims               │
                 │ Citations            │
                 └──────────┬───────────┘
                            ↓
                     ┌──────────────┐
                     │ Graph Store  │
                     │ SQLite       │
                     └──────┬───────┘
                            ↓
                     ┌──────────────┐
                     │ Markdown     │
                     │ Generator    │
                     └──────┬───────┘
                            ↓
                     ┌──────────────┐
                     │ Obsidian     │
                     └──────────────┘
16. Make the LLM output structured JSON first

This is a major improvement over asking an LLM:

"Create a mind map about finance."

Instead ask it to produce a schema.

For example:

{
  "nodes": [
    {
      "id": "concept-npv",
      "title": "Net Present Value",
      "type": "concept"
    }
  ],
  "relationships": [
    {
      "source": "concept-npv",
      "target": "concept-capital-budgeting",
      "type": "child"
    }
  ],
  "claims": [
    {
      "id": "claim-npv-001",
      "node": "concept-npv",
      "text": "...",
      "sources": [
        "source-cfa"
      ]
    }
  ]
}

Then your program validates it.

Only after validation do you generate Markdown.

This prevents the LLM from accidentally destroying your knowledge structure.

17. Use deterministic IDs

Don't let the LLM invent random IDs.

For example:

concept:npv
concept:irr
concept:wacc
source:cfa:2026

Your program can normalize them:

concept-finance-npv
concept-finance-irr
concept-finance-wacc
source-cfa-2026

Then your automation becomes idempotent.

Meaning:

Run #1
     ↓
Create NPV

Run #2
     ↓
Recognize NPV already exists
     ↓
Update NPV

instead of:

NPV
NPV-2
NPV-3
NPV-final
NPV-final-2

😂

18. Add a reconciliation process

This is essential for a large automated map.

Every time you ingest new material:

NEW SOURCE
    ↓
Extract concepts
    ↓
Compare existing IDs
    ↓
 ┌──┴──────────┐
 │             │
Existing      New
 │             │
Update        Create
 │             │
 └──────┬──────┘
        ↓
Recalculate relationships
        ↓
Validate graph
        ↓
Generate Markdown
        ↓
Generate maps

The system should detect:

Duplicate concept
Broken link
Orphan node
Missing source
Circular hierarchy
Conflicting parent
Unknown reference
19. Add graph validation

Your automation should run checks such as:

Broken references
[[NPV]]

but:

NPV.md

doesn't exist.

→ ERROR

Orphan nodes
Concept XYZ

has:

parent = null
related = null
references = null

→ WARNING

Duplicate concepts
Net Present Value
NPV
Net Present Value Analysis

might actually represent one concept.

→ REVIEW

Circular parent relationship
A → B
B → C
C → A

→ ERROR

This is where SQLite/networkx-style graph validation becomes very useful.

20. Separate "map" from "knowledge"

This is perhaps the biggest conceptual recommendation I'd give you.

Don't make:

Mind Map = Knowledge Base

Instead:

Knowledge Graph
       │
       ├──────────→ Mind Map
       │
       ├──────────→ Outline
       │
       ├──────────→ Study Guide
       │
       ├──────────→ Flashcards
       │
       ├──────────→ Quiz
       │
       └──────────→ Search

The graph is the source of truth.

The mind map is merely one visualization.

This becomes extremely powerful for your learning system.

21. Your final architecture

Given the type of system you've been building, I'd recommend this:

                         KNOWLEDGE SOURCES
                               │
                ┌──────────────┼──────────────┐
                │              │              │
               PDF            Web           Notes
                │              │              │
                └──────────────┼──────────────┘
                               ↓
                       INGESTION PIPELINE
                               │
                               ↓
                         LLM EXTRACTION
                               │
             ┌─────────────────┼──────────────────┐
             │                 │                  │
          Concepts        Relationships        Claims
             │                 │                  │
             └─────────────────┼──────────────────┘
                               ↓
                         SQLite GRAPH
                               │
             ┌─────────────────┼───────────────────┐
             │                 │                   │
             ↓                 ↓                   ↓
         Markdown           Qdrant             Metadata
          Vault             vectors             indexes
             │
             ↓
          Obsidian
             │
      ┌──────┼────────┐
      ↓      ↓        ↓
    Maps   Backlinks  Search
      │
      ↓
   Human learning

And each Markdown node:

┌───────────────────────────────────┐
│ YAML METADATA                     │
├───────────────────────────────────┤
│ Concept                            │
│                                   │
│ Definition                         │
│ Explanation                        │
│ Examples                           │
│ Formulas                           │
│                                   │
│ Parent                             │
│ Children                           │
│ Related                            │
│ Prerequisites                      │
│                                   │
│ Claims                             │
│ References                         │
│                                   │
│ Navigation                         │
└───────────────────────────────────┘
The key principle

If you're going to build 10,000+ concepts, don't build:

10,000-node Mermaid diagram

Build:

10,000 Markdown nodes
       +
20,000–100,000 typed relationships
       +
source/citation graph
       +
SQLite index
       +
vector index
       ↓
generate whatever map you need

Then you can ask the system:

"Show me the entire Corporate Finance map."

or:

"Show me only the NPV neighborhood."

or:

"Show me the prerequisite chain for WACC."

or:

"Show me every concept supported by this CFA chapter."

or:

"Show me concepts related to NPV that I haven't mastered."

and generate a small, readable map on demand rather than trying to render the entire universe at once.

For your Hermes + Obsidian setup

I would make this a dedicated Hermes skill with roughly these components:

knowledge-map/
├── SKILL.md
├── schemas/
│   ├── node.schema.json
│   ├── edge.schema.json
│   └── source.schema.json
├── scripts/
│   ├── ingest.py
│   ├── reconcile.py
│   ├── validate.py
│   ├── generate_maps.py
│   └── backlinks.py
├── templates/
│   ├── concept.md
│   ├── source.md
│   └── map.md
└── database/
    └── knowledge.db

with the operating rule:

LLM proposes → schema validates → SQLite reconciles → Markdown is generated → Obsidian visualizes.

That architecture is much more robust than asking Hermes to directly generate and continually edit giant Markdown mind maps.