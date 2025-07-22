#!/bin/bash

# Copy everything from .claude directory to ~/.claude
echo "Copying from .claude to ~/.claude:"
cp -rv .claude/* ~/.claude/

echo "Copied .claude contents to ~/.claude"