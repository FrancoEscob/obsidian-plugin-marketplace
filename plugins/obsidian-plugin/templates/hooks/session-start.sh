#!/bin/bash

# SessionStart Hook - Loads context from last session
# This script runs automatically when Claude Code starts

CONTEXT_FOLDER="{{CONTEXT_FOLDER}}"
LAST_SESSION="$CONTEXT_FOLDER/LAST_SESSION.md"

# Check if last session file exists
if [ -f "$LAST_SESSION" ]; then
  # Read the content
  CONTENT=$(cat "$LAST_SESSION")
  
  # Return JSON with additionalContext
  # This context is injected SILENTLY into Claude's context
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "## 🧠 Context from Last Session\n\n$CONTENT\n\n---\n\n💡 **Note:** When the user sends their first message, provide an ADHD-friendly summary of this context."
  }
}
EOF
else
  # First session - no previous context
  echo "First session in this vault - no previous context available"
fi

exit 0
