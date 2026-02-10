# Fathom

**Fathom any topic to the depth you need.**

Fathom is an open format and rendering engine for layered, interactive documents. Every piece of content exists at multiple depth levels — from simple summaries to expert-grade technical detail — and readers choose how deep they want to go.

## Project Structure

```
fathom/
├── README.md                  # This file
├── SPEC.md                    # Fathom format specification v0.1
├── PRODUCT.md                 # Product vision, pitch notes, and roadmap
├── samples/
│   └── arcline-outage.fathom  # Sample: tech company crisis communication
└── renderer/
    └── (MVP HTML/JS renderer goes here)
```

## MVP Goal

Build two separate pieces:

1. **The `.fathom` source file** — a plaintext document in the Fathom format describing a fictional tech company (Arcline) crisis communication after a major service outage. Should exercise all format features: inline replacements, block insertions, nested layers, citations, and metadata.

2. **The Fathom renderer** — a standalone HTML/CSS/JS application that parses any `.fathom` file and renders it as an interactive document with expandable layers, visual indicators, and a global layer toggle.

The format and renderer must be fully decoupled. The renderer takes a `.fathom` file as input and produces the interactive experience. The `.fathom` file is human-readable and editable in any text editor.

## Quick Start (for Claude Code)

1. Read `SPEC.md` to understand the Fathom file format
2. Read `PRODUCT.md` for product context and design decisions
3. Review `samples/arcline-outage.fathom` for a reference sample
4. Build the renderer in `renderer/` — single HTML file for MVP is fine
5. The renderer should be able to load the sample file and demonstrate all features
