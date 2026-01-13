#!/bin/bash

# SessionEnd Hook - Saves session timestamp and basic info
# This script runs automatically when Claude Code ends (/exit, Ctrl+C, etc.)

CONTEXT_FOLDER="{{CONTEXT_FOLDER}}"

# Read input JSON from stdin
INPUT=$(cat)

# Extract reason (clear | logout | prompt_input_exit | other)
REASON=$(echo "$INPUT" | grep -o '"reason":"[^"]*"' | cut -d'"' -f4)

# Generate timestamp
DATE=$(date +%Y-%m-%d)
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Setup paths
SESSIONS_DIR="$CONTEXT_FOLDER/sessions"
SESSION_FILE="$SESSIONS_DIR/$DATE.md"
LAST_SESSION="$CONTEXT_FOLDER/LAST_SESSION.md"

# Create sessions directory if it doesn't exist
mkdir -p "$SESSIONS_DIR"

# Save session information
cat > "$SESSION_FILE" <<EOF
---
id: session-$DATE
created: $TIMESTAMP
tipo: session
reason: $REASON
---

# Session: $DATE

**Ended:** $TIMESTAMP  
**Reason:** $REASON

**Note:** For a complete summary, ask Claude to generate one before closing the session.

To get a good summary before closing:
\`\`\`
"Summarize what we worked on today and what the exact next step is"
\`\`\`

Then close with \`/exit\`
EOF

# Update LAST_SESSION for next session
cp "$SESSION_FILE" "$LAST_SESSION"

# Return success message
echo "✅ Session saved to $SESSION_FILE"
exit 0
