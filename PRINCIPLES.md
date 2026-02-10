# Fathom — Design Principles

**One document. Every audience.**

*There is no limit to the depths of what you can discover.*

---

## The Five Principles

### 1. Depth, Not Dumbing Down

Every reader deserves access to the full picture. Fathom doesn't hide information — it lets readers choose their level. The simplest layer respects your time. The deepest layer respects your expertise. No one is locked out. No one is talked down to.

We reject the false choice between accessibility and rigor. A document that serves only experts is gatekeeping. A document that serves only the general public is patronizing. Fathom serves everyone — simultaneously, in the same file, without compromise.

### 2. One Document, One Truth

Multiple versions of the same content — the press release, the technical brief, the internal memo, the FAQ — create inconsistency, versioning nightmares, and eroded trust. When information lives in three places, the truth lives in none of them.

Fathom collapses every version into a single source of truth. One file. One URL. Every audience finds what they need in the same place. Updates propagate instantly because there is only one document to update.

### 3. Natural Language at Every Layer

Expansions aren't tooltips bolted onto sentences. They aren't parenthetical asides or collapsible sidebars. Every layer reads as fluent, complete prose — because when a reader expands a passage, the expanded text *replaces* the trigger and becomes part of the paragraph.

This forces a discipline that separates Fathom from every other approach to adaptive content: authors must write well at every depth. The result is a document that reads naturally whether you're at layer one or layer three.

### 4. Open Format, Open Ecosystem

The `.fathom` file is a plaintext standard. It can be opened in Notepad, edited by hand, version-controlled in Git, and rendered by any engine that implements the spec. Fathom the company builds the best tools around the format, but the format belongs to everyone.

This is a deliberate strategic choice. An open format drives adoption. Adoption drives ecosystem. Ecosystem drives platform value. We don't win by locking people in — we win by becoming the standard.

### 5. Trust Through Transparency

Expert review, audit trails, and source citations are built into the format — not bolted on as afterthoughts. Readers can see where information comes from. Organizations can prove what they published and who reviewed it. Regulators can verify compliance.

AI coordination doesn't replace human judgment — it makes human judgment scalable. The agents research, draft, and coordinate. The experts validate, correct, and sign off. The document carries the evidence of both.

---

## How These Principles Shape the Product

| Principle | Product Decision |
|-----------|-----------------|
| Depth, not dumbing down | Layers are accessible to all readers. No login, no paywall between layers. |
| One document, one truth | Single `.fathom` file replaces multiple document versions. |
| Natural language at every layer | Replacement syntax forces prose rewriting, not annotation. |
| Open format, open ecosystem | Plaintext spec, renderer-agnostic, Git-friendly. |
| Trust through transparency | Layer-aware citations, expert attribution, audit trail support. |

---

*These principles are not aspirational. They are constraints. Every feature, every design decision, every line of the spec must satisfy all five — or it doesn't ship.*
