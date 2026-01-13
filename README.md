# Obsidian Adaptive Plugin - Claude Code Marketplace

**A configurable framework for creating personalized Obsidian vaults with Claude Code**

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/yourusername/obsidian-plugin-marketplace)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

---

## 🌟 Overview

The **Obsidian Adaptive Plugin** is a revolutionary framework that transforms how you set up and interact with Obsidian vaults using Claude Code. Unlike traditional plugins, this one **adapts to YOUR workflow**, not the other way around.

### Key Innovation

🎯 **First PKM plugin that modifies its behavior based on user preferences**
- Dynamic commands that read your configuration
- Adaptive workflows (auto-classify, manual control, or hybrid)
- Multiple personas (Technical, Creative, Researcher, ADHD-friendly)
- Canvas-based visualizations (optional)

---

## ✨ Features

### 🧙 Interactive Setup Wizard (`/setup-vault`)
- **8-phase guided setup** with education-first approach
- Explains PKM concepts before asking questions
- 5 key questions to understand your workflow
- Intelligent config recommendation
- Full customization: add/remove/rename folders

### 🛠️ 7 Adaptive Commands
All commands read `.claude/vault-config.yml` and adapt automatically:

| Command | Description |
|---------|-------------|
| `/setup-vault` | Wizard to configure your vault from scratch |
| `/daily-note` | Create daily notes with smart context |
| `/process-inbox` | Classify and organize inbox notes (auto or manual) |
| `/new-project` | Create projects with structure + brief + research |
| `/organize-note` | Classify individual notes to correct location |
| `/link-notes` | Find and suggest connections between notes |
| `/project-status` | View project progress (optional Canvas dashboard) |

### 🎨 4 Base Configurations

#### 1. **FrancoVault** (Full-featured)
- All 9 folders (INBOX, KNOWLEDGE, PROJECTS, RECURSOS, etc.)
- Detailed frontmatter (8 fields)
- Medium automation
- For: Technical users, engineers, multi-disciplinary work

#### 2. **Minimal** (Simple)
- 3 essential folders (INBOX, PROJECTS, KNOWLEDGE)
- Simple frontmatter (4 fields)
- Manual control
- For: Minimalists, beginners

#### 3. **Researcher** (Academic)
- Focus on KNOWLEDGE + RECURSOS
- Bibliography management
- Citation support
- For: Academics, researchers, students

#### 4. **Creative ADHD** ⭐ (Zero Friction)
- 3 folders max (INBOX, PROJECTS, CONTEXT)
- **Auto-classification** (no questions asked)
- **Session-end hook** (auto-saves context)
- **Session-start hook** (shows where you left off)
- Energy-based task matching
- For: ADHD, neurodivergent users, creatives

---

## 🚀 Quick Start

### Installation

1. Clone this marketplace repo:
```bash
git clone https://github.com/yourusername/obsidian-plugin-marketplace.git
cd obsidian-plugin-marketplace
```

2. Use Claude Code with this plugin directory:
```bash
claude --plugin-dir ./plugins/obsidian-plugin
```

3. Navigate to your empty Obsidian vault:
```bash
cd /path/to/your/vault
```

4. Run the setup wizard:
```
/setup-vault
```

5. Follow the interactive wizard:
   - Learn about PKM system (9 folders explained)
   - Answer 5 questions about your workflow
   - Get config recommendation (or choose another)
   - Customize structure (optional)
   - Choose automation level
   - Done! Vault is ready

### First Steps

After setup:

```bash
# Create your first daily note
/daily-note

# Create a project
/new-project "My First Project"

# Capture ideas in INBOX, then process them
/process-inbox

# Check project status
/project-status "My First Project"
```

---

## 📖 How It Works

### The Adaptive System

```
User runs /setup-vault
         ↓
Wizard asks 5 questions
         ↓
Recommends config based on answers
         ↓
User customizes (folders, names, workflows)
         ↓
Generates .claude/vault-config.yml
         ↓
All commands READ this config
         ↓
Commands adapt automatically ✨
```

### Example: Auto-Classification

**If `workflows.inbox.auto_classify: true`:**
```
/process-inbox
→ Analyzes all notes
→ Classifies automatically
→ Moves to correct folders
→ NO confirmations asked
→ Zero friction ✨
```

**If `workflows.inbox.auto_classify: false`:**
```
/process-inbox
→ Analyzes all notes
→ Shows classification table
→ Asks: "Proceed? (s/n/edit)"
→ User confirms/edits
→ Then executes
```

### Example: Custom Folders

**User renamed folders during setup:**
```yaml
folders:
  inbox: "CAPTURA/"      # instead of INBOX/
  projects: "MIS-PROYECTOS/"  # instead of PROJECTS/
```

**All commands adapt:**
```
/daily-note
→ Reads config
→ Uses "CAPTURA/" for inbox
→ Uses "MIS-PROYECTOS/" for project links
→ Works seamlessly ✨
```

---

## 🎯 For ADHD Users (Creative ADHD Config)

### The Problem
People with ADHD often lose context between sessions, get overwhelmed by decisions, and struggle with complex organizational systems.

### Our Solution

**Session-End Hook (Auto-Save Context):**
- When you end a Claude session, it asks: "Notes before we finish?"
- Automatically saves session summary to `_CONTEXT/sessions/YYYY-MM-DD.md`
- Includes: what was done, what's pending, EXACT next step

**Session-Start Hook (Auto-Load Context):**
- Next session, Claude shows: "Last time you were working on X..."
- **You NEVER lose the thread** 🎯

**Auto-Classification:**
- No decisions needed
- Notes are classified based on content analysis
- Zero friction workflow

**Ultra-Simple Structure:**
- Only 3 folders: INBOX, PROJECTS, CONTEXT
- No complex categories
- Visual Canvas dashboard (optional)

---

## 📁 Repository Structure

```
obsidian-plugin-marketplace/
├── .claude-plugin/
│   └── marketplace.json       # Marketplace metadata
├── plugins/
│   └── obsidian-plugin/       # The actual plugin
│       ├── plugin.json        # Plugin manifest
│       ├── README.md          # Plugin documentation
│       ├── vault-config.schema.yml  # Config schema
│       ├── commands/          # 7 adaptive commands
│       │   ├── setup-vault.md
│       │   ├── daily-note.md
│       │   ├── process-inbox.md
│       │   ├── new-project.md
│       │   ├── organize-note.md
│       │   ├── link-notes.md
│       │   └── project-status.md
│       ├── config-examples/   # 4 base configurations
│       │   ├── francovault-config.yml
│       │   ├── minimal-config.yml
│       │   ├── researcher-config.yml
│       │   └── creative-adhd-config.yml
│       ├── skills/            # 4 Obsidian skills
│       │   ├── obsidian-markdown/
│       │   ├── json-canvas/
│       │   ├── obsidian-bases/
│       │   └── agent-memory/
│       └── templates/         # 3 template sets
│           ├── francovault/
│           ├── minimal/
│           └── creative-adhd/
├── .gitignore
├── LICENSE
└── README.md (this file)
```

---

## 🔧 Configuration

After running `/setup-vault`, your vault will have:

### `.claude/vault-config.yml`
```yaml
vault_name: "My Vault"
version: "1.0"

folders:
  inbox: "INBOX/"
  projects: "PROJECTS/"
  knowledge: "KNOWLEDGE/"
  # ... customized by you

workflows:
  inbox:
    auto_classify: true    # Auto or manual
  canvas:
    enabled: true          # Enable Canvas dashboards

frontmatter_schema:
  required_fields:
    - id
    - created
    - tipo
    - estado
  optional_fields:
    - disciplinas
    - proyectos
    - tags
    - tiene-todos

preferences:
  verbosity: "casual"      # casual | technical | balanced
  confirmation_prompts: false  # Skip confirmations if auto_classify
```

### `.claude/hooks/hooks.json`
Generated by the wizard based on your preferences:
- `session-start`: Welcome summary
- `session-end`: Auto-save context (ADHD feature)
- `frontmatter-helper`: Suggest metadata
- `link-suggester`: Suggest connections

---

## 📊 Stats

- **3,188 lines** of command specifications
- **7 adaptive commands** (all read vault-config.yml)
- **4 base configurations** (+ full customization)
- **15 templates** (3 template sets)
- **4 skills** (Obsidian-specific)
- **Dynamic hooks** (generated by wizard)

---

## 🎨 Use Cases

### For Engineers (FrancoVault)
- Multi-disciplinary knowledge base (IA-ML, Electronics, Aerospace, etc.)
- Project tracking with Kanban
- Flashcard generation from notes
- Video note processing

### For Researchers (Researcher)
- Paper management
- Citation tracking
- Bibliography generation
- Literature review workflows

### For Creatives with ADHD (Creative ADHD)
- Zero-friction capture
- Auto-classification
- Context preservation
- Energy-based task matching
- Visual dashboards

### For Minimalists (Minimal)
- Simple 3-folder structure
- Manual control
- No complexity
- Just the essentials

---

## 🛠️ Development & Customization

### For End Users
Edit `.claude/vault-config.yml` in your vault to customize:
- Folder names
- Automation level
- Frontmatter schema
- Canvas settings

### For Technical Users
Want to modify commands, skills, or add custom workflows?

**📖 See [CUSTOMIZATION.md](CUSTOMIZATION.md) for complete guide**

Three approaches:
1. **Fork + Modify** - Full control, team sharing
2. **Local Copy** - Simple, vault-based
3. **Override System** - Selective customization

### Testing the Plugin

1. Create an empty test vault
2. Run the wizard
3. Test each command
4. Verify config reading

### Contributing

Contributions are welcome! Areas to improve:
- Additional base configurations
- More adaptive commands
- Better Canvas generation
- Multi-language support

See [CUSTOMIZATION.md](CUSTOMIZATION.md) for contribution guidelines.

---

## 📝 License

MIT License - See [LICENSE](LICENSE) file for details

---

## 🙏 Credits

**Created by:** Franco Escobar  
**Email:** francoescobarvrx@gmail.com

**Inspired by:**
- Obsidian.md community
- Claude Code extensibility
- Personal Knowledge Management best practices
- ADHD-friendly productivity systems

---

## 🔗 Links

- **Plugin Documentation:** [plugins/obsidian-plugin/README.md](plugins/obsidian-plugin/README.md)
- **Configuration Schema:** [plugins/obsidian-plugin/vault-config.schema.yml](plugins/obsidian-plugin/vault-config.schema.yml)
- **Example Configs:** [plugins/obsidian-plugin/config-examples/](plugins/obsidian-plugin/config-examples/)

---

## 💡 Why This Plugin is Unique

**No other PKM plugin does this:**
1. ✅ Adapts commands to user preferences
2. ✅ Modifies behavior based on configuration
3. ✅ ADHD-specific workflows (auto-save context)
4. ✅ Canvas-based dashboards (programmatic)
5. ✅ Education-first wizard (explains PKM concepts)
6. ✅ Multiple personas in one plugin
7. ✅ Dynamic frontmatter schemas
8. ✅ Fully customizable folder structure

**This is the future of PKM plugins.** 🚀

---

**Made with ❤️ for the Obsidian + Claude Code community**
