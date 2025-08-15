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
1. **Context Loading First**: ALL agents MUST load Redis context as Phase 0 before any processing
2. `tech-research-agent` - MUST be invoked before any implementation involving external libraries
3. `codebase-researcher` - MUST be invoked before any planning or implementation
4. `code-implementation` - MUST be invoked for ALL code writing activities

## Development Workflow

### Planning Mode Integration
When in plan mode, follow this mandatory sequence:
1. **Context Loading**: ALL agents load Redis context as Phase 0 before processing
2. **Research Phase**: Launch appropriate research agents (`codebase-researcher`, `tech-research-agent`)
3. **Synthesis Phase**: Compile findings from agent reports
4. **Standards Review Gate**: Invoke `code-standards-reviewer` (BLOCKING - required for all code changes)
5. **Planning Phase**: Create implementation plan incorporating all findings
6. **Implementation Phase**: Use `code-implementation` agent for all code writing

### Agent Failure Recovery
If agents fail to provide output:
1. **Context Loading Issues**: Verify Redis keys are properly formatted and accessible
2. Check for overly restrictive requirements (ALWAYS/NEVER statements)
3. Verify MCP server availability (`mcp__sequential-thinking__sequentialthinking`)
4. Consider token/context limits for complex research tasks
5. Use fallback strategies documented in agent definitions

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

**Context Storage** (Redis preferred, graceful fallback):
- **Primary**: Redis MCP server for context storage (preserves plan mode, no file writes)
- **Fallback**: Direct context in responses when Redis unavailable
- **Setup**: See `docs/REDIS_SETUP.md` for Redis MCP installation
- **Key Pattern**: `claude:context:{agent-name}:{timestamp}` with 24-hour TTL

**Context Flow**:
- Research agents (`codebase-researcher`, `tech-research-agent`) store findings in Redis
- Review agents (`code-standards-reviewer`) retrieve and store enhanced context
- Implementation agents (`code-implementation`) read context for informed decisions
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
4. Add fallback strategies for common failure scenarios
5. Run `./copy_claude_config.sh` to deploy

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
5. Add explicit fallback instructions

## Redis Context Storage Setup

### Installation
1. Install Redis server (local or remote)
2. Install Redis MCP server: `npm install -g @anthropic/mcp-server-redis`
3. Configure Claude Code settings (see `docs/REDIS_SETUP.md`)
4. Restart Claude Code to load Redis MCP

### Benefits
- **Plan Mode Preservation**: No file writes that exit plan mode
- **Performance**: Faster in-memory context access
- **Auto-cleanup**: 24-hour TTL for context keys
- **Clean Architecture**: No temporary files in repository

### Fallback Behavior
If Redis unavailable, agents automatically:
- Return context directly in responses (larger tokens)
- Preserve plan mode (no file writes)
- Maintain full functionality

## Integration with Other Projects

To use AroClaude agents in other projects:
1. Copy relevant agent definitions to project's `.claude/agents/`
2. Include CLAUDE_INTEGRATION.md directives in project's CLAUDE.md
3. Adapt commands for project-specific workflows
4. Maintain agent philosophy of rapid development with minimal validation
5. Optional: Set up Redis MCP for enhanced context storage