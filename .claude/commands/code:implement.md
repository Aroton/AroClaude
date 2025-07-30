# /code:implement

**Purpose**: Research a technical challenge thoroughly and deliver an implementation plan with phased approach and minimal validation criteria for main agent execution.

## Usage
- `/code:implement` - Research and deliver implementation plan for a specified technical challenge
- `/code:implement [topic]` - Research specific topic and create phased implementation plan

## Critical Rules
- NEVER output intermediate solutions to preserve tokens
- ALWAYS analyze at least 20 different approaches internally before proposing
- ALWAYS use specialized sub-agents for each phase of the workflow
- NEVER skip the clarifying questions phase
- ALWAYS analyze existing codebase before proposing solutions
- NEVER propose without understanding the full context and constraints
- ALWAYS structure plan with clear phases and acceptance criteria
- ALWAYS include testable acceptance criteria for each phase
- NEVER implement - only deliver the plan for main agent execution
- ALWAYS format plan to facilitate TODO tool usage
- ALWAYS clarify backwards compatibility requirements explicitly
- ALWAYS recommend aggressive code deletion when backwards compatibility not needed
- ALWAYS follow minimal testing approach - test code 25-50% of feature size
- ALWAYS implement first, then add minimal validation tests
- NEVER create excessive test coverage - each test validates unique failure
- ALWAYS respect 20% time budget for testing

## Workflow/Process
1. **Clarification Phase** (use `acceptance-criteria-agent`)
   - Ask targeted questions about requirements, constraints, and goals
   - Understand performance requirements, scalability needs, and integration points
   - Identify any technical debt or migration considerations
   - Clarify success criteria and validation requirements
   - **CRITICAL: Determine backwards compatibility requirements**
   - If no backwards compatibility needed, plan for aggressive code deletion
   - Continue until all ambiguities are resolved

2. **Codebase Analysis** (use `codebase-specialist`)
   - First check `documentation/agents/codebase-specialist/` for existing analysis
   - Discover and analyze all relevant existing code
   - Map current architecture and patterns
   - Identify integration points and dependencies
   - Note existing conventions and standards
   - Document technical constraints from current implementation
   - **Analyze existing test coverage and test patterns**
   - Identify code that can be deleted if no backwards compatibility
   - Update codebase-specialist knowledge base with new findings

3. **Silent Solution Generation** (use `technology-specialist`)
   - Generate at least 20 distinct solution approaches in memory
   - Consider various architectural patterns
   - Evaluate different technology choices
   - Think through edge cases for each approach
   - Consider maintenance and scalability implications
   - Plan code organization for each approach
   - Consider how existing tests can be adapted for each approach
   - DO NOT output these to the user

4. **Solution Synthesis**
   - Analyze all generated solutions for strengths and weaknesses
   - Identify common successful patterns across solutions
   - Combine best aspects of multiple approaches
   - Eliminate approaches with critical flaws
   - Synthesize into the optimal solution
   - Ensure solution follows implementation-first approach
   - Plan for minimal validation testing (1-3 tests max per feature)

5. **Implementation Plan Generation**
   - Present the synthesized best solution with clear rationale
   - Break implementation into logical phases (3-5 phases typical)
   - For each phase, specify: organization → implementation → validation criteria
   - Include existing test analysis results for each phase
   - Include risk assessment and mitigation strategies
   - Specify testing approach emphasizing test reuse
   - Format plan for easy TODO tool conversion by main agent



## Error Handling
- If clarification reveals infeasible requirements: Propose alternatives
- If backwards compatibility unclear: Default to maintaining it
- If existing tests conflict with new requirements: Document conflicts and propose resolution
- If existing tests cannot be adapted: Justify why new tests are needed
- If codebase analysis shows blockers: Document and suggest refactoring
- If no viable solution exists: Explain constraints and suggest scope changes
- If token limit approached: Summarize findings and offer to continue

## Sub-Agent Instructions
When executing this command:
1. Use `acceptance-criteria-agent` for requirements clarification and criteria generation
2. Use `codebase-specialist` for comprehensive codebase analysis and architecture mapping
3. Use `technology-specialist` for researching solution approaches and technology choices
4. Lead the research and planning process
5. Keep all clarification context in memory during the session
6. Use efficient analysis patterns to minimize token usage
7. Keep internal deliberations truly internal
8. Present only refined, actionable output to the user
9. Always clarify backwards compatibility requirements
10. Analyze existing test coverage during codebase review
11. Plan for test reuse and updates before new test creation
12. Deliver structured implementation plan and exit
13. NOT begin implementation - that's the main agent's role
14. CRITICAL: During phase execution, MUST use codebase-specialist to find ALL existing test files before creating any new tests
15. NEVER create one-off test files - always extend existing test suites

## Implementation Plan Structure
Each plan must include:
- **Backwards Compatibility Decision**: Explicit statement on requirements
- **Phase Overview**: 3-5 distinct phases with clear boundaries
- **Phase Details**: For each phase:
  - Phase name and objective
  - Code organization plan
  - Key tasks and components
  - Existing test analysis (what can be reused/updated)
  - Acceptance criteria (specific, testable)
  - Dependencies on previous phases
  - Estimated complexity/effort
  - Code to be deleted (if no backwards compatibility)
- **Testing Strategy**: How to verify each acceptance criterion
- **Risk Mitigation**: Specific to each phase

## Main Agent Handoff
After receiving the implementation plan, the main agent will:
1. Create TODOs for each phase using the TODO tool
2. Execute phases sequentially using appropriate sub-agents
3. Add proportional validation tests after implementation (25-50% of code size)
4. Verify acceptance criteria before marking phase complete
5. Never proceed to next phase until current phase passes all tests

## Phase Implementation Methodology
Each phase execution follows minimal validation testing:
1. **Plan Code Organization** - Design file structure and module boundaries
2. **Implement Feature** - Build the complete working solution
3. **Add Validation Tests** - Proportional to feature complexity
   - Write minimum tests for deployment confidence
   - Each test validates a unique failure mode
   - Keep test code to 25-50% of feature code size
   - Spend max 20% of feature time on tests
   - Skip unit tests - integration level only
   - Use semantic validation (contains, shapes) not exact matching
4. **Delete Aggressively** - If no backwards compatibility required, remove ALL obsolete code

**CRITICAL**: Tests must exist before implementation begins. Prefer modifying existing tests over creating new ones to avoid test bloat. This approach ensures we understand current behavior before changing it and maintain a lean test suite.

## Minimal Testing Enforcement
The Implementation-First approach MUST be followed:
1. **BUILD**: Implement the complete feature based on requirements
2. **VALIDATE**: Add 1-3 integration tests to catch AI nonsense
3. **SHIP**: Deploy immediately - don't overthink testing

The ai-validation-writer agent implements features FIRST, then adds minimal validation. Keep test code to 25-50% of feature code size, spending no more than 20% of development time on tests. Each test should validate a unique failure mode that would affect users.

## Agent Coordination
- Use acceptance-criteria-agent for initial requirements (max 3 criteria per feature)
- Use codebase-specialist for thorough code analysis
- Use technology-specialist for solution research
- Use ai-validation-writer for implementation with minimal testing
- Keep clarifying questions concise and targeted
- Output only the final proposal, not the journey

## Implementation Philosophy
**Why Code Organization First**: Planning file structure before writing tests ensures:
- Clear module boundaries and responsibilities
- Easier test organization and naming
- Prevents circular dependencies
- Makes large refactors manageable
- Enables parallel development if needed

**Why Minimal Testing**: This approach ensures:
- 70% faster feature development
- Test code proportional to feature complexity (25-50%)
- Maximum 20% of dev time spent on tests
- Each test catches unique failure mode
- Manual testing complements automated tests
- Integration tests over unit tests
- Semantic validation for resilient tests

## Validation Requirements
1. Plan must address all clarified requirements
2. Backwards compatibility decision must be explicit
3. Each phase must have measurable acceptance criteria
4. Each phase must specify code organization before implementation
5. Each phase must analyze existing tests for reuse potential
6. Testing approach must prioritize updates over new tests
7. Test coverage must be efficient - no redundant tests
8. Phases must build logically on each other
9. Exit codes:
   - 0 = Complete implementation plan delivered
   - 1 = Plan delivered with caveats or risks identified
   - 2 = Unable to create viable implementation plan

## Example Interaction Pattern
User: `/code:implement authentication system upgrade`

Response:
1. "I'll research authentication system upgrades. First, let me understand your needs:
   - What authentication methods do you currently support?
   - What new capabilities are required?
   - Are there specific security standards to meet?
   - What's your user scale and performance requirements?
   - **Do we need to maintain backwards compatibility with existing auth APIs?**"

2. [After clarification] "Analyzing your existing authentication codebase and test coverage..."

3. [Silent generation of 20+ solutions]

4. [Final output] "Based on my analysis, here's the optimal approach:

   **Solution Overview**: [Architecture and approach summary]

   **Backwards Compatibility**: Not required per discussion - will delete legacy code

   **Implementation Plan**:

   **Phase 1: Core Authentication Refactor**
   - Objective: Modernize base authentication layer
   - Tasks: Extract auth logic, create new service, update interfaces
   - Code Organization: New auth/ module with service, middleware, types; tests in test/auth/
   - Backwards Compatibility: Not required - delete legacy auth code
   - Acceptance Criteria:
     * All existing auth flows work unchanged
     * New service passes 100% of existing tests
     * Performance benchmarks show <10ms overhead
   - Testing: Run full auth test suite + performance tests

   **Phase 2: Add OAuth2 Support**
   - Objective: Implement OAuth2 provider integration
   - Code Organization: auth/oauth/ subdirectory with providers, tokens, config
   - Tasks: OAuth service, provider configs, token management
   - Backwards Compatibility: Required - maintain existing JWT token format
   - Validation Strategy:
     * OAuth integration test (validates complete flow)
     * Token handling test (covers refresh + expiry)
     * Error scenarios test (invalid tokens + auth failures)
     * Target: ~40% of OAuth implementation code size
   - Acceptance Criteria:
     * Google and GitHub OAuth working end-to-end
     * Token refresh handles all edge cases
     * Security scan shows no vulnerabilities
     * Existing JWT tokens still validate correctly
   - Testing: Add validation tests (~30% of feature code size)

   **Phase 3: Migration and Rollout**
   - Objective: Safely migrate existing users
   - Code Organization: migrations/ directory with versioned scripts
   - Tasks: Migration scripts, fallback logic, monitoring
   - Backwards Compatibility: Temporary dual-mode until migration complete
   - Validation Strategy:
     * Migration flow test (success + data integrity)
     * Rollback test (failure recovery)
     * Manual testing will cover edge cases
     * Target: ~25% of migration code size
   - Acceptance Criteria:
     * Zero-downtime migration completed
     * All users can authenticate post-migration
     * Rollback tested and documented
   - Testing: Add minimal validation suite"

[Main agent takes over for implementation]

## Anti-Pattern Prevention
NEVER create test files like:
- test_feature_X.py (one-off test for single feature)
- feature_X_test.js (isolated test file)
- new_functionality_test.rb (separate test for new code)

ALWAYS update existing test files:
- tests/module_test.py (add new test cases to existing module tests)
- __tests__/module.test.js (extend existing test suite)
- spec/module_spec.rb (consolidate tests in existing spec)

Before writing ANY test:
1. Search for existing test files covering the module
2. If found, ADD test cases to existing file
3. If multiple test files exist, CONSOLIDATE them
4. Only create new test file if module has ZERO test coverage

## Notes
- This command prioritizes depth over speed
- Best for complex technical decisions requiring thorough analysis
- Efficiency achieved through specialized sub-agent delegation
- Internal solution generation ensures comprehensive coverage
- Final output is a structured plan, not an implementation
- Designed for handoff to main agent's TODO-based workflow
- Main agent manages phased implementation via specialized sub-agents
- Each phase must pass acceptance criteria before proceeding
- Implementation follows rapid build-first approach with minimal validation
- Aggressive code deletion when backwards compatibility not required
- Test reuse prioritized to maintain clean, efficient test suites
- Test consolidation prevents file proliferation and maintains clarity