---
name: agent-memory
description: "Use this skill when the user asks to save, remember, recall, or organize memories. Triggers on: 'remember this', 'save this', 'note this', 'what did we discuss about...', 'check your notes', 'clean up memories'. Also use proactively when discovering valuable findings worth preserving."
---

# Agent Memory

A persistent memory space for storing knowledge that survives across conversations.

**Location:** `AGENT-MEMORIES/`

## Proactive Usage

Save memories when you discover something worth preserving:
- Research findings that took effort to uncover
- Non-obvious patterns or gotchas in the codebase/vault
- Solutions to tricky problems
- Architectural decisions and their rationale
- User preferences and workflows discovered
- In-progress work that may be resumed later

Check memories when starting related work:
- Before investigating a problem area
- When working on a feature you've touched before
- When resuming work after a conversation break
- When the user asks about something you might have noted before

Organize memories when needed:
- Consolidate scattered memories on the same topic
- Remove outdated or superseded information
- Update status field when work completes, gets blocked, or is abandoned

## Folder Structure

Organize memories into category folders that make sense for the content.

Guidelines:
- Use kebab-case for folder and file names
- Consolidate or reorganize as the knowledge base evolves

```text
AGENT-MEMORIES/
├── vault-setup/
│   ├── plugin-configs.md
│   └── template-decisions.md
├── user-preferences/
│   ├── workflow-habits.md
│   └── naming-conventions.md
├── project-context/
│   ├── jarvis-architecture.md
│   └── startup-saas-notes.md
├── research/
│   ├── mcp-vs-skills-analysis.md
│   └── obsidian-plugins-tested.md
└── troubleshooting/
    └── kanban-drag-drop-fix.md
```

## Frontmatter

All memories must include frontmatter with a `summary` field. The summary should be concise enough to determine whether to read the full content.

**Required:**
```yaml
---
summary: "1-2 line description of what this memory contains"
created: YYYY-MM-DD
---
```

**Optional:**
```yaml
---
summary: "Worker thread memory leak during large file processing - cause and solution"
created: 2026-01-11
updated: 2026-01-15
status: in-progress  # in-progress | resolved | blocked | abandoned
tags: [performance, vault, memory]
related: [PROJECTS/Jarvis/README.md]
---
```

## Search Workflow

Use summary-first approach to efficiently find relevant memories:

```bash
# 1. List categories
ls AGENT-MEMORIES/

# 2. View all summaries
rg "^summary:" AGENT-MEMORIES/ -i

# 3. Search summaries for keyword
rg "^summary:.*keyword" AGENT-MEMORIES/ -i

# 4. Search by tag
rg "^tags:.*keyword" AGENT-MEMORIES/ -i

# 5. Full-text search (when summary search isn't enough)
rg "keyword" AGENT-MEMORIES/ -i

# 6. Read specific memory file if relevant
```

## Operations

### Save

1. Determine appropriate category for the content
2. Check if existing category fits, or create new one
3. Write file with required frontmatter

```bash
mkdir -p AGENT-MEMORIES/category-name/
# Create memory file with frontmatter
```

### Maintain

- **Update**: When information changes, update the content and add `updated` field
- **Delete**: Remove memories that are no longer relevant
- **Consolidate**: Merge related memories when they grow
- **Reorganize**: Move memories to better-fitting categories as the knowledge base evolves

## Guidelines

1. **Write self-contained notes**: Include full context so the reader needs no prior knowledge
2. **Keep summaries decisive**: Reading the summary should tell you if you need the details
3. **Stay current**: Update or delete outdated information
4. **Be practical**: Save what's actually useful, not everything
5. **Consider the human**: Fran can also read these memories - write clearly

## Content Reference

When writing detailed memories, consider including:
- **Context**: Goal, background, constraints
- **State**: What's done, in progress, or blocked
- **Details**: Key files, commands, decisions made
- **Next steps**: What to do next, open questions

Not all memories need all sections - use what's relevant.
