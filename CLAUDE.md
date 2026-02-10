# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Fathom is an open format and rendering engine for layered, interactive documents. A single `.fathom` file contains content at multiple depth levels (e.g., summary → context → technical detail) and a renderer presents it interactively, letting readers expand/collapse to their preferred depth.

**Current status:** Specification and sample document are complete. The renderer (HTML/CSS/JS) has not been built yet.

## Key Files

- `SPEC.md` — Fathom format specification v0.1 (the authoritative reference for `.fathom` syntax)
- `PRODUCT.md` — Product vision, design decisions, and roadmap
- `arcline-outage.fathom` — Sample document exercising all format features
- `renderer/` — Where the MVP renderer should be built (does not exist yet)

## Fathom Format Quick Reference

`.fathom` files have three sections: front matter (YAML between `---`), body (prose with layer markup), and optional references (`---references---`).

**Two core markup constructs:**
- Inline replacement: `[visible text]{N:replacement text}` — trigger text is replaced at layer N+
- Block insertion: `{+N:inserted content}` — new content appears at layer N+ with a visual indicator

**Nesting rules:** Replacements can nest but must always go deeper (layer 3 inside layer 2, never same-level). Trigger text itself cannot contain nested markup.

**References:** `[^ID]` inline, defined as `[^ID](N): Citation text. URL` in the references block, visible at layer N+.

## Renderer MVP Requirements

The renderer should be a standalone HTML/CSS/JS application (single HTML file is acceptable) that:
- Parses any `.fathom` file (loaded via URL or file upload)
- Opens at the `default_layer` from front matter
- Implements inline replacement (click trigger text to expand/collapse)
- Implements block insertion (colored line/caret indicator between paragraphs)
- Provides a global layer toggle UI
- Handles nested expansions
- Shows references/footnotes only at their specified layer
- Uses distinct colors per layer (e.g., Layer 1 = default, Layer 2 = blue, Layer 3 = purple)
- Styles trigger text like links (underline + color) but visually distinct from actual hyperlinks

## Architecture: Format and Renderer Are Decoupled

The `.fathom` file is the source of truth — plaintext, editable in any text editor. The renderer is a separate application that consumes `.fathom` files. This decoupling is a core design principle: any tool should be able to produce or consume `.fathom` files.

The rendering pipeline is: `.fathom` file → parser (extract front matter, body AST, references) → renderer (interactive HTML with layer toggle).

## Design Principles

1. **Plaintext first** — `.fathom` files must be human-readable without a renderer
2. **Layers always go deeper** — strict hierarchical nesting, never same-level inside same-level
3. **Natural language at every level** — replacement text must read naturally in context, not as tooltips
4. **Replacement, not tooltip** — expansions replace trigger text inline, becoming part of the paragraph
5. **Progressive disclosure, not information hiding** — all layers accessible to all readers
