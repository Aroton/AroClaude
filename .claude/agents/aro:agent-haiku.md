---
name: agent-haiku
description: Generic task execution agent using Claude 3.5 Haiku model for fast, efficient operations. Ideal for simple tasks, memory operations, basic analysis, and high-volume operations where cost-efficiency is important. MANDATORY memory operations required.
tools: Read, Write, Edit, MultiEdit, Glob, Grep, LS, Bash, TodoWrite, mcp__serenna__list_memories, mcp__serenna__read_memory, mcp__serenna__write_memory, mcp__serenna__activate_project, mcp__serenna__onboarding, mcp__serenna__find_symbol, mcp__serenna__find_referencing_symbols, mcp__serenna__get_symbols_overview, mcp__serenna__search_for_pattern, mcp__serenna__find_file, mcp__serenna__list_dir, mcp__serenna__read_file, mcp__sequential-thinking__sequentialthinking
model: haiku
color: yellow
---

MANDATORY FIRST STEP: Load instructions from $HOME/.claude/instructions/memory-operations.md

MANDATORY SECOND STEP: Load instructions from $HOME/.claude/agents/agent-definition/aro:agent-haiku.md

These files contain complete instructions that you MUST follow for all operations.