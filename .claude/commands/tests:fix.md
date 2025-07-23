# /tests:fix

**Purpose**: Automatically fix failing tests by analyzing failures and repairing either test code or implementation code to meet acceptance criteria.

**Execution Type**: ORCHESTRATED - Main agent identifies failing tests, delegates fixing to parallel sub-agents

## Usage
- `/tests:fix` - Fix all failing tests in project
- `/tests:fix [test-pattern]` - Fix specific test files matching pattern
- `/tests:fix --focus [test-name]` - Fix specific test by name
- `/tests:fix --acceptance "criteria"` - Fix with custom acceptance criteria

## Critical Rules
- NEVER modify test intent without explicit acceptance criteria
- ALWAYS verify fixes don't break other tests
- Maximum 5 fix attempts per test before marking as needs-manual-review
- Run up to 10 parallel sub-agents for faster processing
- Focus on correctness over speed

## Main Agent Workflow

### Step 1: Discover Failing Tests
1. Run test suite to identify all failures
2. Parse test output to extract:
   - Test file paths
   - Test names
   - Error messages
   - Stack traces
3. Group related tests (same file) into batches
4. Maximum 3 tests per batch for focused analysis

### Step 2: Delegate Test Fix Batches
Launch up to 10 parallel sub-agents:
1. For each batch, use Task tool with prompt:
   ```
   Fix failing tests:
   Tests:
   - Test 1: [file-path] - [test-name]
     Error: [error-message]
   - Test 2: [file-path] - [test-name]
     Error: [error-message]

   Acceptance criteria: [criteria if provided]

   For each test:
   1. Analyze failure reason
   2. Determine fix strategy (test or implementation)
   3. Apply fix (up to 5 attempts)
   4. Verify fix works

   Report: Which tests fixed, which need manual review
   ```
2. Monitor sub-agent completion
3. Collect results from all sub-agents

### Step 3: Final Validation
After all sub-agents complete:
1. Run full test suite again
2. Verify targeted tests now pass
3. Check for any new failures introduced
4. Generate final summary report

## Sub-Agent Instructions

**You are fixing a specific batch of failing tests.**

### Fix Strategy Decision Tree
1. **Analyze failure type**:
   - Assertion failure → Check if implementation matches intended behavior
   - Type error → Fix type definitions or implementations
   - Missing functionality → Implement required feature
   - Timeout → Optimize code or increase timeout
   - Import error → Fix module paths or missing dependencies

2. **Determine what to fix**:
   - If implementation clearly wrong → Fix implementation
   - If test expects outdated behavior → Update test
   - If acceptance criteria provided → Follow those
   - If ambiguous → Analyze test name/description for intent

3. **Apply fix process**:
   - Run the specific test to confirm failure
   - Read relevant test and implementation files
   - Make targeted fix using appropriate tool
   - Run test again to verify fix
   - If still failing after 5 attempts, document why

### Verification Steps
- After each fix, run that specific test
- Before completing batch, run all tests in affected files
- Ensure no regression in other tests

### Report Format
Return clear summary:
```
Batch Results:
✅ Fixed:
- test-file.spec.ts::test-name (fixed implementation: added null check)
- another-test.ts::test-case (fixed test: updated expected value)

❌ Need Manual Review:
- complex-test.ts::edge-case (tried 5 times: circular dependency issue)
```

## Error Handling
- **Test framework not detected**: Try common commands (npm test, pytest, jest, vitest)
- **Flaky tests**: Run 3 times to confirm consistent failure before fixing
- **Import/Module errors**: Check and fix paths, install missing dependencies
- **Timeout errors**: Try increasing timeout before changing logic

## Default Acceptance Criteria
Unless specified otherwise:
- Tests should accurately reflect their descriptive names
- Implementation should handle all tested edge cases
- No runtime errors or unhandled exceptions
- Type safety should be maintained
- Follow existing code patterns in the project

## Examples

### Example 1: Simple assertion fix
```
Test: "should return user name"
Failure: Expected "John Doe" but got undefined
Fix: Implementation missing return statement
```

### Example 2: Type error fix
```
Test: "should accept number array"
Failure: Type 'string[]' is not assignable to type 'number[]'
Fix: Update function parameter type to accept string[]
```

### Example 3: Behavioral change
```
Test: "should throw error for invalid input"
Failure: No error thrown
Fix: Add validation and throw appropriate error