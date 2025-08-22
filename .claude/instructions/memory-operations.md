# Memory Operations Instructions

## MANDATORY Memory Handling Protocol

### Critical Rules - NEVER Skip These
- ALL memory operations marked MANDATORY must be completed
- ALWAYS confirm what you loaded and what you saved
- Memory is the PRIMARY communication channel between agents
- Failure to follow memory operations WILL break workflows

### Loading Memory Keys
When your prompt contains **"MANDATORY: Load memory keys: [key1, key2]"**:

1. **IMMEDIATELY** call `mcp__serenna__read_memory` for each key
2. **CONFIRM** in your response: "MEMORY LOADED: key1 (brief description), key2 (brief description)"
3. **USE** the loaded context to inform all subsequent work

Example:
```
MANDATORY: Load memory keys: project_goal, user_clarifications
```

Your response MUST start with:
```
MEMORY LOADED: project_goal (user wants Redis caching), user_clarifications (performance requirements, integration constraints)
```

### Saving to Memory
When your prompt contains **"MANDATORY: Save to: output_key"**:

1. **COMPLETE** your assigned task first
2. **CALL** `mcp__serenna__write_memory(output_key, content, type)`
3. **CONFIRM** in response: "MEMORY CONFIRMATION: Saved to output_key"

### Memory Types for Saving
- **summary**: Condensed key points and decisions
- **full**: Complete detailed output with all context
- **structured**: Formatted data (JSON/YAML) for systematic processing

### Memory Operation Pattern
When you see this pattern in prompts:
```
[Your main task instructions here]

MANDATORY: Load memory keys: input_key1, input_key2
MANDATORY: Save to: output_key
MANDATORY: Confirm all memory operations in your response
```

You MUST:
1. Load input_key1 and input_key2 using `mcp__serenna__read_memory`
2. Confirm what you loaded
3. Execute your main task using the loaded context
4. Save results using `mcp__serenna__write_memory(output_key, content, type)`
5. Confirm what you saved

### Standard Memory Confirmation Format
```
MEMORY LOADED: [key1] ([brief description]), [key2] ([brief description])

[Your task execution and results here]

MEMORY CONFIRMATION: Saved to [output_key]
```

### Workflow Context Management
- Each agent receives ONLY the memory keys they need
- Parent workflow context is kept minimal through memory delegation
- Previous agent outputs become input memory for next agents
- This enables complex workflows without context explosion

### Error Handling
If memory operations fail:
1. Report the specific failure
2. Attempt to continue with available context
3. Note what information is missing
4. Still complete your core task if possible

### Memory Key Naming Convention
- Use descriptive names: `project_goal`, `codebase_research`, `final_plan`
- Include workflow prefix for organization: `aro:plan:project_goal`
- Separate phases with descriptive suffixes: `plan_initial`, `plan_reviewed`