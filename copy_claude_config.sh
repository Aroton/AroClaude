#!/bin/bash

# Ensure ~/.claude directory exists
mkdir -p ~/.claude

# Copy everything from .claude directory to ~/.claude
echo "Copying Claude configurations to ~/.claude:"
echo "- Commands (slash commands)"
echo "- Agents (specialized agents)"
echo "- Other configurations"

cp -rv .claude/* ~/.claude/

echo "Successfully copied .claude contents to ~/.claude"
echo "Available agents: $(ls ~/.claude/agents/ 2>/dev/null | wc -l) specialized agents ready"