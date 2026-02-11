# Fathom Language Support

Syntax highlighting and language support for [Fathom](https://github.com/OWNER/fathom) — the open format for layered, interactive documents.

## Features

### Syntax Highlighting

- **Front matter** — YAML-style metadata block between `---` delimiters
- **Inline replacements** — `[trigger]{N:replacement}` with distinct trigger text and layer number coloring
- **Block insertions** — `{+N:content}` with structural keyword highlighting
- **Nested replacements** — full support for deeply nested layer constructs
- **References** — `[^ID]` markers in body text and `[^ID](N): citation` definitions
- **Images** — `![alt](path){layer:N, caption:"text"}` with attribute highlighting
- **Markdown basics** — headings, **bold**, *italic*, `code spans`
- **URLs** — automatic highlighting of `http://` and `https://` links

### Snippets

Type these prefixes and press Tab:

| Prefix | Expands to |
| --- | --- |
| `frontmatter` | Full front matter template with current date |
| `rep` | Inline replacement `[trigger]{N:replacement}` |
| `block` | Block insertion `{+N:content}` |
| `ref` | Reference marker `[^ID]` |
| `refdef` | Reference definition `[^ID](N): citation` |
| `img` | Layer-aware image with optional caption |
| `references` | References block delimiter |

### Language Configuration

- Bracket matching and auto-closing for `[]`, `{}`, `()`
- Smart surrounding pairs including `*` for italic and `**` for bold

## What is Fathom?

Fathom is an open format for layered, interactive documents. A single `.fathom` file contains content at multiple depth levels (e.g., summary → context → technical detail), and a renderer presents it interactively, letting readers expand and collapse to their preferred depth.

Learn more at the [Fathom repository](https://github.com/OWNER/fathom).

## Publishing Setup

Before publishing to the VS Code Marketplace:

1. Create a publisher account at https://marketplace.visualstudio.com/manage
2. Update the `publisher` field in `package.json` with your publisher ID
3. Update the `repository` URL in `package.json`
4. Add a 128x128 PNG icon as `icon.png` and uncomment the `icon` field in `package.json`
5. Install vsce: `npm install -g @vscode/vsce`
6. Package: `vsce package`
7. Publish: `vsce publish`

## Local Installation

To install locally without publishing:

```bash
cd vscode-extension
npx @vscode/vsce package
code --install-extension fathom-language-0.1.0.vsix
```

## License

MIT
