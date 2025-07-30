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
│   ├── acceptance-criteria-agent.md
│   ├── ai-validation-writer.md
│   ├── architecture-designer.md
│   ├── automated-code-reviewer.md
│   ├── codebase-specialist.md
│   ├── implementation-planner.md
│   └── technology-specialist.md
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

### 🟣 `acceptance-criteria-agent` (Analysis)
**Purpose**: Generates, updates, and maintains acceptance criteria documentation based on code changes. Analyzes implementations and creates structured acceptance criteria that remain synchronized with the codebase.

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

### 🟣 `automated-code-reviewer` (Analysis)
**Purpose**: Performs comprehensive code reviews beyond basic linting, analyzing security patterns, validating against documented standards, and checking for architectural compliance and performance improvements.

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

### 🔵 `codebase-specialist` (Research)
**Purpose**: Understands, navigates, and analyzes codebase architecture, relationships, and implementation details. Maps system flows, identifies dependencies, and creates persistent knowledge documentation.

**Key Capabilities**:
- Complete call trace analysis with file:line references
- Type relationship mapping and dependency graphs
- Function signature analysis with usage patterns
- Real-time code analysis using MCP/IDE tools when available
- Architectural documentation in `documentation/agents/architecture/`
- Side effect and state modification tracking

**Usage Examples**:
- Debugging: "Trace where this error originates in the codebase"
- Understanding features: "How does the payment processing work?"
- Impact analysis: "What would break if I change this API?"

### 🟢 `ai-validation-writer` (Authoring)
**Purpose**: Implements features with minimal validation testing approach. Creates implementation-first solutions with maximum 3 integration tests per feature to catch AI-generated errors while maintaining rapid development.

**Key Capabilities**:
- Implementation-first development with minimal testing overhead
- Maximum 3 integration tests per feature to validate core functionality
- Rapid feature implementation with validation gates
- Quick bug fixes with minimal test requirements
- AI-generated code validation without excessive test burden
- Focus on shipping features fast while preventing major issues

**Usage Examples**:
- Feature implementation: "Add a user profile update endpoint"
- Bug fixes: "Fix the authentication logic issues"  
- Rapid development: "Build a shopping cart feature with minimal tests"

### 🔵 `technology-specialist` (Research)
**Purpose**: Discovers production-ready integration patterns and implementation strategies used by industry leaders. Researches battle-tested solutions, analyzes engineering approaches from major tech companies, and provides proven patterns that avoid common pitfalls.

**Key Capabilities**:
- Production pattern research from tech leaders (Google, Meta, Netflix, etc.)
- Knowledge base management in `documentation/agents/technology-specialist/`
- Anti-pattern identification from post-mortems
- Trade-off analysis and selection criteria
- Security and performance consideration documentation
- File-based research sharing (never full content, always references)

**Usage Examples**:
- Library selection: "Should I use Redux or Zustand for state management?"
- Implementation strategies: "Best approaches for real-time notifications?"
- Technical challenges: "How to handle file uploads in distributed systems?"

### 🟠 `implementation-planner` (Planning/Architecture)
**Purpose**: Creates comprehensive, phased implementation plans that synthesize research findings, technical requirements, and acceptance criteria into actionable roadmaps. Transforms complex technical challenges into manageable execution strategies with clear dependencies and risk mitigation.

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

### 🟠 `architecture-designer` (Planning/Architecture)
**Purpose**: Creates comprehensive architectural blueprints that transform requirements and research into actionable system designs. Specializes in system architecture patterns, technology stack selection, and scalable solution design.

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
- **@ai-validation-writer**: Implements features with minimal validation testing. Creates implementation-first solutions with maximum 3 integration tests per feature.
- **@technology-specialist**: Researches proven patterns from industry leaders. Discovers production-ready solutions and documents them for future reference.
- **@codebase-specialist**: Maps architecture and traces code flows. Provides deep understanding of code relationships and dependencies.
- **@implementation-planner**: Creates phased implementation roadmaps from research and requirements. Synthesizes technical findings into actionable plans with clear dependencies and risk mitigation.
- **@architecture-designer**: Designs comprehensive system architectures from requirements and research. Creates blueprints with component boundaries, technology decisions, and scalability strategies.

### Testing & Quality Agents
- **@acceptance-criteria-agent**: Generates testable acceptance criteria from code or requirements. Maintains living documentation synchronized with implementation.
- **@automated-code-reviewer**: Performs security and quality analysis. Reviews code against best practices, identifies vulnerabilities, and suggests improvements.

## AI Validation Workflow

These agents work together in a streamlined AI validation development flow:

1. **Requirements Analysis**: The @acceptance-criteria-agent analyzes requirements or existing code to generate clear acceptance criteria.

2. **Implementation**: The @ai-validation-writer implements features with an implementation-first approach, focusing on:
   - Understanding requirements and building working solutions
   - Writing clean, maintainable code
   - Handling core functionality and edge cases

3. **Minimal Validation**: Create maximum 3 integration tests per feature to catch AI-generated errors:
   - Core functionality validation
   - Critical edge cases
   - Integration points

4. **Review**: The @automated-code-reviewer performs quality checks for security, performance, and maintainability.

5. **Architecture Planning**: For complex features, @implementation-planner and @architecture-designer provide structured guidance before implementation.

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
