# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

AroClaude is a specialized configuration repository for Claude Code that provides custom agents, commands, and workflows optimized for rapid development with AI validation testing. The repository contains battle-tested patterns for efficient software development using specialized AI agents.

## Setup and Deployment

To deploy configurations to Claude Code:
```bash
./copy_claude_config.sh
```

This copies all agents and commands from `.claude/` to `~/.claude/`, making them available in any Claude Code session.

## Architecture

### Agent System
The repository implements a sophisticated multi-agent architecture with 7 specialized agents categorized by function:
- **Research Agents** (Blue): `codebase-researcher`, `tech-research-agent`
- **Analysis Agents** (Purple): `acceptance-criteria-agent`, `automated-code-reviewer`
- **Authoring Agents** (Green): `code-implementation`
- **Planning Agents** (Orange): `implementation-planner`, `architecture-designer`

### Command System
Custom slash commands orchestrate agent workflows:
- `/code:analyze` - Batch analysis with acceptance criteria extraction
- `/code:cleanup` - Aggressive deprecated code removal
- `/code:fix` - Test-driven bug fixing with root cause analysis
- `/code:implement` - Research and planning for technical challenges
- `/code:review` - Multi-agent security and quality review
- `/validation:fix` - Minimal validation testing approach
- `/validation:simplify` - Code simplification with AI validation

### Critical Agent Dependencies

**MANDATORY Agent Usage Rules:**
1. `tech-research-agent` - MUST be invoked before any implementation involving external libraries
2. `codebase-researcher` - MUST be invoked before any planning or implementation
3. `code-implementation` - MUST be invoked for ALL code writing activities

## Development Workflow

### Planning Mode Integration
When in plan mode, follow this mandatory sequence:
1. **Research Phase**: Launch appropriate research agents (`codebase-researcher`, `tech-research-agent`)
2. **Synthesis Phase**: Compile findings from agent reports
3. **Standards Review Gate**: Invoke `code-standards-reviewer` (BLOCKING - required for all code changes)
4. **Planning Phase**: Create implementation plan incorporating all findings
5. **Implementation Phase**: Use `code-implementation` agent for all code writing

### Agent Failure Recovery
If agents fail to provide output:
1. Check for overly restrictive requirements (ALWAYS/NEVER statements)
2. Verify MCP server availability (`mcp__sequential-thinking__sequentialthinking`)
3. Consider token/context limits for complex research tasks

### File Structure
```
.claude/
├── agents/                     # Agent definitions (Markdown with YAML frontmatter)
├── commands/                   # Slash command implementations
└── settings.local.json         # Local permissions configuration
```

## Key Implementation Patterns

### AI Validation Testing Philosophy
- **Implementation First**: Ship features quickly with minimal testing overhead
- **Minimal Validation**: Maximum 3 integration tests per feature
- **Aggressive Deletion**: Remove deprecated code when backwards compatibility isn't needed
- **Rapid Development**: Focus on delivering working solutions fast

### Agent Communication

**Context Flow**:
- Research agents (`codebase-researcher`, `tech-research-agent`) provide findings directly in responses
- Review agents (`code-standards-reviewer`) receive and process context from previous agents
- Implementation agents (`code-implementation`) receive context for informed decisions
- Explicit task descriptions in prompts
- File paths and line numbers for code references
- Complete code snippets rather than descriptions
- Clear fallback instructions for partial failures

### Error Handling
All agents should:
- Provide partial output rather than failing silently
- Document what they searched for and couldn't find
- Suggest alternatives when primary approaches fail
- Flag risks and unknowns explicitly

## Common Tasks

### Adding New Agents
1. Create agent definition in `.claude/agents/aro:agent-name.md`
2. Include YAML frontmatter with: name, description, tools, model, color
3. Keep instructions concise (50-100 lines optimal)
4. Run `./copy_claude_config.sh` to deploy

### Modifying Commands
1. Edit command in `.claude/commands/command-name.md`
2. Test with various input scenarios
3. Ensure proper agent delegation
4. Deploy with `./copy_claude_config.sh`

### Debugging Agent Failures
1. Review agent definition for contradictory requirements
2. Check for absolute statements (ALWAYS/NEVER) causing paralysis
3. Verify tool dependencies are available
4. Simplify output requirements if too complex

## Integration with Other Projects

To use AroClaude agents in other projects:
1. Copy relevant agent definitions to project's `.claude/agents/`
2. Include CLAUDE_INTEGRATION.md directives in project's CLAUDE.md
3. Adapt commands for project-specific workflows
4. Maintain agent philosophy of rapid development with minimal validation