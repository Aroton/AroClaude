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
| [`/code:fix`](#codefix) | Diagnose and fix bugs through test-driven approach | Bug Fixing |
| [`/code:implement`](#codeimplement) | Research and plan technical implementations | Development Planning |
| [`/code:review`](#codereview) | Comprehensive code review with specialized agents | Code Quality |
| [`/validation:fix`](#validationfix) | Fix failing tests with minimal validation approach | Test Automation |
| [`/validation:simplify`](#validationsimplify) | Simplify code with AI validation testing | Code Simplification |

## Directory Structure

The `.claude/` directory contains:

```
.claude/
├── agents/                     # Specialized agent definitions (7 agents)
│   ├── aro:acceptance-criteria-agent.md
│   ├── aro:architecture-designer.md
│   ├── aro:automated-code-reviewer.md
│   ├── aro:code-implementation.md
│   ├── aro:codebase-researcher.md
│   ├── aro:implementation-planner.md
│   └── aro:tech-research-agent.md
├── commands/                   # Custom slash commands (7 commands)
│   ├── code:analyze.md
│   ├── code:cleanup.md
│   ├── code:fix.md
│   ├── code:implement.md
│   ├── code:review.md
│   ├── validation:fix.md
│   └── validation:simplify.md
└── settings.local.json         # Local Claude Code permissions
```

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

### `/code:fix`

Diagnoses and fixes errors or bugs through systematic analysis, root cause identification, and test-driven fixes.

**Usage:**
- `/code:fix` - Fix a specified error or bug with comprehensive analysis
- `/code:fix [error description]` - Fix specific error or bug with test-driven approach

**Key Features:**
- Systematic root cause analysis using specialized agents
- Mandatory test-first approach (Red-Green-Refactor cycle)
- Comprehensive error reproduction before fixing
- Automated regression prevention through test coverage
- Cross-checking for similar bugs in related code
- Detailed fix documentation for team learning

**Process:**
1. **Error Analysis** - Gather complete error details and reproduction steps
2. **Root Cause Investigation** - Trace error through codebase to identify true cause
3. **Test Creation** - Write failing test that reproduces the bug
4. **Fix Implementation** - Implement minimal fix to make tests pass
5. **Verification** - Run full test suite and check for regressions

**TDD Enforcement:**
- Tests MUST fail before any fix is written
- Fix addresses root cause, not symptoms
- All fixes include regression tests
- No debug scripts - issues reproduced through proper tests

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

### `/validation:fix`

Fixes failing tests using the AI validation framework with minimal testing approach.

**Usage:**
- `/validation:fix` - Fix failing tests with minimal validation
- `/validation:fix [test-pattern]` - Fix specific failing tests

**Key Features:**
- Implementation-first solutions with maximum 3 integration tests per feature
- Rapid feature development with validation gates
- Minimal test overhead while catching AI-generated errors
- Quick fixes with validation testing only when needed

**Process:**
1. **Test Analysis** - Identify failing tests and root causes
2. **Implementation** - Fix the failing functionality
3. **Validation** - Add minimal integration tests to prevent regressions

### `/validation:simplify`

Simplifies code complexity while maintaining functionality through AI validation testing.

**Usage:**
- `/validation:simplify` - Simplify complex code with validation
- `/validation:simplify [file-pattern]` - Target specific files for simplification

**Key Features:**
- Code complexity reduction with maintained functionality
- Minimal validation to ensure correctness
- AI-powered refactoring with safety nets
- Focus on readability and maintainability

**Process:**
1. **Complexity Analysis** - Identify overly complex code sections
2. **Simplification** - Refactor for clarity and simplicity
3. **Validation** - Ensure functionality is preserved through testing

## Agent Color Palette

Agents are categorized by their primary function and assigned colors for visual organization:

| Color | Category | Purpose |
|-------|----------|---------|  
| 🟢 **Green** | Authoring Agents | Create and implement code/tests |
| 🔵 **Blue** | Research Agents | Analyze and document systems |
| 🟣 **Purple** | Analysis Agents | Review and extract requirements |
| 🔴 **Red** | *Reserved* | Error handling/critical operations |
| 🟡 **Yellow** | *Reserved* | Monitoring/alerting systems |
| 🟠 **Orange** | Planning/Architecture Agents | Design implementations and system architecture |
| 🩷 **Pink** | *Reserved* | User experience/interface agents |
| 🩵 **Cyan** | *Reserved* | Data processing/transformation |

## Specialized Agents

The following specialized agents are available to assist with specific development tasks:

### 🟣 `aro:acceptance-criteria-agent` (Analysis)
**Purpose**: Extracts and documents acceptance criteria from requirements or code. Analyzes implementations and creates structured acceptance criteria that remain synchronized with the codebase.

**Key Capabilities**:
- Extracts testable requirements from code implementations
- Documents acceptance criteria in Given-When-Then format
- Maintains criteria files in `documentation/agents/acceptance-criteria/`
- Updates existing criteria rather than creating duplicates
- Captures edge cases, validation rules, and business logic

**Usage Examples**:
- Planning new features: "What should I consider for a user notification system?"
- Clarifying vague requirements: "What does 'better search functionality' mean?"
- Documenting existing code: "This code has no requirements documentation"

### 🟣 `aro:automated-code-reviewer` (Analysis)
**Purpose**: Performs comprehensive code reviews for security, performance, and quality. Analyzes code changes beyond basic linting, validating against documented standards and checking for architectural compliance.

**Key Capabilities**:
- Security vulnerability analysis (OWASP guidelines, injection attacks, etc.)
- Performance evaluation and optimization suggestions
- Code quality assessment (SOLID principles, complexity metrics)
- Architectural compliance validation
- Integration with MCP-connected tools for real-time insights
- Categorized feedback (Critical, Major, Minor, Positive)

**Usage Examples**:
- Pre-merge reviews: "Review my user management feature implementation"
- Security audits: "Check this API endpoint for security vulnerabilities"
- Performance validation: "Did my refactoring improve performance?"

### 🔵 `aro:codebase-researcher` (Research)
**Purpose**: Thoroughly researches and understands existing code before planning or implementing changes. This agent is MANDATORY for all planning stages and must be used before delegating implementation work to other agents.

**Key Capabilities**:
- Systematic code analysis with complete structure mapping
- Dependency mapping (internal and external)
- Pattern recognition and architectural decision documentation
- Context extraction for business logic and edge cases
- Provides exhaustive research for delegation to implementation agents
- Creates actionable intelligence with specific files and functions to modify

**Usage Examples**:
- Feature planning: "Research the current authentication implementation before adding OAuth"
- Refactoring: "Analyze the payment module structure before performance improvements"
- Debugging: "Investigate the synchronization code and its dependencies"

### 🟢 `aro:code-implementation` (Authoring)
**Purpose**: MANDATORY agent for ALL code writing activities. Translates technical requirements into production-ready code after research has been completed by tech-research-agent and/or codebase-researcher agents.

**Key Capabilities**:
- Production-ready code implementation with quality assurance pipeline
- Integration with existing architecture and patterns
- Clean code principles (DRY, modularity, testability)
- Comprehensive documentation with JSDoc/TSDoc comments
- Mandatory validation: linting, type safety, test validation
- Leverages context from research agents for seamless integration

**Usage Examples**:
- Feature implementation: "Create JWT authentication middleware"
- Refactoring: "Refactor data processing function for performance"
- Utility functions: "Write email validation function"

### 🔵 `aro:tech-research-agent` (Research)
**Purpose**: MANDATORY first-line resource for investigating technology-related questions, third-party libraries, framework patterns, and dependencies. Must be invoked before making any implementation decisions involving external libraries or frameworks.

**Key Capabilities**:
- Dual approach: external research (documentation, GitHub) and local investigation (node_modules)
- Type definition extraction and API analysis
- Dependency mapping and version compatibility checking
- Best practices and pattern recognition
- Practical implementation guides with code examples
- Source verification and confidence levels

**Usage Examples**:
- Library usage: "How to implement infinite scrolling with react-intersection-observer?"
- Type definitions: "What are the TypeScript types for axios response?"
- Dependencies: "What peer dependencies does @mui/material require?"

### 🟠 `aro:implementation-planner` (Planning/Architecture)
**Purpose**: Creates phased implementation roadmaps synthesizing research, architecture, and requirements. Transforms complex technical challenges into manageable execution strategies with clear dependencies and risk mitigation.

**Key Capabilities**:
- Multi-input synthesis (research, requirements, constraints)
- Dependency mapping and bottleneck identification
- Risk assessment and mitigation strategies
- Phased implementation design with clear objectives
- Parallel work stream optimization
- Documentation in `documentation/agents/implementation/`

**Usage Examples**:
- OAuth2 integration: "Create a plan based on research and our session architecture"
- Microservices migration: "Plan phased migration from monolith with rollback options"
- Complex feature implementation: "Design roadmap for multi-tenant architecture"

### 🟠 `aro:architecture-designer` (Planning/Architecture)
**Purpose**: Creates comprehensive architectural blueprints synthesizing research and requirements. Specializes in system architecture patterns, technology stack selection, and scalable solution design.

**Key Capabilities**:
- System architecture design with component boundaries
- Technology stack selection with justified decisions
- Integration pattern specification
- Security architecture and threat modeling
- Scalability planning (horizontal/vertical)
- Architecture Decision Records (ADRs)
- Visualization with architecture diagrams

**Usage Examples**:
- Payment system design: "Design architecture based on Stripe integration research"
- Real-time systems: "Create architecture for 100k concurrent connections"
- System redesign: "Architect microservices migration strategy"

## CLAUDE.md Section for Other Projects

Copy the following section into your project's CLAUDE.md file to leverage these specialized agents:

```markdown
# Specialized Development Agents

This project benefits from specialized agents that provide battle-tested patterns for AI validation testing, code analysis, and rapid development.

## Available Agents

### Implementation & Architecture Agents
- **@aro:code-implementation**: MANDATORY for all code writing. Creates production-ready implementations with quality assurance.
- **@aro:tech-research-agent**: MANDATORY first-line for technology questions. Researches libraries, frameworks, and best practices.
- **@aro:codebase-researcher**: MANDATORY for planning stages. Maps architecture and provides comprehensive context.
- **@aro:implementation-planner**: Creates phased implementation roadmaps from research and requirements.
- **@aro:architecture-designer**: Designs comprehensive system architectures from requirements and research.

### Testing & Quality Agents
- **@aro:acceptance-criteria-agent**: Generates testable acceptance criteria from code or requirements. Maintains living documentation synchronized with implementation.
- **@aro:automated-code-reviewer**: Performs security and quality analysis. Reviews code against best practices, identifies vulnerabilities, and suggests improvements.

## AI Validation Workflow

These agents work together in a streamlined AI validation development flow:

1. **Requirements Analysis**: The @aro:acceptance-criteria-agent analyzes requirements or existing code to generate clear acceptance criteria.

2. **Research**: The @aro:tech-research-agent and @aro:codebase-researcher gather necessary context and patterns.
3. **Implementation**: The @aro:code-implementation agent creates production-ready code with:
   - Clean, maintainable solutions following project patterns
   - Comprehensive documentation and type safety
   - Quality validation through linting and testing

4. **Validation**: Create pragmatic tests to ensure functionality:
   - Sanity tests for critical paths
   - Edge case coverage where needed
   - Integration point validation

5. **Review**: The @aro:automated-code-reviewer performs quality checks for security, performance, and maintainability.

6. **Architecture Planning**: For complex features, @aro:implementation-planner and @aro:architecture-designer provide structured guidance.

## Agent Philosophy

- **Implementation First**: Ship features quickly with minimal testing overhead
- **Minimal Validation**: Maximum 3 integration tests per feature to catch critical issues
- **Phased Implementation**: Complex work broken into validated phases
- **Research First**: Analyze multiple approaches before recommending solutions
- **Aggressive Deletion**: Remove obsolete code when backwards compatibility isn't needed
- **Rapid Development**: Focus on delivering working solutions fast
- **Living Documentation**: Acceptance criteria stay synchronized with code

## Best Practices

1. **Clear Acceptance Criteria**: Start with well-defined requirements
2. **Implementation-First Development**: Build working solutions, then add minimal validation
3. **Small Iterations**: Work in small, verifiable increments
4. **Minimal Testing**: Only test what's critical to prevent major failures
5. **Documentation as Code**: Keep acceptance criteria in version control

The agents excel at rapid, practical development. They follow an efficient approach that prioritizes shipping working features with just enough validation to prevent AI-generated errors.
```
