# Agent Best Practices for Claude Code

## Core Principles

### 1. Graceful Degradation Over Silent Failure
**Problem**: Agents with strict requirements fail completely when they can't meet 100% of research requirements.

**Solution**: Design agents to provide partial research output with clear documentation of limitations.
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

### YAML Frontmatter Structure

All agent files must follow this exact format:

```yaml
---
name: agent-identifier
description: Multi-line capability description with examples using \n for line breaks and embedded <example> tags for usage scenarios. This field can include detailed examples with <commentary> sections to clarify agent usage patterns.
tools: Tool1, Tool2, Tool3
model: inherit
color: green
---
```

#### Required Fields

1. **name**: kebab-case agent identifier (e.g., `code-implementation`, `codebase-researcher`)
2. **description**: Multi-line text describing agent capabilities, usage examples, and scenarios  
3. **tools**: Comma-separated list of required tools
4. **model**: Either `inherit` (uses Claude Code default) or specific model (`sonnet`, `opus`)
5. **color**: Visual category indicator (`green`, `blue`, `purple`, `orange`)

### Description Field Best Practices

#### Format for Complex Descriptions
Use escaped newlines (\n) and embedded examples for comprehensive agent descriptions:

```yaml
description: Use this agent when you need to [primary purpose]. This agent is [importance level] for [specific scenarios]. Examples:\n\n<example>\nContext: [scenario description]\nuser: "example user request"\nassistant: "example response"\n<commentary>\n[explanation of why this agent is needed]\n</commentary>\n</example>
```

#### Description Tags and Their Usage

Agent descriptions use specific XML-style tags to structure content and provide clear usage examples:

**`<example>` Tag**:
- **Purpose**: Contains complete usage scenarios showing when and how to invoke the agent
- **Structure**: Includes Context, user input, assistant response, and commentary
- **Usage**: Multiple examples can be included to cover different scenarios
- **Formatting**: Must be properly escaped with `\n` for line breaks in YAML

**`<commentary>` Tag**:
- **Purpose**: Explains the reasoning behind agent selection for the given scenario
- **Content**: Clarifies why this specific agent is needed vs. alternatives
- **Position**: Always placed at the end of each `<example>` block
- **Value**: Helps Claude Code understand selection criteria and agent boundaries

**Additional Context Tags** (when needed):
- **`<research phase>`**: Indicates preliminary research steps before agent invocation
- **`<analysis phase>`**: Shows analytical work that precedes agent usage
- **`<planning phase>`**: Documents planning activities that lead to agent selection

**Example with Multiple Tags**:
```yaml
description: Use this agent when you need to write, create, or generate any code. Examples:\n\n<example>\nContext: User wants to refactor an existing function\nuser: "Refactor the data processing function to improve performance"\nassistant: "Let me analyze the current implementation and then refactor it."\n<analysis phase>\nassistant: "I'll now use the code-implementation agent to refactor the data processing function."\n<commentary>\nAny code modification requires the code-implementation agent to maintain standards.\n</commentary>\n</example>
```

**Tag Formatting Rules**:
- Tags must be properly escaped in YAML strings
- Use `\n` for line breaks within tag content
- Maintain consistent indentation in multi-line tag blocks
- Close all opened tags properly
- Keep tag content concise but informative

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

#### Complete Agent Header Example
```yaml
---
name: codebase-researcher
description: Use this agent when you need to thoroughly research and understand existing code before planning or implementing changes. This agent is MANDATORY during the planning phase and provides essential research before delegating implementation work to other agents. Examples:\n\n<example>\nContext: User needs to add a new feature to an existing module\nuser: "I need to add authentication to the user profile page"\nassistant: "I'll first use the codebase-researcher agent to understand the current implementation"\n<commentary>\nBefore planning any changes, the codebase-researcher must analyze the existing code structure, authentication patterns, and user profile implementation.\n</commentary>\n</example>
tools: Read, Glob, Grep, TodoWrite, LS, mcp__sequential-thinking__sequentialthinking
model: sonnet
color: blue
---
```

This example succeeds because it:
- Opens with action verb ("research") and clear purpose
- Explicitly states when the agent is MANDATORY
- Includes concrete usage examples with context
- Uses trigger keywords (planning, implementing, research)
- Defines scope with embedded examples

#### Common Anti-patterns to Avoid
```yaml
❌ Missing YAML frontmatter:
description: "Analyzes code and provides patterns"

❌ Missing required fields:
---
name: analyzer
description: Helps with code
---

❌ Vague descriptions without examples:
description: "Use when you need code help"

❌ No Redis tools included:
tools: Read, Glob, Grep

❌ Generic agent scope:
description: "Handles all development tasks"
```

#### Complete Header Formatting Guidelines

**Multi-line Description Structure**:
```yaml
description: [Main purpose sentence]. This agent is [importance/requirement level] for [specific use cases]. Examples:\n\n<example>\nContext: [specific scenario]\nuser: "[example request]"\nassistant: "[example response]"\n<commentary>\n[explanation of agent selection rationale]\n</commentary>\n</example>
```

**Tool List Requirements**:
- Always include Redis MCP tools: `mcp__redis__get, mcp__redis__set, mcp__redis__delete`
- List tools in logical order: core tools first, MCP tools last
- Separate with commas and spaces for readability

**Color Categories**:
- `blue`: Research agents (codebase-researcher, tech-research-agent)
- `green`: Implementation agents (code-implementation)
- `purple`: Analysis agents (code-standards-reviewer)
- `orange`: Planning agents (implementation-planner)

## Tool Dependencies

### Handle Tool Failures Gracefully
```markdown
✅ Good: "If mcp__sequential-thinking unavailable, proceed with basic analysis"
❌ Bad: Silent failure when optional MCP tools are unreachable
```

### Document Required vs Optional Tools
In agent body (not header):
```markdown
## Required Tools (MANDATORY)
- Read, Glob, Grep for core functionality

## Optional Enhancements
- mcp__sequential-thinking for complex reasoning
```

## Output Philosophy

### Prioritize Helpfulness
```markdown
"Partial research findings are better than no information"
"Be transparent about research limitations"
"Focus on practical application"
```

### Progressive Enhancement
```markdown
1. Provide minimum viable research findings
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
Agents provide complete context directly in their responses to ensure continuity between phases.

### Context Flow
Agents include all research findings, analysis results, and implementation context directly in their responses. This ensures subsequent agents have access to previous work without requiring external storage.

## Summary

Effective agents are **appropriately detailed, flexible, and functional**. Use best judgment to balance completeness with clarity - complex agents may need more instructions than simple ones. Every instruction should directly affect behavior - remove words that exist only for tone. Focus on eliminating redundancy rather than meeting arbitrary length limits, while maintaining clear fallback strategies for common failure scenarios.