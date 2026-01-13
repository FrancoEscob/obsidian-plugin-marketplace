# Obsidian-Plugin Framework

A configurable Claude Code plugin framework that helps anyone create their own personalized Obsidian vault system.

## Overview

**Obsidian-Plugin** is a flexible framework that enables users to create and manage their own Obsidian vault with customized folder structures, workflows, and automation—without writing code. Based on the proven FrancoVault system, it provides:

- 🧙 **Interactive Setup Wizard** - Create your personalized vault in < 10 minutes
- ⚙️ **Configuration-Driven** - All commands adapt to your vault structure
- 📦 **Template Library** - Start with FrancoVault, Minimal, or build custom
- 🛠️ **8 Powerful Commands** - Automate your PKM workflows
- 🎯 **4 Universal Skills** - Obsidian syntax, Canvas, Bases, Agent Memory
- 🪝 **3 Smart Hooks** - Proactive assistance and automation

## Quick Start

### Installation

```bash
# From marketplace (when published)
claude /install FranEscob/obsidian-plugin

# From local directory
claude --plugin-dir ./FranEscob/plugins/obsidian-plugin
```

### Initial Setup

1. Navigate to your Obsidian vault directory
2. Run the setup wizard:
   ```bash
   /setup-vault
   ```
3. Follow the interactive prompts to create your personalized vault

## Features

### Commands

| Command | Description |
|---------|-------------|
| `/setup-vault` | Interactive wizard to create your personalized vault structure |
| `/daily-note` | Create today's daily note with your custom template |
| `/new-project` | Start a new project with structured README |
| `/process-inbox` | Organize and classify inbox notes automatically |
| `/organize-note` | Move and classify individual notes |
| `/link-notes` | Find and suggest connections between notes |
| `/video-note` | Create structured notes from videos |
| `/flashcards` | Generate spaced repetition flashcards |
| `/project-status` | View comprehensive project status and progress |

### Skills

- **obsidian-markdown**: Full Obsidian Flavored Markdown syntax support (wikilinks, callouts, embeds)
- **json-canvas**: Create and edit Canvas files for visual diagrams
- **obsidian-bases**: Database-like views with filters and formulas
- **agent-memory**: Persistent cross-session memory for agents

### Hooks

- **session-summary** (SessionStart): Shows vault status when starting
- **frontmatter-helper** (PostToolUse Write): Suggests metadata for new notes
- **link-suggester** (PostToolUse Write): Auto-suggests connections between notes

## Configuration

Your vault is configured via `.claude/vault-config.yml`. The setup wizard creates this automatically, but you can edit it manually for fine-tuning.

### Example Configuration

```yaml
vault_name: "MyVault"

folders:
  inbox: "INBOX/_quick-notes"
  knowledge: "KNOWLEDGE"
  projects: "PROJECTS"
  resources: "RESOURCES"
  productivity: "PRODUCTIVITY"
  ideas: "IDEAS"
  templates: "_SYSTEM/templates"

categories:
  - name: "AI-ML"
    folder: "KNOWLEDGE/IA-ML"
  - name: "Philosophy"
    folder: "KNOWLEDGE/Philosophy"

frontmatter_schema:
  required_fields: [id, created, modified, tipo, estado]
  optional_fields: [categories, projects, tags]
  tipo_values: [study, project, resource, idea, daily]
  estado_values: [active, archived, draft]
```

### Template Presets

**FrancoVault** (Recommended):
- Engineering/research focused
- Rich templates with emojis
- Discipline-based organization
- Comprehensive frontmatter

**Creative ADHD** ⭐ NEW:
- **Designed for creative, non-technical users with ADHD**
- Zero-friction workflows (maximum automation)
- Auto-saves session context (never lose track)
- Visual Canvas dashboard
- Energy-based task matching
- Ultra-simple structure (3 categories max)
- **Perfect for: "Olga-type" users who need a "technical babysitter"**

**Minimal**:
- Simple INBOX/NOTES/PROJECTS structure
- Plain text templates
- Basic frontmatter
- Quick setup

**Researcher**:
- Academic/research focused
- Literature management
- Paper notes and citations
- Research project tracking

**Custom**:
- Build from scratch
- Define your own structure
- Complete flexibility

## Architecture

### How It Works

1. **Configuration-Driven Design**: All commands read from `vault-config.yml` instead of using hard-coded paths
2. **Template System**: Multiple template sets with variable replacement
3. **Dynamic Adaptation**: Commands and hooks adapt to your folder structure automatically
4. **Universal Skills**: Format-based skills work with any vault structure

### File Structure

```
obsidian-plugin/
├── .claude-plugin/
│   └── plugin.json              # Plugin manifest
├── commands/
│   ├── setup-vault.md           # Interactive wizard
│   ├── daily-note.md            # Daily note creation
│   ├── new-project.md           # Project initialization
│   ├── process-inbox.md         # Inbox processing
│   ├── organize-note.md         # Note organization
│   ├── link-notes.md            # Note linking
│   ├── video-note.md            # Video note creation
│   ├── flashcards.md            # Flashcard generation
│   └── project-status.md        # Project status viewing
├── hooks/
│   └── hooks.json               # Hook definitions
├── skills/
│   ├── obsidian-markdown/       # Obsidian syntax support
│   ├── json-canvas/             # Canvas file support
│   ├── obsidian-bases/          # Bases file support
│   └── agent-memory/            # Persistent memory
├── templates/
│   ├── francovault/             # FrancoVault template set
│   └── minimal/                 # Minimal template set
├── config-examples/
│   ├── francovault-config.yml   # FrancoVault example
│   ├── minimal-config.yml       # Minimal example
│   └── researcher-config.yml    # Academic researcher example
└── README.md                    # This file
```

## Use Cases

### For Creative ADHD Users ⭐ NEW
**Problem:** Claude loses context, you lose track of what you were building, overwhelm sets in.

**Solution:** This system acts as your "external brain":
- **Auto-saves context:** Never forget where you left off
- **Session summaries:** EXACT next steps, every time
- **Visual dashboard:** See all projects at a glance
- **Energy matching:** Match tasks to your current energy level
- **Zero friction:** Maximum automation, minimal decisions

**Perfect for:**
- Architects of ideas who aren't developers
- Creative people who get lost in technical details
- Anyone with ADHD who needs persistent memory
- Users who want a "technical babysitter"

**Real user:** Designed for "Olga" - creative, non-technical, builds apps but loses context constantly.

### For Students
- Organize notes by subject
- Track assignments and projects
- Create study materials (flashcards)
- Build connections between concepts

### For Researchers
- Manage papers and references
- Track research projects
- Organize by discipline or topic
- Create literature reviews

### For Writers
- Organize by project or genre
- Track characters, plots, worldbuilding
- Manage drafts and revisions
- Research organization

### For Knowledge Workers
- Daily notes and journaling
- Project management
- Resource library
- Idea capture and development

## Customization

### Editing Configuration

Edit `.claude/vault-config.yml` to customize:
- Folder names and structure
- Categories/disciplines/topics
- Frontmatter schema
- Template preferences

After editing, commands automatically adapt to your changes.

### Creating Custom Templates

1. Create templates in your templates folder
2. Use variables: `{{date:YYYY-MM-DD}}`, `{{vault_name}}`, `{{folders.inbox}}`
3. Reference in commands with template paths from config

### Extending with Custom Commands

(Advanced) Add your own commands by:
1. Creating new `.md` files in `commands/`
2. Reading config with YAML parsing
3. Following command format from existing commands

## Troubleshooting

### Commands Not Finding Folders

**Issue**: Commands report folder not found

**Solution**:
1. Check `.claude/vault-config.yml` exists
2. Verify folder paths in config match your actual structure
3. Run `/setup-vault` again to regenerate config

### Templates Not Loading

**Issue**: Commands can't find templates

**Solution**:
1. Verify `folders.templates` in config points to correct location
2. Check templates exist in that folder
3. Ensure template filenames match what commands expect

### Config Syntax Errors

**Issue**: YAML parsing errors

**Solution**:
1. Validate YAML syntax (use YAML linter)
2. Check for proper indentation (use spaces, not tabs)
3. Compare with config examples in `config-examples/`

## Documentation

- [Configuration Guide](CONFIGURATION.md) - Detailed config reference
- [Customization Guide](CUSTOMIZATION.md) - How to customize and extend
- Command documentation - See inline docs in each command file
- [FrancoVault Example](config-examples/francovault-config.yml) - Full featured example

## Contributing

Contributions welcome! This is an open framework designed for community extension.

**Ways to contribute**:
- Share your vault configs
- Create new template sets
- Add custom commands
- Improve documentation
- Report bugs and suggest features

## License

MIT License - see LICENSE file

## Credits

Created by Franco Escobar based on the FrancoVault personal knowledge management system.

Inspired by:
- Obsidian community
- PKM methodologies (Zettelkasten, PARA, etc.)
- Agentic workflow automation

## Support

- GitHub Issues: Report bugs or request features
- Discussions: Share your vault setups and ask questions
- Wiki: Community-contributed guides and tips

---

**Version**: 1.0.0
**Status**: 🚧 In Development
**Last Updated**: 2026-01-12
