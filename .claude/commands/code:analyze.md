# /code:analyze

**Purpose**: Analyze code changes or entire codebase to automatically update acceptance criteria and codebase documentation using specialized agents.

## Usage
- `/code:analyze` - Analyze changes in current branch (or entire codebase if on main)
- `/code:analyze [branch]` - Analyze changes in specified branch
- `/code:analyze [commit-hash]` - Analyze changes in specific commit
- `/code:analyze --from [ref1] --to [ref2]` - Analyze changes between two references

## Critical Rules
- NEVER skip files based on extension - let agents determine relevance
- ALWAYS request summaries from both agents
- NEVER filter out files you think are irrelevant
- ALWAYS batch files when analyzing entire codebase (main branch)

## Workflow

### 1. Determine Analysis Scope
- Check current branch using `git branch --show-current`
- If on main/master: analyze entire codebase
- If on feature branch: compare to main/master
- If branch/commit specified: analyze those changes

### 2. Collect Files to Analyze

#### For Main Branch (Full Codebase Analysis)
- Use `git ls-files` to get all tracked files
- Batch files into groups of 50-100 files
- Process each batch sequentially

#### For Branch/Commit Analysis
- Use appropriate git command to get changed files:
  - Branch comparison: `git diff --name-only [base-branch]`
  - Specific commit: `git diff-tree --no-commit-id --name-only -r [hash]`
  - Reference comparison: `git diff --name-only [ref1] [ref2]`

### 3. Delegate to Agents

For each batch of files, tell both agents:

**To @acceptance-criteria-agent:**
"Please analyze these [count] files and create or update acceptance criteria documentation as needed. Provide a summary of:
- Number of files that had relevant acceptance criteria
- Key features or behaviors documented
- Any new acceptance criteria files created
- Any existing criteria files updated

Files to analyze:
[list of files]"

**To @codebase-specialist:**
"Please analyze these [count] files and update the codebase documentation (architecture, components, flows, dependencies) as needed. Provide a summary of:
- Architecture insights discovered
- Components documented or updated
- Key patterns or flows identified
- Documentation files created or updated

Files to analyze:
[list of files]"

### 4. Compile Final Summary
After all batches are processed, provide comprehensive summary including:
- Total files analyzed
- Analysis scope (entire codebase, branch changes, or specific commit)
- Summary from @acceptance-criteria-agent
- Summary from @codebase-specialist
- Recommendations for further documentation if gaps were identified

## Batch Processing (Main Branch)
When analyzing entire codebase:
1. Inform user that full codebase analysis will be performed in batches
2. Process 50-100 files per batch
3. Show progress after each batch
4. Allow agents to build comprehensive documentation progressively

## Error Handling
- If git command fails: Check if valid git repository
- If no files found: Inform user (empty repository or no changes)
- If branch/commit not found: Provide clear error message
- If on main but codebase is very large (>1000 files): Warn user and confirm before proceeding

## Example Scenarios

### Full Codebase Analysis (on main)
When on main branch, systematically analyzes entire codebase in batches, building comprehensive documentation of acceptance criteria and architecture.

### Feature Branch Analysis
When on feature branch, identifies changes compared to main and updates documentation for modified functionality.

### Commit Analysis
When given specific commit, focuses documentation on the changes introduced by that commit.