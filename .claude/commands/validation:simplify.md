# /validation:simplify

**Purpose**: Simplify excessive test suites following minimal testing principles - test code should be 25-50% of feature code size, focusing on unique failure modes and deployment confidence rather than comprehensive QA.

## Usage
- `/validation:simplify [module/folder]` - Simplify tests for specified module
- `/validation:simplify` - Auto-detect over-tested modules and simplify

## Critical Rules
- ENFORCE test code to be 25-50% of feature code size
- ENFORCE each test validates unique failure mode
- ENFORCE one-liner rule - describe test purpose in one sentence
- ALWAYS consolidate redundant tests into data-driven tables
- ALWAYS prefer semantic validation over exact matching
- NEVER duplicate what manual testing easily catches
- ALWAYS get user approval before deleting tests
- ALWAYS verify functionality still works after simplification

## Workflow/Process

### Phase 1: Test Audit (Main Agent)
1. **Module Specification**
   - IF module provided: Target that module
   - IF no module: Scan for features with > 3 tests
   - Present findings to user

2. **Over-Testing Report**
   ```
   Test Bloat Detected:
   
   UserAuthentication: Test code is 180% of feature code
   - 5 redundant password validation tests (same failure mode)
   - 4 email format tests (easily caught manually)
   - Multiple tests that can't be described in one sentence
   
   ShoppingCart: Test code is 120% of feature code  
   - 6 granular unit tests testing implementation
   - Should be 1-2 integration tests
   
   PaymentProcessor: Test code is 250% of feature code
   - Many tests validating same failure modes
   - Excessive mocking and setup
   - Testing implementation not user outcomes
   ```

### Phase 2: Simplification Strategy (SUB-AGENT via task tool)
```
/task analyze and create simplification plan for [module]
Use @ai-validation-writer to:
- Identify unique failure modes that need testing
- Calculate target test size (25-50% of feature code)
- Plan consolidation using data-driven tables
- Ensure coverage of happy path + critical edge case + error
- Calculate line count for new test approach
- Return simplification plan
```

### Phase 3: User Approval (Main Agent)
Present plan:
```
Simplification Plan for UserAuthentication:

KEEP (Based on unique failure modes):
1. Integration test: Complete auth flow (validates happy path)
2. Data-driven test: Input validation (catches validation failures)
3. Error test: Failed auth attempts (validates security)

DELETE (Redundant or manual testing territory):
- 5 unit tests for password rules (same failure mode as test 2)
- 4 email format tests (manual testing catches these easily)  
- 3 session tests (redundant with test 1)

New structure: ~30% of auth feature code size
```

### Phase 4: Execute Simplification (SUB-AGENT via task tool)
```
/task execute test simplification for [module]
Use @ai-validation-writer to:
- Consolidate tests into maximum 3 per feature
- Use data-driven patterns
- Ensure semantic validation
- Verify all tests pass
- Report completion
```

## Simplification Patterns

### Pattern 1: Consolidate Unit Tests
**Before**: 10 unit tests
```javascript
test('validates email format')
test('rejects invalid email')
test('requires @ symbol')
test('requires domain')
// ... 6 more email tests
```

**After**: 1 data-driven test
```javascript
test('validates user input', () => {
  const cases = [
    { email: 'valid@test.com', password: 'Pass123!', valid: true },
    { email: 'invalid-email', password: 'Pass123!', valid: false },
    { email: 'test@test.com', password: 'weak', valid: false }
  ];
  
  cases.forEach(({ email, password, valid }) => {
    const result = validateUser({ email, password });
    expect(result.isValid).toBe(valid);
  });
});
```

### Pattern 2: Merge Related Tests
**Before**: 5 separate API tests
```javascript
test('GET /users returns list')
test('GET /users/:id returns user')  
test('POST /users creates user')
test('PUT /users/:id updates user')
test('DELETE /users/:id removes user')
```

**After**: 1 integration test
```javascript
test('user API crud operations', async () => {
  // Create
  const created = await api.post('/users', userData);
  expect(created.body).toMatchObject({ name: userData.name });
  
  // Read
  const fetched = await api.get(`/users/${created.body.id}`);
  expect(fetched.body.id).toBe(created.body.id);
  
  // Update
  const updated = await api.put(`/users/${created.body.id}`, { name: 'Updated' });
  expect(updated.body.name).toBe('Updated');
  
  // Delete
  await api.delete(`/users/${created.body.id}`);
  const list = await api.get('/users');
  expect(list.body).not.toContainEqual(expect.objectContaining({ id: created.body.id }));
});
```

### Pattern 3: Focus on User Outcomes
**Before**: Testing implementation details
```javascript
test('sets isLoading to true')
test('calls API with correct headers')
test('transforms response data')
test('updates cache after fetch')
test('emits change event')
```

**After**: Test user-visible behavior
```javascript
test('fetches and displays user data', async () => {
  const { getByText, queryByText } = render(<UserProfile userId="123" />);
  
  // Loading state
  expect(getByText(/loading/i)).toBeInTheDocument();
  
  // Data displayed
  await waitFor(() => {
    expect(getByText('John Doe')).toBeInTheDocument();
    expect(queryByText(/loading/i)).not.toBeInTheDocument();
  });
});
```

## Sub-Agent Instructions
When executing simplification:
1. Identify core user-facing behaviors (max 3)
2. Consolidate related tests using data tables
3. Remove unit tests covered by integration tests
4. Use semantic assertions (contains, includes, matches)
5. Aim for < 50 lines total per feature
6. Ensure tests still catch AI nonsense
7. Verify functionality after simplification

## Core Testing Philosophy
- Tests provide deployment confidence, not perfection
- Test code should be 25-50% of feature code size
- Each test must validate a unique failure mode
- Integration tests reveal more issues than unit tests
- Semantic validation survives refactoring better
- Less tests = less maintenance = faster shipping
- Manual testing complements automated tests

## Exit Codes
- 0 = Simplification completed successfully
- 1 = Some tests couldn't be simplified (manual review needed)
- 2 = User cancelled simplification
- 3 = Tests failed after simplification (rolled back)

## Example Interaction

User: `/validation:simplify`

Main Agent:
"Scanning for over-tested features...

Found 3 features with excessive test coverage:
1. UserAuth: Test code 180% of feature → reduce to ~40%
2. PaymentFlow: Test code 220% of feature → reduce to ~40%  
3. SearchEngine: Test code 150% of feature → reduce to ~40%

Potential time savings: 60-70% less test maintenance

Which features should I simplify? (all/1,2/none)"

User: "all"

[Generates and executes simplification plans for each]

## Notes
- Aggressive test reduction for maximum shipping velocity
- Focuses on shipping velocity over test coverage
- Consolidates sprawling test suites into minimal validation
- Maintains just enough testing to catch obvious breakage