## Claude Code Integration

### Plan Mode Directive

**When to Suggest Plan Mode:**
Before implementing features with 2+ components, refactoring existing code, debugging complex issues, or
making architectural changes.

**MANDATORY Agent Usage in Plan Mode:**

**Research Phase (REQUIRED FIRST):**
- You MUST launch appropriate specialized agents based on the task requirements
- Check agent descriptions to identify which agents are "MANDATORY" for your task type
- If any agent description states it "must be invoked as the MANDATORY first-line resource" or similar
language, you MUST use it
- Launch multiple agents concurrently when researching different aspects of the problem
- NEVER proceed to planning without completing agent-based research

**Planning Workflow (ENFORCED ORDER):**
When I request a plan or you recognize a need for planning:

1. **Agent Research Phase** (MANDATORY)
   - Review available agent descriptions for the task at hand
   - Launch ALL relevant agents that match the task requirements
   - Prioritize agents marked as "MANDATORY" in their descriptions
   - Gather comprehensive context before planning

2. **Synthesis Phase** (MANDATORY)
   - Compile findings from all agent reports
   - Identify patterns, dependencies, and constraints
   - Document the current state comprehensively

3. **⚠️ Standards Review Gate [MANDATORY - BLOCKING] ⚠️**
   - ALWAYS invoke code-standards-reviewer agent for ALL planning tasks
   - Review compliance with project coding standards and conventions
   - Validate design patterns and architectural decisions
   - Document standards compliance and any required adjustments
   - REQUIRED for: ALL code-related planning - no exceptions

**Pre-ExitPlanMode Checklist (MANDATORY):**
Before calling ExitPlanMode, verify ALL items are complete:
□ Research agents have been invoked for the task
□ code-standards-reviewer has been invoked (REQUIRED for ANY code changes)
□ Standards compliance findings are documented in the plan
□ Plan explicitly addresses standards review recommendations

⚠️ BLOCKING: If ANY checkbox is unchecked for code-related tasks, DO NOT call ExitPlanMode

4. **Planning Phase** (MANDATORY)
   - Create implementation plan based on agent findings and standards review
   - Reference specific discoveries from agent research and standards compliance
   - Include all affected components identified by agents
   - **Production Readiness Requirements:**
     - Error handling strategies and fallback mechanisms
     - Security considerations and data protection measures
     - Performance optimization and scalability factors
     - Code maintainability and documentation standards
     - Testing approach and validation criteria
     - Integration compatibility with existing systems

4. **Implementation Phase** (AFTER PLAN APPROVAL)
   - ALWAYS use specialized agents for code generation and implementation
   - Review agent descriptions to identify which are MANDATORY for implementation tasks
   - If an agent's description indicates it handles "code writing", "implementation", or "code generation", it MUST be used
   - NEVER write code directly when specialized implementation agents are available
   - Launch implementation agents with comprehensive context from planning phase
   - Multiple implementation agents can work in parallel on different components
   - **Implementation Quality Gates:**
     - NO console.log statements in production code (use proper logging)
     - Proper TypeScript typing with no 'any' types unless absolutely necessary
     - Comprehensive error handling with meaningful error messages
     - Code must follow project linting rules and formatting standards
     - All functions and classes must have appropriate documentation
     - Security best practices must be implemented for data handling
     - Performance considerations must be addressed for critical paths

**Implementation Phase Triggers:**
When user says any of these, IMMEDIATELY enter Implementation Phase:
   - "start coding" → Begin Implementation Phase with appropriate agents
   - "write code" → Begin Implementation Phase with appropriate agents
   - "implement" / "implement this" / "implement the feature" → Begin Implementation Phase
   - "create files" / "modify files" / "update files" → Begin Implementation Phase
   - "build this" / "code this" / "develop this" → Begin Implementation Phase
   - "make the changes" / "apply the changes" → Begin Implementation Phase
   - Any variation of these phrases triggers Implementation Phase protocols

**Planning Triggers:**
- Keywords: "plan", "analyze", "think", "design", "architect", "refactor", "investigate"
- Scenarios requiring understanding of existing code, multiple file changes, or architectural decisions

**Standards Review Triggers:**

**Standards Review ALWAYS Required For:**
- ANY file changes (create/edit/delete)
- ANY code modifications (including config files, JSON, YAML)
- ANY architectural or design decisions
- API endpoint creation or modification
- Database schema changes
- Refactoring or code reorganization
- Bug fixes and configuration updates
- Dependency updates or package changes
- Build configuration changes

**Summary:** If your plan will touch ANY file, standards review is MANDATORY

**FAILURE MODE - Standards Review Violations:**
If ExitPlanMode is called without standards review for code tasks:
- The plan will be AUTOMATICALLY REJECTED
- You will be asked to explain the failure
- You must restart the entire planning process
- This is considered a CRITICAL PROCESS VIOLATION
- User trust will be damaged by this failure

**Critical Rules:**
- ALWAYS complete agent research BEFORE creating any plan
- ALWAYS use agents when their description indicates they should be used for your task
- ALWAYS respect "MANDATORY" language in agent descriptions
- NEVER skip agent research for tasks involving existing code analysis
- NEVER create plans based solely on direct file reading when agents are available
- The phrase "analyze the codebase" ALWAYS requires using appropriate research agents
- ALWAYS use specialized implementation agents when transitioning from planning to coding
- NEVER write code directly after planning - delegate to appropriate implementation agents
- **NEVER call ExitPlanMode without completing the mandatory Pre-ExitPlanMode Checklist**
- **Standards review gate cannot be bypassed for ANY code-related planning**
- **Standards-Focused Requirements:**
  - MANDATORY standards review for ALL code-related planning tasks
  - All code must meet production quality standards before approval
  - Standards compliance must be validated before implementation begins
  - Implementation agents must be provided with standards review results
  - No implementation may proceed without addressing standards compliance findings

**Format:**
- Start with parallel agent launches for efficiency
- Present agent findings before the plan
- ALWAYS include standards review results for ALL code-related plans
- Document production readiness assessment
- Provide clear handoff documentation between phases
- No implementation until plan is approved and standards compliance is verified

### Sequential Thinking Directive
MCP Server: mcp__sequential-thinking

When encountering complex, multi-step problems, use the Sequential Thinking MCP server to decompose and solve systematically.

**Activation Criteria:** Problems requiring 3+ logical steps, architectural decisions, debugging complex issues, or planning features with dependencies.

**Process:**
1. Start with `process_thought` to define the problem clearly
2. Break into atomic sub-tasks with explicit dependencies
3. Set initial `total_thoughts` estimate (adjust dynamically as needed)
4. For each thought, specify:
   - Current thinking step (`thought`)
   - Whether continuation is needed (`next_thought_needed`)
   - Mark revisions with `is_revision: true`

**Key Behaviors:**
- Branch thinking when multiple valid approaches exist
- Revise previous thoughts when new insights emerge
- Filter irrelevant information at each step
- Generate hypothesis → verify → iterate
- Use `generate_summary` at major checkpoints
- Only `clear_history` when switching problem domains

**Quality Standards:**
- Each thought addresses ONE atomic concept
- Document assumptions explicitly
- Include confidence levels for decisions
- Note why alternative paths weren't taken

Remember: The thinking process is adaptive, not linear. Question and revise freely to reach optimal solutions.

### Build Validation Directive

**MANDATORY Build Verification:**
After any code implementation or modification:

1. **Always Validate Build Completion**
   - Run the project's build command (e.g., `npm run build`, `cargo build`, `make`)
   - Check for compilation errors, type errors, or build failures
   - Verify all dependencies are correctly resolved

2. **Fix Build Issues Immediately**
   - If build fails, use appropriate sub-agents or Task tool to diagnose and fix
   - For TypeScript projects: Fix type errors, missing imports, interface mismatches
   - For compiled languages: Resolve compilation errors, linking issues
   - Never leave the project in an unbuildable state

3. **Validation Process**
   - Use specialized agents (e.g., code-implementation agent) when fixing complex build issues
   - Run linting and type-checking commands if available
   - Ensure all tests pass if test suite exists
   - Document any build configuration changes made

**Build Check Priority:**
- ALWAYS validate builds after:
  - Implementing new features
  - Refactoring existing code
  - Updating dependencies
  - Modifying configuration files
  - Any multi-file changes

**Critical Rule:** Never consider a task complete until the project builds successfully.

### Agent Context-Passing Protocol

**What is the Context-Passing Protocol:**
The Agent Context-Passing Protocol is a system for preserving and forwarding research findings, analysis results, and implementation context between specialized agents to maintain continuity and prevent information loss.

**How Context is Provided:**
Context is provided directly in agent prompts, containing complete research findings, analysis results, and implementation context from previous agents.

**Context Flow Examples:**
```
Research Phase:
codebase-researcher → Returns findings directly in response

Standards Review:
You → code-standards-reviewer with: "Research context: [codebase-researcher findings]"

Implementation:
You → code-implementation with: "Research: [codebase-researcher findings], Review: [code-standards-reviewer findings]"
```

**Critical Rule:** Context MUST flow forward - each agent needs previous findings to make informed decisions.