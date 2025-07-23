# AroClaude
Aroton's claude code configurations and prompts

## Setup

To install the Claude configurations and commands:

```bash
./copy_claude_config.sh
```

This script copies all configuration files from `.claude/` to your `~/.claude/` directory, making the custom commands available in any Claude Code session.

## Command Index

| Command | Purpose | Type |
|---------|---------|------|
| [`/code:cleanup`](#codecleanup) | Remove deprecated code and unused dependencies | Code Maintenance |
| [`/code:implement`](#codeimplement) | Research and plan technical implementations | Development Planning |
| [`/tests:fix`](#testsfix) | Automatically repair failing tests | Test Automation |
| [`/tests:refactor`](#testsrefactor) | Refactor tests with acceptance criteria | Test Quality |

## Available Commands

### `/code:cleanup`

Systematically discovers and removes deprecated code and unused dependencies from the codebase.

**Usage:**
- `/code:cleanup` - Discover and remove all deprecated code from the project
- `/code:cleanup [feature]` - Target specific deprecated feature for removal
- `/code:cleanup --dry-run` - Report what would be removed without making changes

**Key Features:**
- Comprehensive deprecation discovery through pattern matching
- Transitive dependency analysis before removal
- Risk assessment and atomic removal batches
- Continuous test validation during cleanup
- Aggressive deletion when backwards compatibility not required

**Process:**
1. **Discovery** - Searches for deprecation markers and unused code
2. **Usage Analysis** - Maps all dependencies and references
3. **Impact Assessment** - Categorizes risks and removal order
4. **Incremental Cleanup** - Removes code in dependency order with test validation

### `/code:implement`

Research-focused command that analyzes technical challenges and delivers structured implementation plans.

**Usage:**
- `/code:implement` - Research and deliver implementation plan for a specified technical challenge
- `/code:implement [topic]` - Research specific topic and create phased implementation plan

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

### `/tests:fix`

Automatically fixes failing tests by analyzing failures and repairing either test code or implementation code.

**Usage:**
- `/tests:fix` - Fix all failing tests in project
- `/tests:fix [test-pattern]` - Fix specific test files matching pattern
- `/tests:fix --focus [test-name]` - Fix specific test by name
- `/tests:fix --acceptance "criteria"` - Fix with custom acceptance criteria

**Key Features:**
- Orchestrated parallel execution with up to 10 sub-agents
- Intelligent fix strategy decision tree (test vs implementation)
- Maximum 5 fix attempts per test before manual review
- Full test suite validation after fixes
- Supports custom acceptance criteria for fix guidance

**Process:**
1. **Discovery** - Identifies all failing tests and groups into batches
2. **Parallel Delegation** - Launches sub-agents to fix test batches
3. **Final Validation** - Runs full test suite and reports results

### `/tests:refactor`

Analyzes tests against code/criteria and refactors them through phased execution with user approval.

**Usage:**
- `/tests:refactor [module/folder]` - Refactor tests for specified module to align with generated acceptance criteria

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
