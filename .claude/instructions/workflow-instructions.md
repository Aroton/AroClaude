## Workflow Execution Instructions

### How to Parse and Execute This Workflow

When you receive a workflow specification, follow these instructions to execute it properly:

#### 1. **Parse the Workflow**
- Read the YAML workflow structure
- Identify all steps and their dependencies
- Note which memories each step reads and writes
- Understand the sequential flow from `depends_on` relationships

#### 1.5. **Initialize Todo List (MANDATORY)**

Before executing ANY workflow steps, you MUST:

1. **Use TodoWrite to create a todo item for EACH workflow step**
2. **Set all todos to status: "pending"**
3. **Mark the first step as "in_progress"**

**CRITICAL**: This todo list provides workflow state tracking and ensures sequential execution.

#### 2. **Execute Steps Sequentially**
Follow this process for each step in order:

**CRITICAL RULE**: NEVER present a plan or stop execution until reaching the `outputs:` section, regardless of step names like "propose_final_plan".

```
FOR each step in workflow.steps (respecting depends_on order):
  0. Update TodoWrite: Ensure current step is "in_progress"
  1. Check dependencies are complete
  2. IF from_user field exists:
     a. STOP workflow execution immediately
     b. Present exact prompt from from_user.prompt to user
     c. WAIT for user response (do not continue)
     d. Save response to memory if memory.save_as specified
  3. Load required memories using Serenna MCP API (if any)
  4. Execute the agent or task
  5. Save output to memory using Serenna MCP API
  6. Update TodoWrite: Mark current step as "completed"
  7. Update TodoWrite: Mark next step as "in_progress" (if exists)
  8. Proceed to next step (NEVER stop until outputs: section)
```

#### 3. **Working with Agents**
- **`@agent-name`**: Call the specified specialized agent with the provided inputs
- **`@task`**: Execute the task yourself using the prompt and context provided. This should use the task tool. DO NOT USE SUB AGENTS
- Pass all specified inputs and instructions to the agent/task
- Pass explicit read memory instructions
- Pass explicit write memory instructions

#### 3.1. **Handling @task Agent Type**

When a step specifies `agent: "@task"`:

1. **Use the Task tool** - Never match to specialized agents based on prompt content
2. **Apply memory key injection** before calling the Task tool
3. **Do NOT auto-match** to agents like codebase-researcher based on keywords

#### 3.2. **Handling No Agent Specified**

When a step does NOT specify an agent, determine the execution method:

**If step has `from_user` field**:
- **Execute directly** (you handle the user interaction)
- **DO NOT use Task tool** - handle user prompting yourself
- Follow section 2.5 for user interaction handling

**If step has `task` field but no `from_user`**:
- **Execute yourself** using the task prompt and context
- Apply memory operations as specified
- **DO NOT use Task tool** for these cases

**If step has both `task` and `from_user`**:
- **Handle user interaction first** (section 2.5)
- **Then execute task** using the prompt and user response context

#### 4. **Memory Operations via Serenna MCP**

All memory operations MUST go through Serenna MCP APIs.

- **Reading Memory**:
  - When you see `from_memory: [memory_name]`
  - Use: `read_memory(memory_name)`

- **Writing Memory**:
  - When you see `memory.save_as: memory_name`
  - Use: `write_memory(memory_name, content, type)`

- **Memory Types for Writing**:
  - `summary`: Use Serenna's summarization tool before saving
  - `full`: Save complete output
  - `structured`: Format content then save

- **Listing Memories**:
  - Use: `list_memories()`

#### 4.1. **Automatic Memory Key Injection**

The orchestrator automatically injects memory instructions based on workflow step configuration:

**Auto-Injection Process:**
1. Parse step configuration for `from_user`, `from_memory` and `memory.save_as` fields
2. If `from_user` exists, handle user interaction first (see section 2.5)
3. Automatically append MANDATORY memory instructions to agent prompts
4. Pass enhanced prompt to agent/task

**Step Configuration Pattern:**
```yaml
- id: step_name
  agent: "@task"
  input:
    task:
      prompt: |
        [Your clean task description here]
    from_memory:
      - input_key1
      - input_key2
  memory:
    save_as: output_key
```

**Auto-Generated Agent Prompt:**
```
[Original task.prompt content]

[AUTO-INJECTED MEMORY INSTRUCTIONS]
MANDATORY: Load these keys from memory using Serenna memory tool:
- input_key1
- input_key2

MANDATORY: Write your results to memory key:
- output_key

MANDATORY: Confirm in your response what keys you wrote.
```

**Orchestrator Implementation:**
```python
def build_agent_prompt(step):
    prompt = step.input.task.prompt

    # Auto-inject memory instructions
    if step.input.from_memory:
        prompt += "\n\nMANDATORY: Load these keys from memory using Serenna memory tool:\n"
        for key in step.input.from_memory:
            prompt += f"- {key}\n"

    if step.memory.save_as:
        prompt += f"\nMANDATORY: Write your results to memory key:\n- {step.memory.save_as}\n"

    prompt += "\nMANDATORY: Confirm in your response what keys you wrote."
    return prompt
```

#### 5. **User Interaction**
- When `from_user` is specified, prompt the user with the exact question provided
- Wait for user response before proceeding
- Validate the response if validation rules are specified

#### 2.5. **MANDATORY User Interaction Handling**

When a workflow step contains a `from_user` field, you MUST:

1. **STOP workflow execution immediately** - Do not proceed to the next step
2. **Present the exact prompt** from `from_user.prompt` to the user
3. **WAIT for user response** - The workflow cannot continue until the user provides input
4. **Save the response** to memory using the `memory.save_as` key if specified
5. **Only then continue** to the next workflow step

**Critical Rule**: User interaction is BLOCKING - the workflow MUST pause until the user responds.

**Example Flow**:
```yaml
step:
  from_user:
    prompt: "What is your project goal?"
    type: text
  memory:
    save_as: "project_goal"
```

**Your Action**:
1. Display: "What is your project goal?"
2. STOP and wait for user input
3. When user responds, save to memory: `write_memory("project_goal", user_response, "summary")`
4. Continue to next step

#### 2.6. **Critical Execution Rules**

**MANDATORY - NO PREMATURE PLAN PRESENTATION:**

1. **NEVER present a plan during step execution** - Plans are internal work products
2. **Continue executing ALL steps** until one of these conditions:
   - User input is required (`from_user` field present)
   - Workflow reaches the `outputs:` section
3. **Ignore misleading step names** - Steps named "propose_final_plan" are still intermediate steps
4. **Only present output** when explicitly reached in the `outputs:` section

**FAILURE TO FOLLOW THESE RULES WILL:**
- Stop workflows prematurely
- Confuse users with incomplete work
- Prevent proper workflow completion

#### 6. **Error Handling**
- If a step fails and `on_error.action` is `retry`, retry up to `max_retries` times
- If `skip`, continue to the next step
- If `fail`, stop the workflow and report the error

#### 7. **Workflow Completion**

**THIS IS THE ONLY PLACE TO PRESENT FINAL OUTPUT TO THE USER**

- After ALL workflow steps are complete, prepare the outputs specified in the `outputs` section
- Read the specified memories using Serenna MCP APIs
- Format them according to the `format` field
- Present the final outputs to the user

**WARNING**: Do NOT present plans, results, or deliverables during step execution - only here in the outputs section.

#### 7.5. **Todo Management Rules (CRITICAL)**

**MANDATORY Todo Usage:**

1. **One todo per workflow step** - Each step ID becomes a todo item
2. **Always have exactly ONE in_progress todo** - Never more, never less
3. **Update immediately** - Mark completed before moving to next step
4. **Sequential execution** - Follow workflow order strictly
5. **User visibility** - Todo list shows user the current progress

**FAILURE TO USE TODOWRITE WILL CAUSE:**
- Loss of workflow state
- Steps executed out of order
- User confusion about progress
- Incomplete workflow execution

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

4. **Execute `propose_final_plan` step** (DO NOT present plan to user yet)
   - Read: `read_memory("development_plan")`, `read_memory("plan_review")`
   - Create final deliverable content
   - Save: `write_memory("final_plan", plan, "full")`
   - Continue to outputs section (do not stop here)

5. **Generate outputs** (ONLY HERE present to user)
   - Read: `read_memory("final_plan")`, `read_memory("plan_review")`
   - Format according to outputs specification
   - Present final deliverable to user

### Serenna MCP API Operations

Use these Serenna MCP operations:

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
- **NEVER present plans until outputs: section**
- **Continue executing ALL steps unless user input required**

### Command Pattern

1. Parse this workflow
2. Use Serenna MCP APIs for all memory operations
3. Execute each step using the appropriate tools/agents
4. Continue until all steps are complete
5. Present the final output