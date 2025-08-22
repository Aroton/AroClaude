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

  # Step 2: Generate Initial Research Questions
  - id: generate_initial_research_questions
    name: "Generate Initial Research Questions"
    description: "Create internal questions to guide initial codebase research"
    depends_on:
      - ask_project_goal

    input:
      task:
        prompt: |
          Based on the project goal, generate internal research questions that will help
          understand the current codebase before asking the user clarifying questions.
          Focus on:
          - What architecture patterns might be relevant
          - What existing implementations to look for
          - What dependencies and frameworks to investigate
          - What configuration and deployment aspects to examine
        context: "These questions will guide initial codebase research to inform better user questions"

    memory:
      save_as: "aro:plan:initial_research_questions"
      type: structured

  # Step 3: Initial Codebase Research
  - id: initial_codebase_research
    name: "Initial Codebase Research"
    description: "Quick research pass to understand existing codebase patterns and architecture"
    agent: "@agent-codebase-researcher"
    depends_on:
      - generate_initial_research_questions

    input:
      task:
        prompt: |
          Perform an initial scan of the codebase to understand existing patterns,
          architecture, and implementations relevant to the project goal.
          This research will inform better questions for the user.

          Research Parameters:
          - Depth: initial_scan
          - Focus: architecture_patterns
          - Include Dependencies: true
        context: "Quick research to inform user question generation"
      from_memory:
        - "aro:plan:initial_research_questions"
        - "aro:plan:project_goal"
      static:
        depth: initial_scan
        focus: architecture_patterns
        include_dependencies: true

    memory:
      save_as: "aro:plan:initial_codebase_research"
      type: full

  # Step 4: Generate User Questions
  - id: generate_user_questions
    name: "Generate Informed User Questions"
    description: "Create user-facing questions informed by initial codebase research"
    depends_on:
      - initial_codebase_research

    input:
      task:
        prompt: |
          Based on the project goal and initial codebase research, generate the top questions
          that need to be answered by the user to create a comprehensive plan. These should be
          specific questions with options, informed by understanding of the existing codebase.
          Focus on questions that will uncover hidden complexity and requirements.
        context: "Generate informed questions based on actual codebase understanding"
      from_memory:
        - "aro:plan:initial_codebase_research"

    memory:
      save_as: "aro:plan:user_questions"
      type: full

  # Step 5: Get User Clarifications
  - id: get_user_clarifications
    name: "Get User Clarifications"
    description: "Present informed questions to user and collect their responses"
    depends_on:
      - generate_user_questions

    input:
      from_user:
        prompt: "Based on your project goal and my analysis of the existing codebase, I've generated some important questions to ensure we create the best plan. Please provide answers to help clarify the requirements and approach."
        type: text

    memory:
      save_as: "aro:plan:user_clarifications"
      type: full

  # Step 6: Compile Research Topics
  - id: compile_research_topics
    name: "Compile Comprehensive Research Topics"
    description: "Create a comprehensive list of codebase areas to research based on user input"
    depends_on:
      - get_user_clarifications

    input:
      task:
        prompt: |
          Based on the project goal, initial research, and user clarifications, compile a comprehensive list
          of research topics and areas in the codebase that need to be examined for detailed analysis.
          Include:
          - Specific modules, classes, or functions to analyze
          - Architecture patterns to understand in detail
          - Dependencies to review thoroughly
          - Configuration and deployment aspects
          - Test coverage areas
        context: "This list will guide the comprehensive codebase research phase"

    memory:
      save_as: "aro:plan:research_topics"
      type: structured

  # Step 7: Comprehensive Codebase Research
  - id: comprehensive_codebase_research
    name: "Comprehensive Codebase Research"
    description: "Thoroughly research the codebase with full context"
    agent: "@agent-codebase-researcher"
    depends_on:
      - compile_research_topics

    input:
      task:
        prompt: |
          Research the codebase comprehensively based on the identified topics to understand
          the current implementation and architecture. Analyze the code structure,
          patterns, dependencies, and identify areas for improvement.

          Research Parameters:
          - Depth: comprehensive
          - Include Dependencies: true
          - Analyze Patterns: true
        context: "Provide detailed analysis of current codebase implementation with full context"
      from_memory:
        - "aro:plan:research_topics"
        - "aro:plan:project_goal"
        - "aro:plan:user_clarifications"
        - "aro:plan:initial_codebase_research"
      static:
        depth: comprehensive
        include_dependencies: true
        analyze_patterns: true

    memory:
      save_as: "aro:plan:codebase_research"
      type: full
      include_context: true

  # Step 8: Compile a plan
  - id: compile_plan
    name: "Create Development Plan"
    description: "Compile a comprehensive development plan based on research"
    agent: "@agent-plan-compiler"
    depends_on:
      - comprehensive_codebase_research

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
        - "aro:plan:user_questions"
        - "aro:plan:user_clarifications"
        - "aro:plan:codebase_research"
        - "aro:plan:initial_codebase_research"
      static:
        plan_format: "detailed"
        include_timeline: true
        include_risks: true

    memory:
      save_as: "aro:plan:development_plan"
      type: full

  # Step 9: Review the plan
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

  # Step 10: Propose final plan to user
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