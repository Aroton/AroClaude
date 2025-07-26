# /code:review

**Purpose**: Perform comprehensive code review of changes or entire codebase using specialized agents for security, quality, and best practices analysis.

## Usage
- `/code:review` - Review changes in current branch (or entire codebase if on main)
- `/code:review [branch]` - Review changes in specified branch
- `/code:review [commit-hash]` - Review changes in specific commit
- `/code:review --from [ref1] --to [ref2]` - Review changes between two references
- `/code:review [file-path]` - Review specific file or directory

## Critical Rules
- NEVER skip files based on extension - let agents determine relevance
- ALWAYS request detailed analysis from all review agents
- NEVER filter out files you think are irrelevant
- ALWAYS batch files when reviewing entire codebase (main branch)
- ALWAYS prioritize security and vulnerability assessment
- NEVER approve code with unresolved security issues

## Workflow

### 1. Determine Review Scope
- Check current branch using `git branch --show-current`
- If on main/master: review entire codebase
- If on feature branch: compare to main/master
- If branch/commit specified: review those changes
- If file path specified: review specific files

### 2. Collect Files to Review

#### For Main Branch (Full Codebase Review)
- Use `git ls-files` to get all tracked files
- Batch files into groups of 50-100 files
- Process each batch sequentially

#### For Branch/Commit Review
- Use appropriate git command to get changed files:
  - Branch comparison: `git diff --name-only [base-branch]`
  - Specific commit: `git diff-tree --no-commit-id --name-only -r [hash]`
  - Reference comparison: `git diff --name-only [ref1] [ref2]`

#### For File Path Review
- Use `find` or `ls` to collect files in specified path
- Include all relevant file types

### 3. Delegate to Review Agents

For each batch of files, tell the review agents:

**To @automated-code-reviewer:**
"Please perform a comprehensive code review of these [count] files. Provide detailed analysis including:
- Code quality issues and improvements
- Performance concerns and optimizations
- Potential bugs and logic errors
- Adherence to best practices and conventions
- Maintainability and readability issues
- Test coverage and quality assessment
- Documentation gaps
- Overall risk assessment (High/Medium/Low)

Files to review:
[list of files]"

**To @codebase-specialist:** (for architecture review)
"Please analyze these [count] files from an architectural perspective. Provide analysis of:
- Architecture patterns and violations
- Component relationships and dependencies
- Design principles adherence (SOLID, DRY, etc.)
- Module boundaries and coupling
- Data flow and state management
- Integration patterns and interfaces
- Scalability considerations
- Technical debt assessment

Files to analyze:
[list of files]"

### 4. Security Assessment
For security-critical files or when security issues are found:

**Additional security analysis:**
"Please perform security-focused analysis of flagged files:
- Authentication and authorization flaws
- Input validation and sanitization
- SQL injection and XSS vulnerabilities
- Cryptographic implementation issues
- Secrets and credential exposure
- Access control violations
- Data privacy concerns
- Dependency security issues"

### 5. Compile Review Summary
After all batches are processed, provide comprehensive summary including:
- Total files reviewed
- Review scope (entire codebase, branch changes, or specific commit)
- Critical issues requiring immediate attention
- Security vulnerabilities and risk level
- Code quality summary with improvement recommendations
- Architecture insights and recommendations
- Performance optimization opportunities
- Test coverage gaps and quality issues
- Overall code health score and recommendations

## Batch Processing (Main Branch)
When reviewing entire codebase:
1. Inform user that full codebase review will be performed in batches
2. Process 50-100 files per batch
3. Show progress after each batch
4. Allow agents to build comprehensive review progressively
5. Prioritize security-critical files in early batches

## Error Handling
- If git command fails: Check if valid git repository
- If no files found: Inform user (empty repository or no changes)
- If branch/commit not found: Provide clear error message
- If on main but codebase is very large (>1000 files): Warn user and confirm before proceeding
- If file path not found: Provide clear error message

## Review Categories

### Security Review (Critical Priority)
- Authentication and authorization
- Input validation and sanitization
- Cryptographic implementations
- Secrets management
- Dependency vulnerabilities
- Access control mechanisms

### Code Quality Review
- Readability and maintainability
- Performance and optimization
- Error handling and edge cases
- Code organization and structure
- Naming conventions and clarity
- Comment quality and documentation

### Architecture Review
- Design patterns and principles
- Module organization and boundaries
- Dependency management
- Scalability considerations
- Technical debt assessment
- Integration patterns

### Testing Review
- Test coverage and completeness
- Test quality and reliability
- Test organization and structure
- Mock usage and test isolation
- Performance test coverage
- Edge case testing

## Risk Assessment Framework
Each review must include risk categorization:

### High Risk
- Security vulnerabilities
- Critical logic errors
- Performance bottlenecks
- Data corruption potential
- Breaking changes without migration

### Medium Risk
- Code quality issues
- Maintainability concerns
- Minor security considerations
- Test coverage gaps
- Documentation deficiencies

### Low Risk
- Style inconsistencies
- Minor optimizations
- Cosmetic improvements
- Non-critical refactoring opportunities

## Example Scenarios

### Full Codebase Review (on main)
When on main branch, systematically reviews entire codebase in batches, providing comprehensive security, quality, and architecture assessment.

### Feature Branch Review
When on feature branch, identifies changes compared to main and provides focused review of modified functionality with impact assessment.

### Commit Review
When given specific commit, focuses review on the changes introduced by that commit with before/after comparison.

### File-Specific Review
When given file path, provides deep-dive analysis of specific files or directories with contextual understanding.

## Review Standards
- All security issues must be clearly flagged
- Performance impacts must be quantified when possible
- Architecture violations must include remediation suggestions
- Code quality issues must include specific improvement recommendations
- Test gaps must identify specific scenarios needing coverage
- All findings must be prioritized by risk level

## Final Deliverables
1. Executive summary with overall assessment
2. Categorized issues list with priority rankings
3. Security assessment with vulnerability details
4. Architecture review with improvement recommendations
5. Action items with estimated effort and impact
6. Code health metrics and trends (if historical data available)