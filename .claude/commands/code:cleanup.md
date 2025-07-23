# /code:cleanup

**Purpose**: Research deprecated features in the codebase and systematically remove all unused code and its dependencies.

**Execution Type**: SUB-AGENT

## Usage
- `/code:cleanup` - Discover and remove all deprecated code from the project
- `/code:cleanup [feature]` - Target specific deprecated feature for removal
- `/code:cleanup --dry-run` - Report what would be removed without making changes

## Critical Rules
- NEVER remove code without understanding all its usages
- ALWAYS trace transitive dependencies before removal
- ALWAYS verify tests still pass after each removal phase
- NEVER skip the impact analysis phase
- ALWAYS analyze import chains and export relationships
- NEVER remove without checking for dynamic imports or string references
- ALWAYS check for deprecation comments, TODOs, and migration notes
- NEVER assume zero usage without comprehensive search

## Workflow/Process
1. **Discovery Phase**
   - Search for deprecation markers (@deprecated, TODO: remove, DEPRECATED:, etc.)
   - Identify legacy patterns from framework migrations
   - Find unused exports through static analysis
   - Locate dead code paths through coverage analysis if available
   - Check package.json for deprecated dependencies
   - Track all findings in memory for the session

2. **Usage Analysis**
   - For each deprecated item, trace all direct imports/usages
   - Map transitive dependencies (what depends on things that use it)
   - Search for dynamic imports and string-based references
   - Check test files for usage
   - Identify configuration references
   - Build complete dependency graph

3. **Impact Assessment**
   - Categorize deprecations by risk level
   - Group related deprecations for atomic removal
   - Identify breaking changes vs safe removals
   - Check for external API contracts
   - Assess test coverage for affected areas
   - Determine removal order based on dependencies

4. **Removal Planning**
   - Create removal phases starting with leaf nodes
   - Plan test updates for each phase
   - Identify replacement patterns where needed
   - Document migration path for active deprecations
   - Set up validation criteria for each removal

5. **Incremental Cleanup**
   - Remove code in dependency order (leaves first)
   - Update imports and exports atomically
   - Remove associated tests for deleted code
   - Clean up type definitions and interfaces
   - Delete empty directories and files
   - Verify tests pass after each removal

6. **Validation Phase**
   - Run full test suite after each removal batch
   - Check for runtime errors in common workflows
   - Verify no broken imports remain
   - Ensure documentation is updated
   - Confirm no orphaned files exist

## Error Handling
- If usage found in external packages: Document and skip
- If tests fail after removal: Restore and mark as actively used
- If circular dependencies detected: Plan multi-step removal
- If dynamic usage suspected: Add to manual review list
- If removal breaks API: Check backwards compatibility requirements

## Sub-Agent Instructions
The task tool sub-agent should:
1. Execute the complete deprecation cleanup workflow
2. Keep all findings and progress in memory during session
3. Use batch processing for related deprecations
4. Verify each removal doesn't break functionality
5. Create detailed removal report
6. Exit with summary of actions taken

## Discovery Patterns
Common deprecation indicators to search for:
- Primary keywords: "deprecated", "legacy", "DEPRECATED", "LEGACY"
- Code comments: @deprecated, TODO: remove, FIXME: legacy, // deprecated, /* legacy */
- File patterns: .old, .backup, -deprecated, -legacy, _deprecated, _legacy
- Framework migrations: old API usage patterns
- Package.json: dependencies marked as deprecated
- Test files: .skip, .todo, disabled test suites
- Configuration: unused feature flags, old settings
- Import analysis: exported but never imported symbols

## Removal Strategy
1. **Safe Removals First**: Start with clearly unused code
2. **Atomic Changes**: Group related changes together
3. **Test Continuously**: Verify after each removal batch
4. **Document Decisions**: Note why code was safe to remove
5. **Progressive Cleanup**: Work from edges toward core

## Validation Requirements
1. All tests must pass after each removal phase
2. No broken imports or missing dependencies
3. Application builds successfully
4. No runtime errors in critical paths
5. Removal decisions tracked and reported
6. Exit codes:
   - 0 = All deprecated code successfully removed
   - 1 = Partial removal with some items requiring manual review
   - 2 = Removal blocked by active usage or test failures

## Risk Mitigation
- Create restoration plan before starting removals
- Test in isolation before removing interconnected code
- Keep removal batches small and focused
- Document external dependencies that couldn't be removed

## Reporting
Final report should include:
- Total lines of code removed
- Number of files deleted
- Dependencies cleaned up
- Test coverage impact
- Items requiring manual review
- Summary of each removal phase