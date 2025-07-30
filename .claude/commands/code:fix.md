# /code:fix

**Purpose**: Diagnose and fix errors or bugs through systematic analysis, root cause identification, and minimal validation testing.

## Usage
- `/code:fix` - Fix a specified error or bug with comprehensive analysis
- `/code:fix [error description]` - Fix specific error or bug with minimal validation

## Critical Rules
- NEVER attempt fixes without understanding root cause
- ALWAYS reproduce the issue before fixing
- ALWAYS use specialized sub-agents for each phase of debugging
- NEVER skip error reproduction phase
- ALWAYS analyze related code and tests before proposing fixes
- NEVER fix symptoms - always address root causes
- ALWAYS verify fix doesn't introduce regressions
- ALWAYS add minimal validation test if none exists (max 1 test)
- NEVER write more than 1 test for a bug fix
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

3. **Fix Implementation** (use `ai-validation-writer`)
   - Implement the fix based on root cause analysis
   - Focus on fixing the actual problem, not symptoms
   - Maintain code style and conventions
   - Add defensive programming where appropriate
   - Update documentation if behavior changes
   - Check for similar issues in related code

4. **Validation Test** (use `ai-validation-writer`)
   - Add ONE integration test that verifies the fix works
   - Test should prevent regression of this specific bug
   - Use semantic validation (contains, shapes) not exact matching
   - Keep test under 20 lines of code
   - Skip if existing tests already cover this scenario

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
- [ ] Bug is fixed and working
- [ ] Root cause is identified and documented
- [ ] Added 1 validation test (if needed)
- [ ] No existing functionality broken
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
3. Use `ai-validation-writer` for implementing the fix and adding validation
4. Use `automated-code-reviewer` for verification
5. Maintain focus on root cause, not symptoms
6. Document findings for future reference
7. Exit after delivering verified fix
8. Add maximum 1 validation test per bug fix
9. Use existing test files - avoid creating one-off bug test files

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

## AI Validation for Bug Fixes
The Fix-First approach MUST be followed:
1. **FIX**: Implement the bug fix based on root cause
2. **VALIDATE**: Add 1 test to prevent regression (if needed)
3. **SHIP**: Deploy the fix immediately

The ai-validation-writer agent focuses on:
- Fixing the actual problem quickly
- Adding minimal validation (1 test max)
- Shipping fixes fast

## Common Pitfalls to Avoid
- Fixing symptoms instead of root causes
- Adding more than 1 test for a bug fix
- Over-testing simple fixes
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
   
   **Validation Added**: 
   - 1 integration test verifying component handles undefined user
   
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
- Emphasizes quick fixes with minimal validation
- Ensures bugs don't reoccur through 1 targeted test
- Documents fixes for team learning
- Checks for similar issues proactively
- Prioritizes code quality and maintainability