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
| [`/code:analyze`](#codeanalyze) | Analyze code changes to update documentation | Documentation |
| [`/code:cleanup`](#codecleanup) | Remove deprecated code and unused dependencies | Code Maintenance |
| [`/code:implement`](#codeimplement) | Research and plan technical implementations | Development Planning |
| [`/code:review`](#codereview) | Comprehensive code review with specialized agents | Code Quality |
| [`/tests:fix`](#testsfix) | Automatically repair failing tests | Test Automation |
| [`/tests:refactor`](#testsrefactor) | Refactor tests with acceptance criteria | Test Quality |

## Available Commands

### `/code:analyze`

Analyzes code changes or entire codebase to automatically update acceptance criteria and codebase documentation using specialized agents.

**Usage:**
- `/code:analyze` - Analyze changes in current branch (or entire codebase if on main)
- `/code:analyze [branch]` - Analyze changes in specified branch
- `/code:analyze [commit-hash]` - Analyze changes in specific commit
- `/code:analyze --from [ref1] --to [ref2]` - Analyze changes between two references

**Key Features:**
- Delegates to specialized agents (acceptance-criteria-agent and codebase-specialist)  
- Batches files for efficient analysis (50-100 files per batch)
- Analyzes entire codebase when on main branch
- Focuses on changes when on feature branches
- Never filters files by extension - lets agents determine relevance
- Provides comprehensive summaries from both agents

**Process:**
1. **Scope Determination** - Identifies whether to analyze entire codebase or specific changes
2. **File Collection** - Gathers all relevant files using git commands
3. **Agent Delegation** - Sends batches to acceptance-criteria-agent and codebase-specialist
4. **Summary Compilation** - Provides comprehensive analysis results

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

### `/code:review`

Performs comprehensive code review of changes or entire codebase using specialized agents for security, quality, and best practices analysis.

**Usage:**
- `/code:review` - Review changes in current branch (or entire codebase if on main)
- `/code:review [branch]` - Review changes in specified branch
- `/code:review [commit-hash]` - Review changes in specific commit
- `/code:review --from [ref1] --to [ref2]` - Review changes between two references
- `/code:review [file-path]` - Review specific file or directory

**Key Features:**
- Multi-agent review (automated-code-reviewer and codebase-specialist)
- Comprehensive security vulnerability assessment
- Code quality and performance analysis
- Architecture review and technical debt assessment
- Risk categorization (High/Medium/Low)
- Batch processing for large codebases
- Never skips files based on extension

**Process:**
1. **Scope Determination** - Identifies review boundaries (entire codebase vs changes)
2. **File Collection** - Gathers all relevant files using git commands
3. **Agent Delegation** - Distributes batches to specialized review agents
4. **Security Assessment** - Dedicated security analysis for critical issues
5. **Summary Compilation** - Provides comprehensive review with risk assessment

**Review Categories:**
- Security vulnerabilities and authentication flaws
- Code quality, performance, and maintainability
- Architecture patterns and technical debt
- Test coverage and quality assessment

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
- `/tests:refactor` - Auto-detect changes by comparing current branch to main and refactor affected modules

**Key Features:**
- Auto-detects changed modules when no specific module provided
- Analyzes existing tests and generates comprehensive acceptance criteria
- Creates structured refactoring plans with clear phases
- Prioritizes test readability over reusability (one clear test per situation)
- Fixes code bugs discovered during test refactoring
- Handles questions dynamically during execution
- Saves approved criteria as documentation

**Process:**
1. **Context Gathering** - Confirms module (or auto-detects from git diff) and analysis sources (code/criteria docs)
2. **Analysis & Criteria Generation** - Sub-agent analyzes and generates acceptance criteria
3. **Criteria Approval** - User reviews and approves generated criteria
4. **Refactoring Plan** - Creates phased plan for test updates
5. **Phased Execution** - Executes refactoring through TODO-tracked phases

**Philosophy:**
- Clarity over DRY principles
- One test per distinct situation
- Descriptive test names over concise ones
- Maintains valuable edge case tests

## Agent Color Palette

Agents are categorized by their primary function and assigned colors for visual organization:

| Color | Category | Purpose |
|-------|----------|---------|  
| 🟢 **Green** | Authoring Agents | Create and implement code/tests |
| 🔵 **Blue** | Research Agents | Analyze and document systems |
| 🟣 **Purple** | Analysis Agents | Review and extract requirements |
| 🔴 **Red** | *Reserved* | Error handling/critical operations |
| 🟡 **Yellow** | *Reserved* | Monitoring/alerting systems |
| 🟠 **Orange** | *Reserved* | Integration/deployment agents |
| 🩷 **Pink** | *Reserved* | User experience/interface agents |
| 🩵 **Cyan** | *Reserved* | Data processing/transformation |

## Specialized Agents

The following specialized agents are available to assist with specific development tasks:

### 🟣 `acceptance-criteria-agent` (Analysis)
Generates, updates, and maintains acceptance criteria documentation based on code changes. Analyzes implementations and creates structured acceptance criteria that remain synchronized with the codebase.

### 🟣 `automated-code-reviewer` (Analysis)
Performs comprehensive code reviews beyond basic linting, analyzing security patterns, validating against documented standards, and checking for architectural compliance and performance improvements.

### 🔵 `codebase-specialist` (Research)
Understands, navigates, and analyzes codebase architecture, relationships, and implementation details. Maps system flows, identifies dependencies, and creates persistent knowledge documentation.

### 🟢 `tdd-code-writer` (Authoring)
Implements code that satisfies tests in a TDD workflow. Analyzes failing tests and implements minimal code needed to make them pass, then refactors for clarity while maintaining test coverage.

### 🟢 `tdd-test-writer` (Authoring)
Creates comprehensive test suites from acceptance criteria and validates implementations in TDD workflows. Translates acceptance criteria into failing tests that drive development.

### 🔵 `technology-specialist` (Research)
Discovers production-ready integration patterns and implementation strategies used by industry leaders. Researches battle-tested solutions, analyzes engineering approaches from major tech companies, and provides proven patterns that avoid common pitfalls.
