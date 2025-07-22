# AroClaude
Aroton's claude code configurations and prompts

## Setup

To install the Claude configurations and commands:

```bash
./copy_claude_config.sh
```

This script copies all configuration files from `.claude/` to your `~/.claude/` directory, making the custom commands available in any Claude Code session.

## Available Commands

### `/research-implement`

A powerful sub-agent command for comprehensive technical research and implementation planning.

**Usage:**
- `/research-implement` - Research and deliver implementation plan for a specified technical challenge
- `/research-implement [topic]` - Research specific topic and create phased implementation plan

**Key Features:**
- Thorough codebase analysis before proposing solutions
- Generates 20+ solution approaches internally before recommending
- Creates structured implementation plans with clear phases
- Emphasizes test reuse and backwards compatibility considerations
- Optimized for token efficiency through sub-agent delegation

**Process:**
1. **Clarification** - Asks targeted questions about requirements and constraints
2. **Codebase Analysis** - Maps current architecture and identifies integration points
3. **Solution Generation** - Internally evaluates multiple approaches
4. **Implementation Planning** - Delivers structured, phased execution plan

The command outputs a detailed plan that the main agent can execute using TODO tracking, ensuring systematic implementation with proper testing and validation at each phase.

### `/refactor-tests`

A hybrid command that analyzes tests against code/criteria and refactors them through phased execution.

**Usage:**
- `/refactor-tests [module/folder]` - Refactor tests for specified module to align with generated acceptance criteria

**Key Features:**
- Analyzes existing tests and generates comprehensive acceptance criteria
- Creates structured refactoring plans with clear phases
- Prioritizes test readability over reusability (one clear test per situation)
- Fixes code bugs discovered during test refactoring
- Handles questions dynamically during execution
- Saves approved criteria as documentation

**Process:**
1. **Context Gathering** - Confirms module and analysis sources (code/criteria docs)
2. **Analysis & Criteria Generation** - Sub-agent analyzes and generates acceptance criteria
3. **Criteria Approval** - User reviews and approves generated criteria
4. **Refactoring Plan** - Creates phased plan for test updates
5. **Phased Execution** - Executes refactoring through TODO-tracked phases

**Philosophy:**
- Clarity over DRY principles
- One test per distinct situation
- Descriptive test names over concise ones
- Maintains valuable edge case tests
