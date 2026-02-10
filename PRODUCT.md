# Fathom — Product Vision & Pitch Notes

## One-Liner

Fathom is the infrastructure for layered communication — AI agents that research, draft, and coordinate expert review to produce interactive documents where every reader finds their level of depth.

## The Problem

Every piece of communication forces a choice: write for the expert and lose the general audience, or write for the general audience and frustrate the expert. Organizations solve this by producing multiple versions of the same document (press release + technical brief + internal memo), which is expensive, inconsistent, and creates versioning nightmares.

The result: public-facing content is dumbed down and experts feel patronized, or technical content is impenetrable and the general public disengages. Neither audience is well-served.

## The Solution

Fathom documents contain all layers of depth in a single source file. A lightweight rendering engine presents the content interactively — readers click to expand inline for more depth, or use a global toggle to set their preferred level. The document reads naturally at every layer because each expansion is wordsmithed to flow as part of the prose.

### The Three-Layer Model (Default Convention)

| Layer | Name  | Purpose | Audience |
|-------|-------|---------|----------|
| 1     | What  | Simple, clear explanation of what is happening | General public, casual readers, time-pressed executives |
| 2     | Why   | Context and reasoning without condescension | Informed readers, stakeholders, journalists |
| 3     | How   | Full technical/academic/expert detail, no holds barred | Subject matter experts, auditors, researchers |

Layers are dynamic — documents can define 2, 3, or more layers with custom labels. The What/Why/How model is a convention, not a constraint.

### Interactive Mechanics

1. **Inline replacement**: a highlighted word or phrase is clickable. Clicking it expands the text inline, replacing the trigger with a deeper explanation that reads naturally in the sentence. The color of the highlight indicates the layer.

2. **Block insertion**: a thin colored line with a small caret appears between paragraphs, indicating additional content is available at a deeper layer. Clicking reveals the block as if it were always part of the document.

3. **Global toggle**: a page-level control lets readers expand or collapse all content to a specific layer at once.

4. **Nesting**: expansions can contain further expansions. A layer 2 block can contain layer 3 triggers inside it. Nesting is strictly deeper — never same-level inside same-level.

---

## The AI Agent Workflow (OpenClaw Integration)

The `.fathom` file format is designed to be the **output** of an AI-coordinated authoring pipeline. The full Fathom platform workflow:

### The Orchestrator Model

A single orchestrator agent manages the entire pipeline. It takes the initial input (topic + source documents + organizational guardrails), builds a research plan, and spins up specialized agents in parallel. It tracks progress, identifies gaps, and decides when each phase is complete enough to advance. Think of it as a project manager that never sleeps.

### Agent Types

**Research Agents** — spin up in parallel, each focused on a different facet of the topic. For example, in an incident communication scenario, one agent pulls technical logs and infrastructure details, another researches industry incident response standards (NIST, SOC 2), another scans for comparable incidents for context, and another checks regulatory requirements for customer notification. They report findings back to the orchestrator, which identifies knowledge gaps and can spin up additional targeted research agents.

**Outreach Agent** — identifies which experts need to be consulted based on the topic and knowledge gaps the research agents flagged. Drafts emails, schedules calls, and sends requests within organizational guardrails. When experts respond — via email reply, call transcript, or form submission — the outreach agent routes their input back to the orchestrator.

**Synthesis Agent** — once the orchestrator determines sufficient research and expert input have been gathered, the synthesis agent drafts all three layers simultaneously. It works from a unified knowledge base but writes each layer for its intended audience. This is the hardest agent to build well — it produces prose that reads naturally at every depth while ensuring factual consistency across layers. The goal is a single high-quality draft that humans only review and approve, though the system supports an iteration model (agent drafts → human edits → agent rewrites) as needed.

**Coherence Agent** — a dedicated quality check that reads across all three layers and flags: factual inconsistencies between depths (e.g., layer 1 says "no data affected" while layer 3 describes partial exposure), grammatical issues when expansions are inserted into parent layers, citation-claim mismatches, and violations of organizational style or compliance requirements.

### Outreach Guardrails

All agent outreach operates within organizational guardrails configured at setup:

- **Approved Contact Lists**: Domain-limited, whitelisted, or reference-validated contacts only. Integrated with O365 directories.
- **Attempt Limits**: First outreach is autonomous. Any further attempts require human review and approval.
- **Template Enforcement**: All outreach uses org-approved templates. Custom templates are allowed but must be pre-registered. No freeform AI-generated emails to external parties.
- **Blackout Windows**: Timezone-aware scheduling. Business hours only (9–5 local time). No weekends unless flagged urgent.

### Agent Isolation

Agents are external-facing only at launch. Source documents are provided via file upload; agents never access internal systems. Future state: integrations with Jira, Confluence, Azure DevOps, and SharePoint for direct data ingestion.

### Human Checkpoints

The system is not fully autonomous. Defined human intervention points:

1. **Subject Matter Experts** — review and approve the layer relevant to their domain
2. **Communications Lead** — signs off on the "What" layer for tone, accuracy, and brand alignment
3. **Final Reviewer** — approves the complete document across all layers before publication

The orchestrator tracks who reviewed what and when — this becomes the audit trail.

### Two Workflow Modes

- **Agent-Driven**: Upload source documents and let the agents run the full pipeline autonomously (within guardrails). Best for enterprise teams with established processes.
- **Collaborative**: Build the document interactively with AI via a chatbot interface. Best for individual authors, journalists, or teams exploring a topic.

---

## Key Design Decisions

### Format and Renderer Are Separate
The `.fathom` file is a plaintext source format, editable in any text editor. The renderer is a separate piece of software (web-based for MVP). This decoupling is intentional — it positions the format as an open standard that any tool can produce or consume.

### Plaintext Readability
The format uses minimal markup inspired by Markdown. An author should be able to open a `.fathom` file in Notepad and read the full content, understanding the layer structure without a renderer. This lowers the barrier to adoption and allows manual editing.

### Replacement, Not Tooltip
When a reader expands a layered term, the trigger text is **replaced** by the expanded content. This is not a tooltip or popover — the expansion becomes part of the paragraph. This forces authors to write content that reads naturally at every depth, which is the core quality differentiator.

### Block Insertions Use Visual Indicators (Option B)
For content that is purely additive (no trigger word to replace), the renderer shows a thin colored line with a caret icon between paragraphs. This was chosen over attaching to the preceding sentence (Option A) or making insertions toggle-only (Option C) because:
- It's visually distinct from inline replacements, signaling different behavior
- It works for all insertion lengths (sentence to multi-paragraph)
- It's visible enough to invite exploration without cluttering the base layer

### Authoring Direction Is Flexible
Documents can be authored top-down (start at "What," add depth) or bottom-up (start at "How," add simplifications). The format supports both workflows. The header's `default_layer` field controls which layer the reader sees first.

### Layers Are Dynamic
The What/Why/How model is a convention, not a format constraint. A medical document might use `1:Patient, 2:Clinician, 3:Researcher`. An educational document might use `1:Beginner, 2:Intermediate, 3:Advanced`. The format supports any number of layers with any labels.

---

## Beachhead Markets

### Tier 1 (Highest Value, Strongest Need)
- **Government & Policy Communication** — compliance-driven, multi-audience by nature, regulatory requirement to communicate clearly to the public while maintaining technical accuracy
- **Healthcare & Pharma** — patient-facing vs. clinician-facing vs. researcher-facing content; regulatory stakes (FDA, EMA); patient literacy is a known crisis
- **Financial Services** — disclosures, product explanations, investor communications; SEC plain-language requirements

### Tier 2 (Strong Fit)
- **Enterprise Incident Communication** — the MVP use case; post-mortems, outage reports, security disclosures that need to reach clients, executives, and engineers simultaneously
- **Education** — textbooks and course materials that adapt to student level; accessibility compliance
- **Legal** — contracts, terms of service, regulatory filings that need plain-language summaries alongside precise legal text

### Tier 3 (Broader Opportunity)
- **Journalism** — layered reporting where casual readers get the headline story and engaged readers get investigative depth
- **Research & Academia** — papers with accessible summaries that don't sacrifice technical rigor
- **Corporate Communications** — earnings reports, product launches, internal memos that cross organizational levels

---

## Additional Features (Post-MVP)

### Analytics on Layer Engagement
Track which layers readers expand, which terms they click, where they stop drilling. This produces actionable intelligence:
- Government: "80% of readers stay at layer 1, but 15% drill into eligibility criteria" → that section needs clearer base-layer writing
- Enterprise: "Engineers expand every layer 3 block in the security section" → they want even more technical detail

### Versioning and Audit Trails
Track who authored/reviewed each layer and when. Critical for regulated industries:
- "The 'How' layer was reviewed by Dr. Smith on 2026-01-20"
- "Changes to the 'What' layer were derived from validated source material in the 'How' layer"
- Full diff history of the `.fathom` source file

### Collaborative Authoring
Map organizational roles to layers:
- Communications team writes "What"
- Policy/product team writes "Why"
- Subject matter experts own "How"
- AI ensures consistency across layers

### Accessibility
Fathom is not just about expertise level — it serves:
- Cognitive accessibility (processing differences, attention constraints)
- Language barriers (simpler language is easier to translate)
- Time constraints (busy executive and concerned citizen both benefit from layer 1)
- Screen reader compatibility (the format's prose-first design is inherently accessible)

---

## Competitive Positioning

### What Fathom Is Not
- **Not a CMS** — Fathom is a file format and renderer. It produces documents, not websites.
- **Not a wiki** — content is authored and published, not crowd-edited (though collaborative authoring is possible).
- **Not a chatbot** — the output is a static, shareable document, not a conversational interface.
- **Not just AI-generated content** — the AI coordinates research and expert review; experts validate the output.

### The Moat
1. **The file format is the platform play.** An open standard that any tool can produce or consume creates ecosystem effects. If `.fathom` becomes the default for layered content, Fathom is the authoring and rendering infrastructure.
2. **AI coordination is the cost barrier.** Without AI agents, creating three coherent interlocking layers of the same content is prohibitively expensive. Fathom makes it feasible.
3. **Expert-in-the-loop is the trust barrier.** AI-only content isn't trusted in regulated industries. Fathom's coordination of expert review and audit trails makes layered content credible.

---

## MVP Scope

### What We're Building
1. **Fathom format spec v0.1** — the `.fathom` file format as documented in SPEC.md
2. **Sample document** — Arcline service outage crisis communication, exercising all format features
3. **Fathom renderer v0.1** — standalone HTML/CSS/JS that parses a `.fathom` file and renders it interactively

### What the MVP Demonstrates
- All three layers with natural prose at each depth
- Inline replacement (click a word to expand)
- Block insertion (caret indicator for additive content)
- Nested expansion (layer 3 inside layer 2)
- Global layer toggle
- Layer-aware citations/references
- Plaintext readability of the source file
- Complete decoupling of format and renderer

### What the MVP Does NOT Include
- AI authoring pipeline
- Expert review workflow
- Analytics
- Media/image support
- Collaborative editing
- Multiple output formats (PDF, etc.)