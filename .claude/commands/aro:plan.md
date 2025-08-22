# /aro:plan

**Purpose**: Execute a comprehensive project planning workflow using AI agents and persistent memory to analyze requirements, research codebase, and deliver a reviewed development plan.

## Usage
- `/aro:plan` - Start the complete planning workflow
- `/aro:plan [project description]` - Start with initial project context

## ⚠️ CRITICAL: REQUIRED SETUP - DO NOT SKIP ⚠️

### STEP 0: LOAD WORKFLOW INSTRUCTIONS (MANDATORY)

**YOU MUST COMPLETE THIS BEFORE PROCEEDING:**

1. **IMMEDIATELY load the workflow instructions file:**
   - Path: `$HOME/.claude/instructions/workflow-instructions.md`
   - Use the Read tool to load this file NOW

**FAILURE TO LOAD THESE INSTRUCTIONS WILL CAUSE THE WORKFLOW TO FAIL**

## Workflow Definition

```yaml
workflow:
  id: project_planning
  name: "Comprehensive Project Planning Workflow"
  description: "Analyzes a project, asks questions, researches codebase, and creates a reviewed development plan"

steps:
  # Step 1: Ask Project Goal
  - id: ask_project_goal
    name: "Understand Project Goal"
    description: "Ask the user what they want to plan"

    input:
      task:
        prompt: "Engage with the user to understand their project goal and requirements"
        context: "Be thorough in understanding the scope and objectives"
      from_user:
        prompt: "What would you like to plan? Please describe your project goal and any specific requirements."
        type: text

    memory:
      save_as: "aro:plan:project_goal"
      type: summary

  # Step 2: Analyze and ask top 10 questions
  - id: analyze_and_question
    name: "Analyze the project goal and Generate Questions"
    description: "Analyze the the project goal and ask the top 10 clarifying questions"
    agent: "@agent-question-generator"
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

    memory:
      save_as: "aro:plan:project_questions"
      type: full

  # Step 3: Get User Clarifications
  - id: get_user_clarifications
    name: "Get User Clarifications"
    description: "Present questions to user and collect their responses"
    depends_on:
      - analyze_and_question

    input:
      from_user:
        prompt: "Based on your project goal, I've generated some important questions to ensure we create the best plan. Please provide answers to help clarify the requirements and approach."
        type: text

    memory:
      save_as: "aro:plan:user_clarifications"
      type: full

  # Step 4: Compile research topics
  - id: compile_research_topics
    name: "Compile Research Topics"
    description: "Create a list of specific codebase areas to research"
    agent: "@agent-sonnet"
    depends_on:
      - get_user_clarifications

    input:
      task:
        prompt: |
          Based on the project goal, questions, and user clarifications, compile a comprehensive list
          of research topics and areas in the codebase that need to be examined.
          Include:
          - Specific modules, classes, or functions to analyze
          - Architecture patterns to understand
          - Dependencies to review
          - Configuration and deployment aspects
          - Test coverage areas
        context: "This list will guide the codebase research phase"

    memory:
      save_as: "aro:plan:research_topics"
      type: structured

  # Step 5: Research the codebase
  - id: research_codebase
    name: "Research Codebase"
    description: "Thoroughly research the codebase based on identified topics"
    agent: "@agent-codebase-researcher"
    depends_on:
      - compile_research_topics

    input:
      task:
        prompt: |
          Research the codebase based on the identified topics to understand
          the current implementation and architecture. Analyze the code structure,
          patterns, dependencies, and identify areas for improvement.

          Research Parameters:
          - Depth: comprehensive
          - Include Dependencies: true
          - Analyze Patterns: true
        context: "Provide detailed analysis of current codebase implementation"
      from_memory:
        - "aro:plan:research_topics"
        - "aro:plan:project_goal"
        - "aro:plan:user_clarifications"
      static:
        depth: comprehensive
        include_dependencies: true
        analyze_patterns: true

    memory:
      save_as: "aro:plan:codebase_research"
      type: full
      include_context: true

  # Step 6: Compile a plan
  - id: compile_plan
    name: "Create Development Plan"
    description: "Compile a comprehensive development plan based on research"
    agent: "@agent-plan-compiler"
    depends_on:
      - research_codebase

    input:
      task:
        prompt: |
          Based on all the gathered information, create a detailed development plan that includes:
          - Executive summary of the project approach
          - Phased implementation strategy (3-5 phases)
          - Technical architecture decisions
          - Step by step instructions
          - Dependencies and integration points
          - Success criteria and validation approach
        context: "This should be a comprehensive, actionable development plan"
      from_memory:
        - "aro:plan:project_goal"
        - "aro:plan:project_questions"
        - "aro:plan:user_clarifications"
        - "aro:plan:codebase_research"
      static:
        plan_format: "detailed"
        include_timeline: true
        include_risks: true

    memory:
      save_as: "aro:plan:development_plan"
      type: full

  # Step 7: Review the plan
  - id: review_plan
    name: "Review Plan Against Standards"
    description: "Review the plan for compliance with standards and best practices"
    agent: "@agent-plan-reviewer"
    depends_on:
      - compile_plan

    input:
      task:
        prompt: |
          Review the development plan for compliance with standards and best practices.
          Evaluate against the specified criteria and provide feedback for improvement.

          Review Criteria:
          - Technical feasibility
          - Security compliance
          - Scalability
          - Maintainability
          - Resource efficiency
        context: "Provide detailed review with specific recommendations"
      from_memory:
        - "aro:plan:development_plan"
        - "aro:plan:codebase_research"
      static:
        review_criteria:
          - technical_feasibility
          - security_compliance
          - scalability
          - maintainability
          - resource_efficiency

    memory:
      save_as: "aro:plan:plan_review"
      type: structured
      include_context: false

  # Step 8: Propose final plan to user
  - id: propose_final_plan
    name: "Propose Final Plan"
    description: "Take feedback and propose a refined plan to the user"
    agent: "@agent-plan-compiler"
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
        - "aro:plan:development_plan"
        - "aro:plan:plan_review"
        - "aro:plan:project_goal"

    memory:
      save_as: "aro:plan:final_plan"
      type: full

outputs:
  - name: "aro:plan:final_plan"
    format: markdown
    description: "The complete, reviewed development plan"
```