# /code:fix

**Purpose**: Diagnose and fix errors or bugs through systematic analysis, root cause identification, and test-driven fixes.

## Usage
- `/code:fix` - Fix a specified error or bug with comprehensive analysis
- `/code:fix [error description]` - Fix specific error or bug with test-driven approach

## Critical Rules
- NEVER attempt fixes without understanding root cause
- ALWAYS reproduce the issue before fixing
- ALWAYS use specialized sub-agents for each phase of debugging
- NEVER skip error reproduction phase
- ALWAYS analyze related code and tests before proposing fixes
- NEVER fix symptoms - always address root causes
- ALWAYS verify fix doesn't introduce regressions
- ALWAYS write or update tests that catch the bug
- NEVER commit fixes without running full test suite
- ALWAYS document the root cause and fix rationale
- ALWAYS check for similar bugs in related code
- NEVER assume error messages tell the whole story

## Workflow/Process
1. **Error Analysis Phase** (use `codebase-specialist`)
   - Gather complete error details (message, stack trace, context)
   - Identify when error started occurring
   - Determine affected components and users
   - Check recent changes that might have introduced the bug
   - Search for related error reports or patterns
   - Document error reproduction steps

2. **Root Cause Investigation** (use `technology-specialist`)
   - Trace error through the codebase
   - Identify all code paths leading to the error
   - Analyze data flow and state changes
   - Check for race conditions or timing issues
   - Review related configuration and dependencies
   - Determine why existing tests didn't catch this
   - NEVER create debug scripts - reproduce issues through proper tests

3. **Test Creation Phase** (use `tdd-test-writer`)
   - CRITICAL: Write failing test that reproduces the bug BEFORE any fix
   - Ensure test fails for the right reason (verify error matches bug report)
   - Add edge case tests around the bug scenario
   - Update existing tests if they had wrong assumptions
   - Create regression test to prevent reoccurrence
   - Verify test coverage of affected code paths
   - Run test to confirm it fails with expected error

4. **Fix Implementation** (use `tdd-code-writer`)
   - ONLY implement fix AFTER test is failing for the right reason
   - Implement minimal fix to make tests pass (Red → Green)
   - Ensure fix addresses root cause, not symptoms
   - Maintain code style and conventions
   - Add defensive programming where appropriate
   - Update documentation if behavior changes
   - Check for similar issues in related code
   - Verify all tests pass after fix (Green state)

5. **Verification Phase** (use `automated-code-reviewer`)
   - Run all related tests
   - Execute full test suite
   - Verify no performance regressions
   - Check for security implications
   - Test edge cases and error conditions
   - Confirm fix works in different environments

## Error Categories & Strategies

### Runtime Errors
- Stack trace analysis
- State inspection at error point
- Input validation issues
- Resource management problems

### Logic Errors
- Incorrect algorithm implementation
- Off-by-one errors
- Wrong conditional logic
- Missing edge case handling

### Integration Errors
- API contract violations
- Data format mismatches
- Timing/synchronization issues
- Configuration problems

### Performance Issues
- Profile before and after
- Identify bottlenecks
- Memory leak detection
- Query optimization

## Fix Validation Checklist
- [ ] Bug is reproducible with failing test
- [ ] Root cause is identified and documented
- [ ] Fix makes the test pass
- [ ] No existing tests are broken
- [ ] Similar code paths are checked
- [ ] Performance impact is acceptable
- [ ] Security implications considered
- [ ] Documentation updated if needed
- [ ] Code follows existing patterns
- [ ] Fix is minimal and focused

## Sub-Agent Instructions
When executing this command:
1. Use `codebase-specialist` for error analysis and code exploration
2. Use `technology-specialist` for understanding root causes and patterns
3. Use `tdd-test-writer` for creating comprehensive bug reproduction tests
4. Use `tdd-code-writer` for implementing the fix
5. Use `automated-code-reviewer` for verification
6. Maintain focus on root cause, not symptoms
7. Document findings for future reference
8. Exit after delivering verified fix
9. CRITICAL: Follow strict TDD order - test MUST fail before ANY fix is written
10. NEVER write fix code until reproduction test is failing correctly
11. Use existing test files - avoid creating one-off bug test files

## Fix Documentation Template
Each fix must include:
- **Issue Summary**: Brief description of the bug
- **Root Cause**: Technical explanation of why it occurred
- **Reproduction Steps**: How to trigger the bug
- **Fix Description**: What was changed and why
- **Test Coverage**: New/updated tests that verify the fix
- **Regression Risk**: Potential side effects
- **Similar Issues**: Related code that might have same bug
- **Verification**: How fix was tested

## TDD Enforcement for Bug Fixes
The Red-Green-Refactor cycle MUST be followed:
1. **RED**: Write test that reproduces the bug (test fails)
2. **GREEN**: Write minimal fix to make test pass
3. **REFACTOR**: Improve fix while keeping tests green

NEVER skip to GREEN without RED first. The tdd-code-writer agent expects:
- A failing test that demonstrates the bug
- Clear understanding of why the test fails
- Minimal code change to make test pass

## Common Pitfalls to Avoid
- Fixing symptoms instead of root causes
- Making changes without reproduction test
- Writing fix before test fails (violates TDD)
- Assuming first theory is correct
- Ignoring edge cases in fix
- Not checking for similar bugs
- Breaking existing functionality
- Over-engineering the solution
- Ignoring performance impact
- Missing security implications
- Creating one-off test files for bug fixes

## Exit Codes
- 0 = Bug fixed and verified
- 1 = Bug fixed with warnings or caveats
- 2 = Unable to fix bug (blocked by external factors)
- 3 = Bug is actually intended behavior

## Example Interaction Pattern
User: `/code:fix TypeError: Cannot read property 'name' of undefined in UserProfile component`

Response:
1. "I'll investigate this TypeError in the UserProfile component. Let me start by analyzing the error..."

2. [Analyzes code, finds root cause in data loading race condition]

3. "Found the issue: The UserProfile component tries to access user.name before the data is loaded. Here's my fix:

   **Root Cause**: Missing loading state check allows component to render before user data is available
   
   **Test Added**: 
   - Test component renders loading state when user is undefined
   - Test component handles null user gracefully
   - Test loading → loaded transition
   
   **Fix Applied**:
   - Added loading state check before accessing user properties
   - Added optional chaining as defensive programming
   - Updated prop types to reflect nullable user
   
   **Verification**:
   - All tests passing
   - Manual testing confirms fix
   - No performance impact
   - Similar issue found and fixed in UserSettings component"

[Fix delivered and verified]

## Notes
- Focuses on systematic debugging over quick fixes
- Emphasizes test-driven bug fixing
- Ensures bugs don't reoccur through regression tests
- Documents fixes for team learning
- Checks for similar issues proactively
- Prioritizes code quality and maintainability