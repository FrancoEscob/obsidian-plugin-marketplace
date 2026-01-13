# 🛠️ Customization Guide for Technical Users

This guide is for technical users who want to modify or extend the plugin beyond the standard vault-config.yml customization.

---

## 🎯 Who This Is For

- Developers who want to modify commands
- Power users who need custom workflows
- Teams who want to fork and maintain their own version
- Contributors who want to extend the plugin

**Note:** For basic customization (folders, automation, frontmatter), edit `.claude/vault-config.yml` in your vault. This guide is for **modifying the plugin itself**.

---

## 🔧 Three Approaches

### 1. Fork + Modify (Recommended for Teams)

**Best for:** Teams, long-term customization, contributing back

**Steps:**

1. **Fork the repository:**
   ```bash
   # On GitHub, fork:
   https://github.com/FrancoEscob/obsidian-plugin-marketplace
   
   # To your account:
   https://github.com/your-username/obsidian-plugin-marketplace
   ```

2. **Clone your fork:**
   ```bash
   git clone https://github.com/your-username/obsidian-plugin-marketplace.git
   cd obsidian-plugin-marketplace/plugins/obsidian-plugin/
   ```

3. **Modify anything:**
   ```bash
   # Modify commands
   nano commands/setup-vault.md
   
   # Modify skills
   nano skills/obsidian-markdown/SKILL.md
   
   # Add new templates
   mkdir templates/my-custom-template/
   
   # Modify configs
   nano config-examples/creative-adhd-config.yml
   ```

4. **Test locally:**
   ```bash
   cd ~/your-vault/
   claude --plugin-dir ~/path/to/your-fork/plugins/obsidian-plugin
   ```

5. **Commit your changes:**
   ```bash
   git add .
   git commit -m "Custom: Added my team's workflow"
   git push origin main
   ```

6. **Use your fork:**
   ```bash
   /plugin
   → Add marketplace
   → your-username/obsidian-plugin-marketplace
   ```

**Pros:**
- ✅ Full control
- ✅ Can contribute back via PR
- ✅ Team can share the same fork
- ✅ Git history for your changes

**Cons:**
- ⚠️ Need to manually sync with upstream updates
- ⚠️ Requires GitHub account

---

### 2. Local Plugin Directory (Simple)

**Best for:** Individual users, quick modifications

**Steps:**

1. **Copy plugin to your vault:**
   ```bash
   cd your-vault/
   
   # Create custom plugins directory
   mkdir -p .claude-plugins/obsidian-custom/
   
   # Copy from installed cache
   cp -r ~/.claude/plugins/cache/obsidian-adaptive-plugin-marketplace/obsidian-plugin/1.0.0/* \
         .claude-plugins/obsidian-custom/
   ```

2. **Modify files directly in your vault:**
   ```bash
   # Now you can edit freely
   nano .claude-plugins/obsidian-custom/commands/daily-note.md
   
   # Add custom commands
   touch .claude-plugins/obsidian-custom/commands/my-command.md
   ```

3. **Use the local version:**
   ```bash
   # Option A: Use --plugin-dir flag
   claude --plugin-dir .claude-plugins/obsidian-custom/
   
   # Option B: Add to settings
   echo '{
     "pluginDirs": ["./.claude-plugins/obsidian-custom/"]
   }' > .claude/settings.local.json
   ```

**Pros:**
- ✅ Everything in your vault
- ✅ Can version with vault's git
- ✅ Easy to share with team (if vault is shared)
- ✅ No GitHub needed

**Cons:**
- ⚠️ Manual updates from original plugin
- ⚠️ Not connected to marketplace

---

### 3. Override System (Selective Customization)

**Best for:** Minor tweaks, keeping base plugin updated

**Steps:**

1. **Create overrides directory:**
   ```bash
   cd your-vault/
   mkdir -p .claude/overrides/commands/
   mkdir -p .claude/overrides/skills/
   mkdir -p .claude/overrides/templates/
   ```

2. **Copy only what you want to modify:**
   ```bash
   # Override a specific command
   cp ~/.claude/plugins/cache/.../commands/daily-note.md \
      .claude/overrides/commands/
   
   # Modify your copy
   nano .claude/overrides/commands/daily-note.md
   ```

3. **Plugin prioritizes overrides:**
   - Commands check `.claude/overrides/commands/` first
   - Falls back to plugin version if no override exists
   - Only override what you need

**Pros:**
- ✅ Minimal customization needed
- ✅ Still get plugin updates for non-overridden files
- ✅ Clean separation of custom vs original

**Cons:**
- ⚠️ Requires plugin support (needs to be implemented)
- ⚠️ Currently not available (would need to add)

---

## 🎨 Common Customization Examples

### Example 1: Add Custom Command

```bash
# In your fork or local copy
cd plugins/obsidian-plugin/commands/

# Create new command
cat > my-custom-command.md << 'EOF'
---
description: "My custom workflow"
argument-hint: "[options]"
allowed-tools:
  - Read
  - Write
  - Bash
---

# Comando: /my-custom

My custom command logic here...
EOF
```

### Example 2: Modify Setup Wizard

```bash
# Edit the wizard to add your own config
nano commands/setup-vault.md

# Add custom configuration option:
# In FASE 3, add:
# 5. my-company-config (for our team)
```

### Example 3: Add Company Template

```bash
# Create company-specific templates
mkdir templates/my-company/
cat > templates/my-company/daily-note.md << 'EOF'
---
id: daily-{{date}}
created: {{date}}
company: MyCompany
---

# Daily Note - {{date}}

## Company Standup
...
EOF
```

### Example 4: Custom Skill

```bash
# Add company-specific skill
mkdir skills/company-tools/
cat > skills/company-tools/SKILL.md << 'EOF'
# Skill: Company Tools Integration

This skill adds commands for our company's internal tools...
EOF
```

---

## 📝 Best Practices

### 1. **Keep Original Plugin ID:**
Don't change the plugin name in `plugin.json` unless you want a completely separate plugin.

### 2. **Document Your Changes:**
```bash
# Add CUSTOMIZATIONS.md to track your changes
cat > CUSTOMIZATIONS.md << 'EOF'
# Our Company Customizations

## Changes from Original:
- Modified /setup-vault to add company-config
- Added /standup command
- Created templates/company-internal/

## Sync Notes:
Last synced with upstream: 2026-01-13
EOF
```

### 3. **Sync with Upstream:**
```bash
# If you forked, keep sync with original
git remote add upstream https://github.com/FrancoEscob/obsidian-plugin-marketplace.git
git fetch upstream
git merge upstream/main
```

### 4. **Test Before Sharing:**
```bash
# Always test in a separate vault first
mkdir ~/test-vault
cd ~/test-vault
claude --plugin-dir ~/your-modified-plugin/
/setup-vault  # Test all commands
```

---

## 🤝 Contributing Back

If you made improvements that others could benefit from:

1. **Fork the original repo** (if not already)
2. **Create a feature branch:**
   ```bash
   git checkout -b feature/my-improvement
   ```

3. **Make your changes**
4. **Push and create PR:**
   ```bash
   git push origin feature/my-improvement
   # Then create PR on GitHub
   ```

5. **Describe your changes** in the PR

---

## 🔄 Update Strategy

### If You Forked:
```bash
# Periodically sync with upstream
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

### If You Copied Locally:
```bash
# Check for updates manually
# Compare your version with latest release
# Manually merge changes you want
```

---

## ⚠️ Important Notes

### Plugin Structure:
```
obsidian-plugin/
├── .claude-plugin/
│   └── plugin.json        # ⚠️ Don't change version unless you know what you're doing
├── commands/              # ✅ Safe to modify
├── skills/                # ✅ Safe to modify
├── templates/             # ✅ Safe to modify
├── config-examples/       # ✅ Safe to modify
└── vault-config.schema.yml  # ⚠️ Careful - affects validation
```

### Breaking Changes:
- Modifying `vault-config.schema.yml` can break validation
- Changing command arguments can break existing workflows
- Document any breaking changes for your team

### Testing:
- Test in empty vault first
- Test with different configurations
- Test all modified commands

---

## 🆘 Troubleshooting

### Plugin Not Loading:
```bash
# Check plugin.json is valid
cat .claude-plugin/plugin.json | jq .

# Check file permissions
ls -la commands/
chmod +r commands/*.md
```

### Commands Not Working:
```bash
# Verify command frontmatter
head -20 commands/setup-vault.md

# Check allowed-tools are correct
```

### Cache Issues:
```bash
# Clear Claude's plugin cache
rm -rf ~/.claude/plugins/cache/your-plugin/

# Reinstall
/plugin
→ Reinstall plugin
```

---

## 📞 Support

- **Original Plugin Issues:** Open issue on original repo
- **Your Customizations:** Document in your fork/copy
- **General Questions:** Check main README.md

---

**Happy Customizing! 🚀**
