# AI Validation Testing Framework

## Core Philosophy

**Tests are AI validation gates, not comprehensive QA**

This framework treats tests as guardrails to prevent AI-generated nonsense, not as traditional quality assurance. Since manual testing covers actual quality, automated tests focus solely on catching when AI agents generate broken or nonsensical code.

## Primary Goals

1. **Validate AI Understanding**: Ensure the AI correctly interpreted requirements
2. **Catch Obvious Breakage**: Detect when generated code fundamentally doesn't work
3. **Maximize Shipping Velocity**: Spend minimal time on test overhead
4. **Prevent Gibberish**: Stop AI hallucinations from making it into the codebase

## The Manual Testing Context

Since all features undergo manual testing by the developer, automated tests should only cover:
- Things tedious to test manually
- Easy-to-break functionality
- Critical user workflows
- AI validation checkpoints

Everything else will be caught during manual testing, so don't duplicate that effort in automated tests.

## What TO Test

### Integration Over Isolation
- **One test per feature** that exercises the entire flow
- **API/Route level testing** that validates end-to-end functionality
- **Data-driven tests** with input/output examples at the highest level possible
- **Happy path validation** that confirms basic functionality works
- **Smoke tests** that fail loudly when core assumptions break

### Test Characteristics
- Tests should run in < 1 second
- Each test exercises multiple code paths
- Tests use real-world data examples
- Tests validate user outcomes, not implementation details
- Write minimum tests for confidence in deployment
- Test suite proportionally smaller than feature code

## What NOT to Test

### Skip These Categories Entirely
- ❌ Performance testing
- ❌ Individual CRUD operations
- ❌ UI component internals
- ❌ Getter/setter methods
- ❌ Framework-generated code
- ❌ Mock-heavy unit tests
- ❌ Implementation details

### Anti-Patterns to Avoid
- Writing 30 tests when 3 would suffice
- Testing every class and function individually
- Creating elaborate mock setups
- Writing tests that mirror the implementation
- Spending more time on tests than features

## Implementation Strategy

### Test Structure
```
Feature X:
├── 1 integration test (happy path)
├── Edge case tests (only for distinct failure modes)
└── Error handling tests (only if user-facing)
```

### Data-Driven Approach
- Use test tables with input/expected output pairs
- Cover normal, edge, and error cases in ONE test function
- Prefer "contains" checks over exact matching
- Validate data shapes, not specific values

### Web App Testing
- Make HTTP requests to endpoints
- Send realistic data
- Verify response contains expected data
- Confirm critical side effects occurred

### MCP Server Testing
- Send various message types
- Verify correct responses
- Use input/output test tables
- Cover multiple scenarios in single test

## Key Principles

### Intent-Based Testing Limits

Instead of hard numbers, use these guidelines:

**Coverage-Based Guidance**
- Write the minimum tests needed to validate the happy path works, critical business rules are enforced, and error states are handled
- Stop when these are covered

**Time-Proportional Rule**
- Spend no more than 20% of feature development time on tests
- If a feature takes 1 hour to build, tests should take ~10-15 minutes to write

**The One-Liner Rule**
- If you can't describe what the test validates in one sentence, it's too granular
- Each test should validate a complete user story or use case

**Value-Based Criteria**
Only write tests that would:
- Prevent a user-visible bug
- Catch a breaking API change
- Validate critical business logic
- Ensure data integrity

**Duplicate Detection Principle**
- Before writing a test, ask: "Would this fail for a different reason than existing tests?"
- Each test should catch a unique category of failure

**Proportional Code Size**
- Test code should be 25-50% the size of feature code
- If tests are longer than implementation, you're testing too much

### Context-Aware Guidelines

**Simple Features**: One test that exercises the complete flow
**Complex Features**: Multiple tests, each validating a different aspect
**Critical Features**: More thorough testing of scenarios, not code coverage

### The Confidence Test
"Tests should give you confidence to deploy without manual verification. Write exactly enough tests to achieve that confidence - no more, no less."

### The Instant Feedback Rule
Tests must run instantly - no network calls, no heavy computation.

### The Semantic Validation Rule
Test behavior and outcomes, not exact implementations.

## Self-Healing Test Patterns

### Resilient Assertions
- Use semantic checks, not string matching
- Verify data shapes, not exact values
- Check for key presence, not specific IDs
- Use "contains" instead of "equals" for dynamic content

### Future-Proof Design
- Tests survive minor UI/API changes
- Focus on contract, not implementation
- Validate critical business logic only
- Avoid brittle selectors and locators

## Decision Framework

When the AI agent considers writing a test, it should ask:

1. **Does this test validate a unique failure mode?**
   - If yes, consider writing it
   - If no, existing tests already cover it

2. **Would this test prevent a user-visible bug?**
   - If yes, definitely write it
   - If no, probably skip it

3. **Can I describe this test's purpose in one sentence?**
   - If yes, it's appropriately scoped
   - If no, it's probably too granular

4. **Is this testing behavior or implementation?**
   - Behavior: Write the test
   - Implementation: Skip it

5. **Would I need to manually verify this anyway?**
   - If yes, consider automating it
   - If no, manual testing will catch it

## Test Scoping by Feature Type

### Simple CRUD Feature
"A simple CRUD endpoint needs one test that creates, reads, and validates. Don't test each operation separately."

### Complex Algorithm
"Complex features may need tests for:
- Core algorithm correctness
- Edge case handling
- Integration points
Each test should fail for a different reason."

### Critical System (Payment/Auth)
"Even critical features focus on scenarios not coverage:
- Valid payment processes correctly
- Invalid payment fails gracefully
- Auth tokens are validated
Not every method and branch."

## Example Test Scope

### Good Test
"When a user submits a contact form, they receive a confirmation and the message is stored"
- Tests actual user outcome
- Validates core functionality
- Would catch major breakage

### Bad Test
"The ContactForm component renders with correct CSS classes"
- Tests implementation detail
- Doesn't validate functionality
- Wouldn't catch real bugs

## Success Metrics

- **Feature development time reduced by 70%**
- **Test code is 25-50% of feature code size**
- **Each test catches a unique failure mode**
- **AI-generated gibberish caught before commit**
- **Confidence to deploy after tests pass**
- **Zero time spent on redundant tests**

## Remember

You're building features, not test suites. Tests exist solely to ensure the AI didn't generate garbage. Every moment spent on redundant testing is a moment not spent shipping features.

The goal is **confidence to deploy**, not test coverage metrics. Write exactly enough tests to sleep well at night, knowing that:
- The feature works for users
- The AI understood the requirements
- Critical bugs would be caught
- You're not duplicating manual testing effort

When in doubt, ship faster.