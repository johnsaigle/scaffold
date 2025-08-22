# AGENTS.md

## Project Overview
This file contains essential configuration and commands for opencode to work effectively with this codebase. It serves as a reference for automated agents and human developers.

## Critical: The tools that you have access to

- `fabric` -- an AI-powered multipurpose tool. Details are in `FABRIC.md`
    - Use like a bash command: send relevant input from STDIN to the command
        - e.g. `curl example.com/article | analyze_prose_json`
- `subagents/` -- specific AI agents that can be used to perform specialized tasks.


### Workflow

Use a fabric command if you want to perform a specific task that it can do.

Use an agent if you are working in a particular domain or task:
- `security-engineer`: Used for coding and quality assurance.
- `writer`: Used for writing content, especially blog posts.
- `code-auditor`: Used for high-signal secure code review and analysis.
