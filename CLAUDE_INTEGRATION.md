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

**Planning Structure:**
When I request a plan or you recognize a need for planning:

1. **Agent Research Phase** (MANDATORY)
   - Review available agent descriptions for the task at hand
   - Launch ALL relevant agents that match the task requirements
   - Prioritize agents marked as "MANDATORY" in their descriptions
   - Gather comprehensive context before planning

2. **Synthesis Phase**
   - Compile findings from all agent reports
   - Identify patterns, dependencies, and constraints
   - Document the current state comprehensively

3. **Planning Phase**
   - Create implementation plan based on agent findings
   - Reference specific discoveries from agent research
   - Include all affected components identified by agents

4. **Implementation Phase** (AFTER PLAN APPROVAL)
   - ALWAYS use specialized agents for code generation and implementation
   - Review agent descriptions to identify which are MANDATORY for implementation tasks
   - If an agent's description indicates it handles "code writing", "implementation", or "code generation", it MUST be used
   - NEVER write code directly when specialized implementation agents are available
   - Launch implementation agents with comprehensive context from planning phase
   - Multiple implementation agents can work in parallel on different components

**Planning Triggers:**
- Keywords: "plan", "analyze", "think", "design", "architect", "refactor", "investigate"
- Scenarios requiring understanding of existing code, multiple file changes, or architectural decisions

**Critical Rules:**
- ALWAYS complete agent research BEFORE creating any plan
- ALWAYS use agents when their description indicates they should be used for your task
- ALWAYS respect "MANDATORY" language in agent descriptions
- NEVER skip agent research for tasks involving existing code analysis
- NEVER create plans based solely on direct file reading when agents are available
- The phrase "analyze the codebase" ALWAYS requires using appropriate research agents
- ALWAYS use specialized implementation agents when transitioning from planning to coding
- NEVER write code directly after planning - delegate to appropriate implementation agents

**Format:**
- Start with parallel agent launches for efficiency
- Present agent findings before the plan
- No implementation until plan is approved

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