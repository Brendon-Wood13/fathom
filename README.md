# Fathom

**Fathom any topic to the depth you need.**

Fathom is an open format for layered, interactive documents. A single `.fathom` file holds content at multiple depth levels — from a plain-language summary to full technical detail — and a reader lets you expand or collapse to whatever depth you want.

**[Live demo →](https://woodcloud.org/fathom/)**

## How it works

A `.fathom` file is plaintext, readable in any text editor. Content is written at numbered layers (1 = overview, 2 = context, 3 = technical detail). The renderer presents the document interactively: click underlined trigger text to expand inline, or use the layer toggle to set a global depth.

Two core constructs make this work:

- **Inline replacement** — `[visible text]{2:expanded replacement}` swaps in deeper detail when the reader goes to layer 2+
- **Block insertion** — `{+3:new paragraph}` adds entire paragraphs at layer 3+, marked with a colored sidebar

Everything nests naturally. Layers always go deeper, and the prose reads as complete sentences at every level.

## Writing a `.fathom` file

```
---
title: My Document
version: 1.0
engine: 0.1
layers: 1:Summary, 2:Detail, 3:Technical
default_layer: 1
---

# My Document

This is a [simple sentence]{2:simple sentence that expands with more
context when the reader moves to layer 2}.

{+3:This entire paragraph only appears at layer 3 and above.}
```

See [SPEC.md](SPEC.md) for the full format specification, including images, captions, references, and front matter options.

## Themes

Documents can specify a `theme` in front matter:

- **clean** (default) — minimal, modern, white background
- **editorial** — warm serif headers, cream background, magazine feel
- **mono** — dark background, monospace headers, developer aesthetic

## Examples

The live demo includes three sample documents:

- [**Arcline Service Incident Report**](https://woodcloud.org/fathom/reader.html?doc=docs/arcline-outage.fathom) — a fictional outage post-mortem at three levels: press release, engineering, and legal (editorial theme)
- [**The Theory of Relativity**](https://woodcloud.org/fathom/reader.html?doc=docs/theory-of-relativity.fathom) — Einstein's theory from accessible overview to full equations
- [**VeriGene-R Gene Therapy for Wet AMD**](https://woodcloud.org/fathom/reader.html?doc=docs/wet-amd-verigene.fathom) — a clinical product overview for patients, clinicians, and researchers

## Running locally

```bash
make dev
```

This builds the site into `dist/` and serves it at `http://localhost:8000`.

## Deploying

```bash
make deploy
```

Builds, syncs to S3, and invalidates CloudFront.

## Project structure

```
fathom/
├── renderer/index.html          # The Fathom reader (single-file HTML/CSS/JS)
├── site/index.html              # Landing page
├── fathom-templates/            # Example .fathom documents
├── images/                      # Images referenced by example documents
├── SPEC.md                      # Format specification v0.1
├── PRODUCT.md                   # Product vision and design decisions
└── Makefile                     # Build and deploy
```
