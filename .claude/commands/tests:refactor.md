# /tests:refactor

**Purpose**: Analyze tests against code/criteria, generate updated acceptance criteria, and refactor tests to align with those criteria through phased execution.

## Usage
- `/tests:refactor [module/folder]` - Refactor tests for specified module to align with generated acceptance criteria
- `/tests:refactor` - Auto-detect changes by comparing current branch to main and refactor affected modules

## Critical Rules
- IF no module specified: Compare current branch to main to identify changed modules
- ALWAYS require specific scope - either user-provided or auto-detected from git diff
- NEVER allow full codebase scan without change detection
- ALWAYS gather all context before starting task tool execution
- ALWAYS get user approval for generated acceptance criteria
- ALWAYS save approved criteria to `/documentation/acceptance-criteria/[module]/[criteria-set-name].md`
- ALWAYS create TODOs for each refactoring phase
- ALWAYS complete each phase before proceeding to next
- ALWAYS prioritize test readability over reusability
- NEVER consolidate tests if it reduces clarity
- ALWAYS maintain one clear test per distinct situation
- NEVER start task tool execution without complete context
- ALWAYS fix code bugs discovered during test refactoring
- ALWAYS return to main agent if questions arise during execution

## Workflow/Process

### Phase 1: Context Gathering (Main Agent)
1. **Module Specification**
   - IF module/folder provided: Confirm target module/folder path
   - IF no module provided: Run `git diff main...HEAD --name-only` to detect changed files
     - Extract module/folder patterns from changed files
     - Present detected modules to user for confirmation
     - Allow user to select specific modules or include all detected
   - Validate module exists and contains tests
   - Identify test file patterns and structure

2. **Source Selection**
   - Ask user: "What should I analyze to generate acceptance criteria?
     1. Existing acceptance criteria documents (provide paths)
     2. Current code implementation (provide paths)
     3. Both criteria docs and code files"
   - Collect all specified file paths
   - Validate files exist and are accessible

3. **Analysis Parameters**
   - Ask for criteria set name (for documentation)
   - Confirm test framework and conventions
   - Identify any specific concerns or focus areas
   - Determine if backwards compatibility is needed

### Phase 2: Analysis and Criteria Generation (SUB-AGENT via task tool)
```
/task analyze tests and generate acceptance criteria for [module]
Use @acceptance-criteria-agent to:
- Analyze existing tests for current behavior coverage
- Parse provided criteria docs and/or code files
- Identify gaps between tests and actual functionality
- Detect duplicate or overlapping test coverage
- Generate comprehensive acceptance criteria
- Return findings and proposed criteria
```

### Phase 3: Criteria Approval (Main Agent)
1. **Present Generated Criteria**
   ```
   Generated Acceptance Criteria for [module]:

   Feature: User Authentication

   AC-1: Users can register with email and password
   - Email must be valid format
   - Password must meet security requirements
   - Duplicate emails are rejected

   AC-2: Users can log in with credentials
   - Valid credentials grant access
   - Invalid credentials are rejected
   - Failed attempts are rate limited

   [Continue with all criteria...]
   ```

2. **Get User Feedback**
   - "Do these criteria accurately reflect the desired behavior?"
   - Allow user to request modifications
   - Iterate until user approves

3. **Save Approved Criteria**
   - Create `/documentation/acceptance-criteria/[module]/[criteria-set-name].md`
   - Format with clear structure and traceability

### Phase 4: Test Refactoring Plan (SUB-AGENT via task tool)
```
/task create test refactoring plan for [module] using approved criteria
Use @tdd-test-writer to:
- Map each existing test to new acceptance criteria
- Identify tests that need updates
- Find redundant tests to remove
- Determine missing test cases
- Create phased execution plan
- Return structured plan for TODO creation
```

### Phase 5: Plan Review and TODO Creation (Main Agent)
1. **Present Refactoring Plan**
   ```
   Test Refactoring Plan for [module]:

   Phase 1: Remove Redundant Tests
   - DELETE: 5 duplicate login tests
   - DELETE: 3 obsolete validation tests
   - Keeps the clearest test for each behavior

   Phase 2: Update Existing Tests & Fix Code Bugs
   - UPDATE: user_registration_test.js to match AC-1
   - FIX CODE: Email validation regex doesn't match criteria
   - UPDATE: login_test.js to cover all AC-2 cases
   - FIX CODE: Session timeout is 60min, should be 30min
   - ADD: Rate limiting assertions to security_test.js

   Phase 3: Add Missing Coverage
   - CREATE: Test for password complexity (AC-1.2)
   - CREATE: Test for session timeout (AC-3.4)
   ```

2. **Create TODOs**
   ```
   /todo create "Phase 1: Remove redundant tests in [module]"
   /todo create "Phase 2: Update existing tests for [module] criteria"
   /todo create "Phase 3: Add missing test coverage for [module]"
   ```

### Phase 6: Phased Execution (SUB-AGENT via task tool)
For each TODO/phase:
```
/task execute test refactoring phase N for [module]
Use @tdd-test-writer to:
- Load specific phase requirements
- Execute test changes with clear, readable patterns
- Verify tests pass after changes
- Report completion status
```

## Handling Code Bugs During Refactoring
When refactoring tests reveals bugs in the implementation:

1. **Bug Discovery**
   - Test refactoring exposes code that doesn't match acceptance criteria
   - Existing tests were masking incorrect behavior
   - New test assertions fail due to code bugs

2. **Fix Code Alongside Tests**
   ```
   Example: Test reveals authentication timeout is 60min instead of required 30min
   - FIX: Update SessionManager timeout to 30 minutes
   - UPDATE: Test to assert correct 30-minute timeout
   - VERIFY: All related tests still pass
   ```

3. **Document Code Changes**
   - Include code fixes in phase completion report
   - Note which acceptance criteria drove the fix
   - Ensure code changes are minimal and focused

## Sub-Agent Question Handling
If the sub-agent encounters ambiguity during execution:

1. **Sub-Agent Returns Control**
   ```
   Exit code: 4 (Questions needed)
   Return payload: {
     "status": "questions_needed",
     "completed_work": "Description of what was done",
     "questions": [
       "Should the timeout be configurable or hard-coded to 30 minutes?",
       "The existing test expects X but criteria says Y - which is correct?"
     ],
     "context": "Additional context for decision making"
   }
   ```

2. **Main Agent Handles Questions**
   - Present questions to user with context
   - Gather answers and additional clarification
   - Store answers for sub-agent continuation

3. **Resume Execution**
   ```
   /task continue test refactoring phase N for [module] with answers
   - Resume from saved state
   - Apply user's answers to pending decisions
   - Complete the phase execution
   ```

4. **Question Examples**
   - "Existing code allows null values but criteria doesn't mention this - should nulls be allowed?"
   - "Found deprecated API usage in code - update to new API or maintain compatibility?"
   - "Test name suggests behavior X but it actually tests Y - which should it test?"

## Acceptance Criteria Document Format
```markdown
# Acceptance Criteria: [Module Name]
Generated: [Date]
Source: [Code analysis | Existing criteria | Both]

## Overview
Brief description of module functionality and testing goals.

## Criteria

### Feature: [Feature Name]

#### AC-[ID]: [Clear behavior description]
**Given**: Initial state/context
**When**: Action taken
**Then**: Expected outcome

Test Coverage:
- ✓ Covered by: `test_file.js::test_name`
- ✗ Missing: [Description of gap]

---

### Feature: [Next Feature]
...
```

## Test Refactoring Philosophy
When refactoring tests:

1. **Clarity Over DRY**
   ```javascript
   // PREFERRED: Clear, self-contained test
   test('user can login with valid credentials', () => {
     const user = createUser('test@example.com', 'password123');
     const result = login('test@example.com', 'password123');
     expect(result.success).toBe(true);
     expect(result.user.email).toBe('test@example.com');
   });

   // AVOID: Overly abstracted helper
   testSuccessfulLogin(userData, expectedResult);
   ```

2. **One Test Per Situation**
   - Each test should verify ONE specific behavior
   - Test name must clearly describe what is being tested
   - Avoid parameterized tests if they obscure intent

3. **Descriptive Over Concise**
   - Long, clear test names are preferred
   - Explicit assertions over clever abstractions
   - Comments when business logic isn't obvious

## Error Handling
- If module path invalid: Prompt for correct path
- If no tests found: Ask if user wants to create initial tests
- If criteria generation fails: Provide partial results and options
- If test execution fails: Rollback changes and report issues
- If user rejects criteria: Return to analysis with feedback

## Token Optimization
- Use task tool for all heavy analysis
- Batch file operations in task tool
- Keep main agent interactions focused
- Summarize findings rather than listing all details
- Store detailed mappings in task tool memory

## Integration with SDLC
This command fits into the workflow as a test maintenance tool:

1. **Post-Implementation Test Alignment**
   ```
   /task implement new feature
   /tests:refactor features/new-feature
   ```

2. **Pre-Refactor Test Baseline**
   ```
   /tests:refactor payments/  # Establish clear criteria
   /research-implement payment system upgrade
   ```

3. **Test Debt Reduction**
   ```
   /tests:refactor legacy-module/  # Clean up old tests
   ```

## Sub-Agent Instructions
Task tool sub-agents should:
1. Use `@acceptance-criteria-agent` for all requirements analysis and criteria generation
2. Use `@tdd-test-writer` for all test planning and refactoring execution
3. During analysis: Build complete test-to-behavior mappings
4. During planning: Create detailed but executable steps
5. During execution: Make tests as readable as possible
6. Always preserve valuable edge case tests
7. Never sacrifice clarity for brevity
8. Ensure each test tells a story about the behavior
9. Fix code bugs when tests reveal implementation doesn't match criteria
10. Return control with exit code 4 if questions arise:
    - Ambiguous acceptance criteria interpretation
    - Code behavior conflicts with test expectations
    - Unclear whether to maintain backwards compatibility
    - Design decisions needed for fixes
11. Save state before returning to enable continuation
12. Never make assumptions - ask when uncertain

## Exit Codes
- 0 = Test refactoring completed successfully
- 1 = Completed with warnings (some tests may need manual review)
- 2 = Failed to complete refactoring
- 3 = User cancelled during criteria approval
- 4 = Questions needed - sub-agent returning control to main agent

## Example Interaction Patterns

### Pattern 1: Specific Module
User: `/tests:refactor auth/`

Main Agent:
"I'll help you refactor the tests for the auth/ module. First, I need to understand what to analyze.

What should I analyze to generate acceptance criteria?
1. Existing acceptance criteria documents (provide paths)
2. Current code implementation (provide paths)
3. Both criteria docs and code files

Please specify your choice and the relevant file paths."

User: "2. Analyze auth/services/oauth.js and auth/middleware/session.js"

Main Agent:
"Great! I'll analyze those implementation files.
- What should I name this criteria set? (e.g., 'oauth-session-criteria')
- Are there any specific behaviors or edge cases I should focus on?
- Do we need to maintain backwards compatibility?"

User: "Name it 'oauth-2025-criteria'. Focus on security edge cases. No backwards compatibility needed."

Main Agent:
"Perfect. I'll now analyze the auth module tests and implementation to generate acceptance criteria focused on security edge cases."

[Task tool analyzes and returns criteria]

Main Agent:
"Here are the generated acceptance criteria for your review:

## Feature: OAuth Authentication

### AC-1: OAuth Token Exchange
**Given**: A valid OAuth authorization code
**When**: Code is exchanged for tokens
**Then**: System returns access and refresh tokens with proper expiry

### AC-2: Token Security Validation
**Given**: An incoming access token
**When**: Token is validated
**Then**: System verifies signature, expiry, and scope claims

[... more criteria ...]

Do these criteria accurately capture the security behaviors you want to test?"

User: "Yes, but add criteria for concurrent token refresh handling"

[Main Agent updates criteria and saves to documentation]

Main Agent:
"I've saved the approved criteria to `/documentation/acceptance-criteria/auth/oauth-2025-criteria.md`

Now I'll analyze how to refactor the existing tests to align with these criteria."

[Task tool creates refactoring plan]

Main Agent:
"Here's the test refactoring plan:

**Phase 1: Remove Redundant Security Tests**
- DELETE: 3 duplicate token validation tests
- These all test the same behavior with slight variations

**Phase 2: Update Existing Tests for Clear Behavior Mapping**
- UPDATE: oauth_test.js - Add explicit token expiry assertions
- UPDATE: session_test.js - Test concurrent refresh scenario
- Each test will map to exactly one acceptance criterion

**Phase 3: Add Missing Security Coverage**
- CREATE: Test for malformed token handling
- CREATE: Test for replay attack prevention

Shall I create TODOs for these phases and begin execution?"

[After confirmation, creates TODOs and executes each phase via task tool]

## Example: Handling Questions During Execution

User: `/task execute test refactoring phase 2 for auth/`

Sub-Agent: [Returns with exit code 4]

Main Agent:
"The test refactoring encountered some questions that need your input:

1. **Session Timeout Discrepancy**
   - The acceptance criteria specify 30-minute timeout
   - Current code implements 60-minute timeout
   - Existing tests expect 60 minutes

   Should I fix the code to match the 30-minute requirement, or update the criteria?

2. **Null Email Handling**
   - Current code allows null email for anonymous sessions
   - Acceptance criteria don't mention this case
   - 3 tests rely on this behavior

   Should null emails be allowed for anonymous sessions?"

User: "1. Fix the code to 30 minutes. 2. Yes, allow null emails for anonymous sessions - update the criteria"

Main Agent:
"Got it. I'll continue the refactoring with:
- Fix code to implement 30-minute timeout
- Update criteria to include null email handling for anonymous sessions
- Update relevant tests accordingly"

`/task continue test refactoring phase 2 for auth/ with answers`

[Sub-agent resumes with provided answers]

### Pattern 2: Auto-Detection from Git Changes
User: `/tests:refactor`

Main Agent:
"I'll analyze the current branch changes to identify modules that need test refactoring.

Comparing current branch to main..."
[Runs git diff main...HEAD --name-only]

"I found changes in these modules:
1. auth/ (3 files changed: oauth.js, session.js, middleware.js)
2. payments/ (2 files changed: stripe.js, validation.js)
3. notifications/ (1 file changed: email.js)

Which modules would you like to refactor tests for?
- Type 'all' to refactor all detected modules
- Type module numbers: '1,3' to refactor auth/ and notifications/
- Type specific paths: 'auth/oauth payments/stripe' for granular control"

User: "1,2"

Main Agent:
"Perfect! I'll refactor tests for auth/ and payments/ modules.

For each module, what should I analyze to generate acceptance criteria?
1. Existing acceptance criteria documents (provide paths)
2. Current code implementation (provide paths)  
3. Both criteria docs and code files"

[Continues with normal workflow for each selected module]

## Notes
- Balances automation with user control at critical decision points
- Enforces module-scoped work to prevent context overflow, with auto-detection for convenience
- Creates audit trail via saved acceptance criteria
- Supports our "test readability over DRY" philosophy
- Integrates smoothly with existing TODO-based workflow
- Auto-detects changes to focus refactoring efforts on modified code