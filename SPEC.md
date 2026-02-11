# Fathom Format Specification v0.1

## Overview

Fathom (`.fathom`) is a plaintext document format for layered, interactive content. Documents are human-readable and editable in any text editor. A separate rendering engine parses `.fathom` files and produces interactive output (typically a web page).

The core principle: all content exists at one of several depth layers. Readers choose their depth, and the document adapts — expanding or collapsing content inline without losing narrative flow.

## File Extension

`.fathom`

## Document Structure

A `.fathom` file has three sections:

1. **Front matter** (required) — YAML-style metadata between `---` delimiters
2. **Body** (required) — prose content with inline layer markup
3. **References block** (optional) — citations and sources at the end of the file

```
---
(front matter)
---

(body content with layer markup)

---references---
(citations and sources)
```

---

## 1. Front Matter

YAML-style key-value pairs between `---` delimiters. Whitespace and ordering are flexible.

### Required Fields

| Field          | Description                                      | Example                        |
|----------------|--------------------------------------------------|--------------------------------|
| `title`        | Document title                                   | `Service Incident Report`      |
| `version`      | Document version                                 | `1.0`                          |
| `engine`       | Minimum Fathom engine version required            | `0.1`                          |
| `layers`       | Layer definitions as `N:Label` comma-separated   | `1:What, 2:Why, 3:How`        |
| `default_layer`| Layer number to display on initial load           | `1`                            |

### Optional Fields

| Field    | Description           | Example                       |
|----------|-----------------------|-------------------------------|
| `author` | Author or organization| `Acme Corp Communications`    |
| `date`   | Publication date      | `2026-01-15`                  |
| `theme`  | Renderer theme name   | `clean`, `editorial`, `mono`  |

### Example

```
---
title: Service Incident Report - January 2026
version: 1.0
engine: 0.1
layers: 1:What, 2:Why, 3:How
default_layer: 1
author: Arcline Infrastructure Team
date: 2026-01-28
---
```

### Layer Definitions

Layers are numbered starting at 1. Labels are display names shown in the renderer UI. The numbering defines the depth hierarchy: layer 1 is the shallowest (simplest), and higher numbers are progressively deeper (more detailed/technical).

Layers are dynamic — a document can define 2, 3, or more layers with any labels. The three-layer What/Why/How model is the default convention but is not enforced by the format.

---

## 2. Body — Layer Markup Syntax

The body is flowing prose. Layer markup uses two constructs: **inline replacements** and **block insertions**.

### 2a. Inline Replacement

Syntax: `[visible text]{N:replacement text}`

- `[visible text]` — displayed at layers below N. This is the "trigger" the reader sees and can click.
- `{N:replacement text}` — displayed at layer N and above, replacing the visible text entirely.
- The replacement text should be wordsmithed so the sentence reads naturally at the expanded layer.
- The square bracket text acts as the clickable element, styled with a color corresponding to layer N.

**Example:**

```
Your account was not [compromised]{2:compromised — the failure occurred in our rendering pipeline, not in any authentication or data storage systems}.
```

At layer 1, the reader sees:
> Your account was not **compromised**.

("compromised" is highlighted as clickable, colored for layer 2)

At layer 2, the reader sees:
> Your account was not compromised — the failure occurred in our rendering pipeline, not in any authentication or data storage systems.

### 2b. Nested Replacement

Replacements can nest. A layer 2 replacement can contain a layer 3 replacement inside it. Nesting must always go deeper — a layer 2 block cannot contain another layer 2 block.

**Example:**

```
The system [failed]{2:experienced a [cascading failure]{3:cascading failure triggered by a race condition in the CDN cache invalidation process, causing stale TLS certificates to be served to approximately 12% of edge nodes}}.
```

Three views:
- Layer 1: "The system **failed**."
- Layer 2: "The system experienced a **cascading failure**."
- Layer 3: "The system experienced a cascading failure triggered by a race condition in the CDN cache invalidation process, causing stale TLS certificates to be served to approximately 12% of edge nodes."

### 2c. Block Insertion

Syntax: `{+N:inserted content}`

- Adds new content that does not exist at lower layers. There is no trigger word — instead, the renderer displays a visual indicator (a thin colored line or caret icon between paragraphs) to signal that additional content is available.
- Block insertions appear on their own line in the source file, after the sentence or paragraph they follow.
- At layer N and above, the content appears inline as if it were always part of the document.
- The visual indicator (caret/line) uses the color of layer N.

**Example:**

```
The system is back online and your data is safe.
{+2:Our engineering team identified the root cause within 14 minutes of the initial alert. Service was fully restored across all regions by 3:42 PM EST.}
```

At layer 1, the reader sees:
> The system is back online and your data is safe.
> *(thin colored line/caret indicating more content available)*

At layer 2:
> The system is back online and your data is safe.
>
> Our engineering team identified the root cause within 14 minutes of the initial alert. Service was fully restored across all regions by 3:42 PM EST.

### 2d. Block Insertions with Nested Replacements

Block insertions can contain inline replacements inside them.

```
{+2:The root cause was a [configuration error]{3:configuration error in the Kubernetes pod autoscaler — specifically, a mismatched resource quota on the `api-gateway` namespace caused health check failures to cascade across availability zones}.}
```

### 2e. Paragraphs and Whitespace

- Blank lines separate paragraphs (same as Markdown).
- Block insertions (`{+N:...}`) should be placed on their own line(s) between paragraphs.
- Standard Markdown-style formatting (bold, italic, headers) is supported within prose for basic text styling. The renderer should handle: `# Heading`, `## Subheading`, `**bold**`, `*italic*`.

---

## 3. References Block

An optional references section at the end of the file, delimited by `---references---`.

### Syntax

```
---references---
[^ID](N): Citation text. URL
```

- `[^ID]` — reference identifier (used inline in the body)
- `(N)` — minimum layer at which this reference is visible
- Citation text and optional URL follow the colon

### Inline Usage

Place `[^ID]` in the body text where the citation should appear. The renderer displays it as a footnote marker, but only at the specified layer or above.

### Example

Body:
```
The failure did not affect user data[^1].
```

References block:
```
---references---
[^1](3): Independent security audit conducted by CrowdStrike, January 2026. https://example.com/report
[^2](2): Arcline internal post-mortem summary, Engineering Team.
[^3](3): NIST SP 800-53 Rev. 5, Security and Privacy Controls. https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final
```

At layer 1: no footnote marker visible.
At layer 2: `[^2]` markers visible.
At layer 3: all footnote markers visible.

---

## 4. Rendering Behavior

This section describes expected renderer behavior. Renderers may implement additional features.

### Layer Display

- The document opens at the `default_layer` specified in front matter.
- Content at or below the current layer is displayed. Content above the current layer is hidden or collapsed.
- Inline replacement trigger text is styled with a color and/or underline corresponding to the next available layer. Clicking expands that replacement inline.
- Block insertion indicators (caret/line) are styled with the color of their layer.

### Global Layer Toggle

The renderer should provide a UI control to set the current viewing layer globally. Options:
- Layer selector (buttons or dropdown) to jump to a specific layer
- "Expand all to layer N" toggle
- The global toggle expands/collapses all content on the page to the selected depth

### Expansion Behavior

- **Inline replacements**: clicking the trigger text expands it, replacing the trigger with the deeper content. The expanded content may have a subtle background highlight to indicate its layer.
- **Block insertions**: clicking the caret/indicator reveals the inserted block. The block may have a subtle left border or background to indicate its layer.
- **Collapsing**: clicking expanded content (or using the global toggle) collapses it back to the trigger text or hides the insertion.

### Visual Design Guidelines

- Each layer should have a distinct color: e.g., Layer 1 = default/no highlight, Layer 2 = blue, Layer 3 = purple.
- Trigger text is styled like a link (underline + color) but distinct from actual hyperlinks.
- Expanded content uses a subtle background tint matching its layer color.
- Block insertion indicators are minimal — a thin horizontal line with a small downward caret, colored to match the layer.
- References/footnotes appear as superscript numbers, only visible at their specified layer.

---

## 5. Media

The `.fathom` format supports embedded media. Media elements are layer-aware — they appear only at the specified layer and above.

### 5a. Images

Syntax: `![alt text](path){layer:N}`

- `alt text` — accessible description of the image
- `path` — relative file path or URL to the image
- `{layer:N}` — minimum layer at which the image is visible. Omit for layer 1 (always visible).

**Examples:**

```
![Diagram of spacetime curvature](images/spacetime-curvature.png)
![Technical schematic of the retinal implant](images/implant-diagram.png){layer:2}
![OCT scan showing fluid resolution at week 12](images/oct-week12.png){layer:3}
```

- Images without a `{layer:N}` tag are visible at all layers (default: layer 1).
- Images inside block insertions (`{+N:...}`) inherit the block's layer visibility.
- The renderer should display images inline with surrounding prose, scaled to fit the content width.

### 5b. Figures with Captions

Syntax: `![alt text](path){layer:N, caption:"Caption text"}`

- The `caption` field is optional. When present, the renderer displays it below the image.
- Captions support inline replacement syntax for layered caption text.

**Example:**

```
![Einstein's 1919 eclipse photo](images/eclipse-1919.jpg){layer:1, caption:"The 1919 solar eclipse expedition confirmed that starlight bends around massive objects."}
```

### 5c. Future Media (Planned)

- Charts/embeds: syntax TBD
- Video: syntax TBD

---

## 6. Formal Grammar (Simplified)

```
document        := front_matter body references?
front_matter    := "---\n" yaml_content "---\n"
body            := (paragraph | block_insertion | heading | image | blank_line)*
paragraph       := (plain_text | inline_replacement | ref_marker | inline_image)+
inline_replacement := "[" trigger_text "]" "{" layer_num ":" content "}"
block_insertion := "{+" layer_num ":" content "}"
content         := (plain_text | inline_replacement | ref_marker | inline_image)+
ref_marker      := "[^" identifier "]"
image           := "![" alt_text "](" path ")" image_attrs?
inline_image    := "![" alt_text "](" path ")" image_attrs?
image_attrs     := "{" image_attr ("," image_attr)* "}"
image_attr      := "layer:" layer_num | "caption:\"" caption_text "\""
heading         := "#"+ " " text
references      := "---references---\n" ref_definition+
ref_definition  := "[^" identifier "](" layer_num "): " citation_text
trigger_text    := plain_text (no nesting)
layer_num       := integer >= 1
```

---

## 7. Design Principles

1. **Plaintext first.** A `.fathom` file should be readable and editable in Notepad. The markup should be lightweight enough that the prose flows naturally even with layer annotations.

2. **Layers always go deeper.** Nesting is strictly hierarchical. You can nest layer 3 inside layer 2, but never the same level inside itself.

3. **Natural language at every level.** Replacement text must be wordsmithed so sentences read naturally at each layer. This is not a tooltip or sidebar — it's the same document at a different depth.

4. **Format and renderer are decoupled.** The `.fathom` file is the source of truth. Any renderer that implements this spec can display it. The format does not depend on any specific rendering technology.

5. **Progressive disclosure, not information hiding.** Every layer is accessible to every reader. The format empowers readers to self-select their depth, not gatekeep information.
