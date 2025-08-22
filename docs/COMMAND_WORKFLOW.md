# AI Agent Workflow YAML Schema with Serena MCP

## Workflow Execution Instructions

### How to Parse and Execute This Workflow

When you receive a workflow specification, follow these instructions to execute it properly:

#### 1. **Parse the Workflow**
- Read the YAML workflow structure
- Identify all steps and their dependencies
- Note which memories each step reads and writes
- Understand the sequential flow from `depends_on` relationships

#### 2. **Execute Steps Sequentially**
Follow this process for each step in order:

```
FOR each step in workflow.steps (respecting depends_on order):
  1. Check dependencies are complete
  2. Load required memories using Serena MCP API (if any)
  3. Execute the agent or task
  4. Save output to memory using Serena MCP API
  5. Handle any errors according to on_error rules
  6. Proceed to next step
```

#### 3. **Working with Agents**
- **`@agent-name`**: Call the specified specialized agent with the provided inputs
- **`@task`**: Execute the task yourself using the prompt and context provided
- Pass all specified inputs to the agent/task
- Ensure the agent has access to all memories listed in `from_memory`

#### 4. **Memory Operations via Serena MCP**

All memory operations MUST go through Serena MCP APIs.

- **Reading Memory**:
  - When you see `from_memory: [memory_name]`
  - Use: `read_memory(memory_name)`

- **Writing Memory**:
  - When you see `memory.save_as: memory_name`
  - Use: `write_memory(memory_name, content, type)`

- **Memory Types for Writing**:
  - `summary`: Use Serena's summarization tool before saving
  - `full`: Save complete output
  - `structured`: Format content then save

- **Listing Memories**:
  - Use: `list_memories()`

#### 5. **User Interaction**
- When `from_user` is specified, prompt the user with the exact question provided
- Wait for user response before proceeding
- Validate the response if validation rules are specified

#### 6. **Error Handling**
- If a step fails and `on_error.action` is `retry`, retry up to `max_retries` times
- If `skip`, continue to the next step
- If `fail`, stop the workflow and report the error

#### 7. **Workflow Completion**
- After all steps are complete, prepare the outputs specified in the `outputs` section
- Read the specified memories using Serena MCP APIs
- Format them according to the `format` field
- Present the final outputs to the user

### Example Execution Flow with MCP

Given the planning workflow below, execute it as follows:

1. **Start with step `ask_project_goal`** (no dependencies)
   - Use `@task` to ask the user about their project
   - Call: `write_memory("project_goal", response, "summary")`

2. **Execute `analyze_and_question`** (depends on `ask_project_goal`)
   - Call: `read_memory("project_goal")`
   - Generate 10 questions based on the goal
   - Call: `write_memory("project_questions", questions, "full")`

3. **Continue through each step** following dependencies
   - Read memories: `read_memory(name)`
   - Execute agent/task
   - Save output: `write_memory(name, content, type)`

4. **Complete with `propose_final_plan`**
   - Read: `read_memory("development_plan")`, `read_memory("plan_review")`
   - Create final deliverable
   - Save: `write_memory("final_plan", plan, "full")`

5. **Generate outputs**
   - Read: `read_memory("final_plan")`, `read_memory("plan_review")`
   - Format and present to user

### Serena MCP API Operations

Use these Serena MCP operations:

- **`read_memory(memory_name)`** - Read a memory file
- **`write_memory(memory_name, content, type)`** - Write content to memory
- **`list_memories()`** - List all available memories
- **`create_summary(content)`** - Create a summary (for `type: summary`)
- **`read_multiple_memories([memory1, memory2, ...])`** - Read multiple memories at once

### Execution Rules
- Always respect step order
- Use exact agent names as specified
- Follow the workflow exactly without modification
- Use exact memory names for reading and writing

### Command Pattern

1. Parse this workflow
2. Use Serena MCP APIs for all memory operations
3. Execute each step using the appropriate tools/agents
4. Continue until all steps are complete
5. Present the final output

## Schema Overview

This YAML schema provides a standardized format for sequential AI agent workflows using Serena MCP memories for data persistence and sharing between steps.

## Core Schema Structure

```yaml
# REQUIRED: Workflow metadata
workflow:
  id: string                    # Unique workflow identifier
  name: string                  # Human-readable name
  description: string           # What this workflow does

# REQUIRED: Sequential workflow steps
steps:
  - id: string                  # Unique step identifier
    name: string                # Human-readable step name
    description: string         # What this step does
    agent: string               # @agent-name or @task for generic tasks

    # OPTIONAL: Step dependencies (for sequential flow)
    depends_on:                 # Previous step that must complete first
      - string

    # Input configuration
    input:
      # From user input
      from_user:
        prompt: string          # Question to ask the user
        type: string            # "text" | "number" | "boolean" | "choice"

      # From Serena memories
      from_memory:
        - memory_name           # Name of memory file to read (without path)

      # Static values
      static:
        key: value

      # For @task agent - specify the task details
      task:
        prompt: string          # The task instruction
        context: string         # Additional context for the task

    # Memory output configuration
    memory:
      save_as: string           # Memory name to save output to
      type: string              # "summary" | "full" | "structured"
      include_context: boolean  # Include previous step context

    # Error handling
    on_error:
      action: string            # "retry" | "skip" | "fail"
      max_retries: number       # Number of retry attempts

# OPTIONAL: Final outputs to present to user
outputs:
  - name: string                # Output name
    from_memory: string         # Memory file to read
    format: string              # "json" | "text" | "markdown"
    description: string         # What this output represents
```

## Example: Planning Workflow

```yaml
workflow:
  id: project_planning
  name: "Project Planning Workflow"
  description: "Analyzes a project, asks questions, researches codebase, and creates a reviewed plan"

steps:
  # Step 1: Ask user what we're planning
  - id: ask_project_goal
    name: "Understand Project Goal"
    description: "Ask the user what they want to plan"
    agent: "@task"

    input:
      task:
        prompt: "Engage with the user to understand their project goal and requirements"
        context: "Be thorough in understanding the scope and objectives"
      from_user:
        prompt: "What would you like to plan? Please describe your project goal and any specific requirements."
        type: text

    memory:
      save_as: project_goal
      type: summary

  # Step 2: Analyze and ask top 10 questions
  - id: analyze_and_question
    name: "Analyze and Generate Questions"
    description: "Analyze the project and ask the top 10 clarifying questions"
    agent: "@task"
    depends_on:
      - ask_project_goal

    input:
      task:
        prompt: |
          Based on the project goal, generate the top 10 most important questions
          that need to be answered to create a comprehensive plan. These should be
          specific, actionable questions about technical requirements, constraints,
          architecture decisions, and success criteria.
        context: "Focus on questions that will uncover hidden complexity and requirements"
      from_memory:
        - project_goal

    memory:
      save_as: project_questions
      type: full

  # Step 3: Compile research topics
  - id: compile_research_topics
    name: "Compile Research Topics"
    description: "Create a list of specific codebase areas to research"
    agent: "@task"
    depends_on:
      - analyze_and_question

    input:
      task:
        prompt: |
          Based on the project goal and questions, compile a comprehensive list
          of research topics and areas in the codebase that need to be examined.
          Include:
          - Specific modules, classes, or functions to analyze
          - Architecture patterns to understand
          - Dependencies to review
          - Configuration and deployment aspects
          - Test coverage areas
        context: "This list will guide the codebase research phase"
      from_memory:
        - project_goal
        - project_questions

    memory:
      save_as: research_topics
      type: structured

  # Step 4: Research the codebase
  - id: research_codebase
    name: "Research Codebase"
    description: "Thoroughly research the codebase based on identified topics"
    agent: "@code-base-researcher"
    depends_on:
      - compile_research_topics

    input:
      from_memory:
        - research_topics
        - project_goal
      static:
        depth: comprehensive
        include_dependencies: true
        analyze_patterns: true

    memory:
      save_as: codebase_research
      type: full
      include_context: true

  # Step 5: Compile a plan
  - id: compile_plan
    name: "Create Development Plan"
    description: "Compile a comprehensive development plan based on research"
    agent: "@planner"
    depends_on:
      - research_codebase

    input:
      from_memory:
        - project_goal
        - project_questions
        - codebase_research
      static:
        plan_format: "detailed"
        include_timeline: true
        include_risks: true

    memory:
      save_as: development_plan
      type: full

  # Step 6: Review the plan
  - id: review_plan
    name: "Review Plan Against Standards"
    description: "Review the plan for compliance with standards and best practices"
    agent: "@standards-reviewer"
    depends_on:
      - compile_plan

    input:
      from_memory:
        - development_plan
        - codebase_research
      static:
        review_criteria:
          - technical_feasibility
          - security_compliance
          - scalability
          - maintainability
          - resource_efficiency

    memory:
      save_as: plan_review
      type: structured
      include_context: false

  # Step 7: Propose final plan to user
  - id: propose_final_plan
    name: "Propose Final Plan"
    description: "Take feedback and propose a refined plan to the user"
    agent: "@task"
    depends_on:
      - review_plan

    input:
      task:
        prompt: |
          Based on the review feedback, create a final refined plan to present
          to the user. Address all concerns raised in the review, incorporate
          the feedback, and present a clear, actionable plan with:
          - Executive summary
          - Key phases and milestones
          - Risk mitigation strategies
          - Success metrics
          - Next steps
        context: "This is the final deliverable for the user"
      from_memory:
        - development_plan
        - plan_review
        - project_goal

    memory:
      save_as: final_plan
      type: full

outputs:
  - name: final_plan
    from_memory: final_plan
    format: markdown
    description: "The complete, reviewed development plan"

  - name: review_notes
    from_memory: plan_review
    format: text
    description: "Review feedback and compliance notes"
```

## Using Serena Memories

### Memory Storage
```yaml
memory:
  save_as: "analysis_results"    # Memory name
  type: "summary"                 # How to store the data
```

### Memory Types
- **`summary`**: Condensed version of the output
- **`full`**: Complete output with all details
- **`structured`**: Organized data with clear sections

### Reading from Memory
```yaml
input:
  from_memory:
    - "project_goal"              # Memory name to read
    - "previous_analysis"         # Another memory to read
```

## Best Practices

### 1. **Memory Management**
- Use descriptive memory names
- Choose appropriate memory types
- Clean up old memories periodically

### 2. **Sequential Flow**
- Each step should have a clear purpose
- Use `depends_on` to enforce order
- Pass only necessary memories to each step

### 3. **Agent Selection**
- Use specialized agents for domain tasks
- Use `@task` for coordination and simple operations

### 4. **Error Handling**
- Set appropriate retry counts for each step
- Save intermediate results to memory

### 5. **User Interaction**
- Ask clear, specific questions
- Gather all requirements early
- Present final outputs clearly