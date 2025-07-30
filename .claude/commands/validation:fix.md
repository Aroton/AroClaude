# /validation:fix

**Purpose**: Fix failing validation tests by analyzing failures and repairing implementation code to meet minimal acceptance criteria. Follows the principle that tests provide deployment confidence through validating unique failure modes, not comprehensive QA.

**Execution Type**: ORCHESTRATED - Main agent identifies failing tests, delegates fixing to parallel sub-agents

## Usage
- `/validation:fix` - Fix all failing validation tests in project
- `/validation:fix [test-pattern]` - Fix specific test files matching pattern
- `/validation:fix --focus [test-name]` - Fix specific test by name

## Critical Rules
- FOCUS on fixing implementation, not tests (tests validate deployment readiness)
- NEVER add more tests while fixing - keep test suite proportional
- ALWAYS verify fixes don't break other functionality
- Maximum 3 fix attempts per test before marking as needs-manual-review
- Run up to 10 parallel sub-agents for faster processing
- If test code > 50% of feature code, flag for simplification

## Main Agent Workflow

### Step 1: Discover Failing Tests
1. Run test suite to identify validation failures
2. Parse test output to extract:
   - Test file paths
   - Test names
   - Error messages
   - Stack traces
3. Group related tests (same feature) into batches
4. Flag any features where test code exceeds feature code size

### Step 2: Delegate Fix Batches
Launch up to 10 parallel sub-agents:
1. For each batch, use Task tool with prompt:
   ```
   Fix failing validation tests:
   Tests:
   - Test 1: [file-path] - [test-name]
     Error: [error-message]
   - Test 2: [file-path] - [test-name]
     Error: [error-message]

   Validation Rules:
   - Fix implementation only (tests are correct)
   - Maximum 3 attempts per test
   - Focus on making feature work, not perfect
   - Remember: tests catch AI nonsense, not edge cases

   For each test:
   1. Analyze what the test validates
   2. Fix implementation using `@ai-validation-writer`
   3. Verify fix works
   4. If test seems excessive, note for simplification

   Report: Which tests fixed, which need manual review
   ```
2. Monitor sub-agent completion
3. Collect results from all sub-agents

### Step 3: Final Validation
After all sub-agents complete:
1. Run test suite again
2. Verify targeted tests now pass
3. Check no new failures introduced
4. Flag any features with excessive tests (> 3)
5. Generate final summary report

## Sub-Agent Instructions

**You are fixing implementation to pass validation tests.**

### Fix Strategy (Minimal Validation Approach)
1. **Understand test intent**:
   - What user-visible behavior is being validated?
   - Is this catching potential AI nonsense?
   - Could this be tested more simply?

2. **Fix implementation only**:
   - Tests are validation gates - assume they're correct
   - Use `@ai-validation-writer` to fix implementation
   - Focus on making the feature work
   - Don't over-engineer the solution

3. **Apply fix process**:
   - Run the specific test to confirm failure
   - Read implementation code
   - Make targeted fix to pass the test
   - Run test again to verify fix
   - If still failing after 3 attempts, document why

### Validation Checks
- After fix, run that specific test
- Ensure no regression in other tests
- Check if feature now has > 3 tests (flag for consolidation)

### Report Format
Return clear summary:
```
Batch Results:
✅ Fixed:
- user-api.test.ts::creates-user (fixed: added validation logic)
- cart.test.ts::handles-empty-cart (fixed: null check added)

⚠️ Excessive Testing Detected:
- product-search test code is 150% of feature code size

❌ Need Manual Review:
- payment.test.ts::processes-refund (tried 3 times: external API issue)
```

## Error Handling
- **Test framework not detected**: Try common commands (npm test, pytest, jest, vitest)
- **Complex test setup**: This might indicate over-testing - flag for simplification
- **Flaky tests**: Run 3 times to confirm consistent failure
- **Timeout errors**: Feature might be too complex - consider simplification

## Core Testing Philosophy
Remember:
- Tests exist for deployment confidence, not perfection
- Test code should be 25-50% of feature code size
- Each test validates a unique failure mode
- Integration tests over unit tests
- Semantic validation over exact matching
- Ship fast with minimal overhead
- Manual testing covers what automated tests don't

## Examples

### Example 1: Simple validation fix
```
Test: "API returns user data"
Failure: Expected response to contain "id"
Fix: Add id field to response object
Note: This is good validation - catches if AI forgets required fields
```

### Example 2: Over-tested feature
```
Feature: User login
Tests found: 12 tests covering every edge case
Action: Fix implementation for the 3 most important tests
Flag: Feature needs test consolidation to 3 tests max
```

### Example 3: Integration test fix
```
Test: "Shopping cart checkout flow"
Failure: Total calculation incorrect
Fix: Fix calculation logic in checkout service
Note: Good integration test - validates entire flow works
```

## Notes
- Focuses on fixing implementation to pass validation tests
- Enforces proportional testing (test code < 50% of feature code)
- Identifies over-tested features for simplification
- Prioritizes shipping working code over perfect code