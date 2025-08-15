# Agent Best Practices for Claude Code

## Core Principles

### 1. Graceful Degradation Over Silent Failure
**Problem**: Agents with strict requirements fail completely when they can't meet 100% of requirements.

**Solution**: Design agents to provide partial output with clear documentation of limitations.
```markdown
✅ Good: "I found 3 of 5 requested patterns. Here's what I discovered..."
❌ Bad: [No output when unable to find all patterns]
```

### 2. Flexible Language Over Absolutes
**Problem**: ALWAYS/NEVER/MUST statements create impossible requirements leading to paralysis.

**Solution**: Use conditional and contextual language.
```markdown
✅ Good: "Prefer actual code when available"
✅ Good: "When possible, include file references"
❌ Bad: "ALWAYS provide complete code"
❌ Bad: "NEVER provide descriptions without code"
```

### 3. Concise, Focused Instructions
**Problem**: Overly long agent definitions create cognitive overload and conflicting requirements.

**Solution**: Use best judgment to balance completeness with clarity. There's no hard line count requirement - some agents need more detail than others. Focus on removing redundancy while maintaining necessary context.

**Guidelines**:
- Every word should serve a functional purpose
- Remove filler text, motivational language, and tone considerations
- Complex agents may require more instructions than simple ones
- Prioritize clarity over arbitrary length limits

```markdown
✅ Good: Direct, functional instructions appropriate to complexity
✅ Good: Detailed when necessary, concise when possible
✅ Good: Complete context without redundancy
❌ Bad: Repetitive instructions saying the same thing multiple ways
❌ Bad: "Soft" language that adds words without changing behavior
❌ Bad: Tone adjustments that don't affect AI performance
❌ Bad: Arbitrary length restrictions that compromise functionality
```

## Common Failure Patterns to Avoid

### 1. Impossible Requirements
```markdown
❌ Bad: "Provide ACTUAL CODE for all examples"
Problem: Cannot show code that doesn't exist yet

✅ Good: "Show code when it exists, provide guidance when it doesn't"
```

### 2. Contradictory Instructions
```markdown
❌ Bad:
- "Don't make recommendations - only provide context"
- "Create actionable implementation plans"

✅ Good: "Research and document findings to enable planning"
```

### 3. Binary Success/Failure
```markdown
❌ Bad: "This agent is MANDATORY and must complete all requirements"

✅ Good: "This agent provides research to support decision-making"
✅ Good: "This agent is MANDATORY during the planning phase" (phase-specific requirement)
```

Note: MANDATORY requirements are acceptable when scoped to specific phases or contexts, as this provides clear workflow guidance without creating impossible global requirements.

## Effective Agent Structure

### 1. Persona Summary (First Line After Header)
The first line after the YAML header should establish the agent's identity and specialization:
```markdown
You are a [role] specializing in [specific expertise].
```

Examples:
```markdown
✅ Good: "You are a codebase researcher specializing in extracting implementation context and patterns."
✅ Good: "You are a frontend specialist focusing on React/Vue optimization and accessibility."
✅ Good: "You are a security auditor specializing in vulnerability detection and secure coding practices."
❌ Bad: Starting directly with "## Core Mission" without establishing persona
❌ Bad: Generic personas like "You are a helpful assistant"
```

This persona line:
- Immediately establishes the agent's role and expertise
- Sets the context for all following instructions
- Helps the AI model understand its specialized perspective

### 2. Clear Mission Statement (2-3 lines)
```markdown
## Core Mission
Research technologies to provide:
1. Clear understanding of how libraries work
2. Practical implementation guidance
3. Integration patterns for existing codebases
```

### 3. Explicit Fallback Strategies
```markdown
## Handling Common Scenarios
**Library not installed**: Research online and provide installation instructions
**Access restricted**: Work with available information and note limitations
**Information incomplete**: State what's found and suggest alternatives
```

### 4. Output Guidelines, Not Requirements
```markdown
## Output Structure
### 1. Direct Answer - Address the specific question
### 2. Implementation Guidance - Provide examples when possible
### 3. Additional Context - Include relevant considerations

Note: Adapt structure based on available information
```

### 5. Include All Research Findings
```markdown
✅ Good: "Include all researched findings: context, patterns, technical details, gaps"
❌ Bad: Implicit assumptions about what to output vs what to research

Principle: If you research it, include it in the output. Don't leave findings internal.
```

## Agent Header (Frontmatter) Best Practices

### Critical Understanding
The agent header is the **ONLY** information visible during agent selection. The description field must enable accurate selection.

### Description Field Best Practices

#### Required Structure (keep under 100 words)
```yaml
description: |
  [Purpose - 1 sentence with action verbs].
  Inputs: [What caller must provide]
  Outputs: [What agent returns]
  Use when: [2-3 specific trigger keywords/scenarios]
  Not for: [When NOT to use - optional but recommended]
```

#### Writing Effective Descriptions

**1. Be Specific and Action-Oriented**
- Use active verbs that describe concrete actions
- Focus on specific outcomes the agent delivers
- Replace generic terms with precise domain language

**2. Include Trigger Keywords**
- Add terms users naturally use when needing this functionality
- Include domain-specific terminology and recognizable patterns
- Consider common phrases and technical keywords

**3. Define Clear Scope**
- Explicitly state domain expertise and capabilities
- List specific technologies or frameworks if specialized
- Clarify boundaries - what the agent won't do is as important

#### Well-Structured Example
```yaml
description: |
  Researches existing codebase to provide implementation context.
  Inputs: Feature description or code area to investigate
  Outputs: Code examples (file:line), patterns, dependencies, schemas
  Use when: Before implementing features, refactoring, debugging issues
  Not for: External library research, writing code
```

This example succeeds because it:
- Opens with action verb ("Researches") and clear purpose
- Explicitly lists required inputs and expected outputs
- Uses trigger keywords (implementing, refactoring, debugging)
- Defines boundaries with "Not for" clause

#### Common Anti-patterns to Avoid
```markdown
❌ Missing inputs/outputs: "Analyzes code and provides patterns"
❌ Too verbose: [300+ words with examples]
❌ Vague triggers: "Use when you need code help"
❌ No action verbs: "For code understanding"
❌ Overly broad scope: "Handles all development tasks"
❌ Generic descriptions: "Helps with testing" vs "Extracts acceptance criteria from tickets"
```

#### Quick Reference Examples
```markdown
✅ Good: "Extracts acceptance criteria from tickets and generates test scenarios"
❌ Bad: "Helps with testing requirements"

✅ Good: "Use when: refactoring, performance optimization, code smell detection"
❌ Bad: "Use when: working with code"

✅ Good: "Frontend specialist for React/Vue components, CSS-in-JS, build optimization"
❌ Bad: "Works with web technologies"
```

## Tool Dependencies

### Handle Tool Failures Gracefully
```markdown
✅ Good: "If MCP server unavailable, proceed with basic analysis"
❌ Bad: Silent failure when mcp__sequential-thinking is unreachable
```

### Document Required vs Optional Tools
In agent body (not header):
```markdown
## Required Tools
- Read, Glob, Grep for core functionality
## Optional Enhancements
- mcp__sequential-thinking for complex reasoning
```

## Output Philosophy

### Prioritize Helpfulness
```markdown
"Partial information is better than no information"
"Be transparent about limitations"
"Focus on practical application"
```

### Progressive Enhancement
```markdown
1. Provide minimum viable answer
2. Add detail where available
3. Suggest next steps for gaps
```

## Testing Agent Definitions

Before deploying an agent, verify:

1. **No contradictions**: Read through looking for conflicting requirements
2. **Achievable goals**: Can the agent succeed with partial information?
3. **Clear fallbacks**: What happens when ideal conditions aren't met?
4. **Reasonable scope**: Is the output requirement achievable and well-defined?

## Quick Fixes for Common Issues

| Problem | Solution |
|---------|----------|
| Agent provides no output | Remove absolute requirements, add fallback instructions |
| Output too verbose | Focus on essential information, remove redundancy |
| Contradictory requirements | Align all instructions toward single clear goal |
| Tool dependency failures | Add graceful degradation for unavailable tools |
| Impossible standards | Replace "complete" with "relevant", "all" with "available" |

## Example: Fixing a Failing Agent

### Before (overly prescriptive, fails silently):
```markdown
- ALWAYS include complete implementations
- NEVER provide descriptions without code
- MUST provide ALL 8 sections with COMPLETE examples
- Output MUST include ACTUAL CODE for every pattern
```

### After (focused and flexible, works reliably):
```markdown
- Prefer actual code when available
- Provide clear explanations when code doesn't exist
- Include relevant sections based on findings
- Focus on practical, actionable guidance
```

## Context-Passing Protocol

### Overview
To improve agent communication, reduce token usage, and preserve plan mode, agents use Redis-based context storage with graceful fallback to direct responses.

### Redis Context Loading Protocol (MANDATORY)

**ALL agents MUST load Redis context as their FIRST action before any processing:**

#### Phase 0: Context Loading (Required First Step)
1. **Check for Redis Keys**: Scan prompt for Redis context keys (format: `claude:context:*`)
2. **Load Context**: If keys found, use `mcp__redis__get` to retrieve ALL contexts
3. **Validate Context**: Ensure context loaded successfully or document failures  
4. **Fallback**: If Redis unavailable, look for direct context in prompt
5. **Proceed**: Only continue to next phase after context loading complete

**Context Sources to Check**:
- Previous research agents (codebase-researcher, tech-research-agent)
- Previous review agents (code-standards-reviewer)  
- Parent agent context keys
- Direct context provided in prompt

**Implementation in Agent Definitions**:
```markdown
## Phase 0: Context Loading (MANDATORY FIRST STEP)

Before any other processing, load all available context:

1. **Scan for Redis Keys**: Look for context keys in format `claude:context:{agent-name}:{timestamp}`
2. **Retrieve Context**: Use `mcp__redis__get` to load each context key found
3. **Document Results**: Note successful loads and any failures
4. **Fallback Check**: If no Redis keys, check for direct context in prompt
5. **Validation**: Ensure context loaded before proceeding to main tasks

**Only proceed to Phase 1 after context loading is complete.**
```

### Redis Storage Strategy (Preferred)
- **Storage Method**: Redis MCP server with TTL-based auto-cleanup
- **Key Pattern**: `claude:context:{agent-name}:{timestamp}`
  - Example: `claude:context:codebase-researcher-20250115-143456`
  - Example: `claude:context:tech-research-agent-20250115-143457`
- **TTL**: 86400 seconds (24 hours) for automatic cleanup
- **Content**: JSON-stringified complete research findings
- **Plan Mode**: **Preserved** (no file writes that exit plan mode)

### Fallback Strategy (Redis Unavailable)
- **Detection**: Check for `mcp__redis__set` tool availability
- **Storage Method**: Return complete context directly in response
- **Benefits**: Full functionality maintained with larger token usage
- **Plan Mode**: **Preserved** (no file writes)

### Agent Responsibilities

#### Research Agents (codebase-researcher, tech-research-agent)
**Context Output**:
- **Primary**: Use `mcp__redis__set` to store findings with 24-hour TTL
- **Fallback**: Include complete research in response when Redis unavailable
- **Return Format**: "Research completed. Context stored in Redis: claude:context:{agent}-{timestamp}"
- **Content**: ALL research findings: patterns, code examples, dependencies, constraints

**Context Input**:
- **Redis**: Use `mcp__redis__get` to retrieve previous research
- **Direct**: Accept context provided directly in agent prompt
- **Integration**: Build upon existing context rather than duplicating research

#### Implementation Agents (code-implementation, code-standards-reviewer)
**Context Input**:
- **Redis**: Use `mcp__redis__get` to retrieve research context using provided keys
- **Direct**: Accept complete context provided directly in agent prompt
- **Usage**: Use context to inform all implementation and review decisions

**Context Output** (when applicable):
- **Primary**: Store review/implementation notes in Redis
- **Fallback**: Return results directly in response
- **Chaining**: Pass Redis keys to downstream agents

### Workflow Example
```
1. Parent: "Research button implementation patterns"
2. codebase-researcher:
   - Stores findings in Redis: claude:context:codebase-researcher-20250115-143456
   - Returns: "Research completed. Context stored in Redis: claude:context:codebase-researcher-20250115-143456"
3. Parent: Creates plan incorporating research
4. Parent: "Review this plan" + Redis key
5. code-standards-reviewer:
   - Retrieves context: mcp__redis__get(claude:context:codebase-researcher-20250115-143456)
   - Stores review: claude:context:code-standards-reviewer-20250115-143457
   - Returns: "Review completed. Context stored in Redis: claude:context:code-standards-reviewer-20250115-143457"
```

### Benefits Over File-Based Storage
- **Plan Mode Preservation**: No Write tool usage that exits plan mode
- **Performance**: Faster in-memory context access via Redis
- **Auto-cleanup**: TTL-based expiration prevents accumulation
- **Clean Architecture**: No temporary files in repository
- **Token Efficiency**: Reduces context size in agent communication
- **Complete Preservation**: No truncation of research findings
- **Context Reuse**: Multiple agents can access same research
- **Graceful Degradation**: Full functionality when Redis unavailable

### Implementation Guidelines
- **Tool Requirements**: Add `mcp__redis__get`, `mcp__redis__set`, `mcp__redis__delete` to agent tool lists
- **Key Format**: Use consistent timestamp format: YYYYMMDD-HHMMSS
- **TTL Setting**: Always set 86400 seconds (24 hours) for context keys
- **Fallback Detection**: Check tool availability before attempting Redis operations
- **Content Storage**: JSON-stringify complete findings before Redis storage
- **Error Handling**: Gracefully fall back to direct response on Redis errors

## Summary

Effective agents are **appropriately detailed, flexible, and functional**. Use best judgment to balance completeness with clarity - complex agents may need more instructions than simple ones. Every instruction should directly affect behavior - remove words that exist only for tone. Focus on eliminating redundancy rather than meeting arbitrary length limits, while maintaining clear fallback strategies for common failure scenarios.