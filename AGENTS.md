# AGENTS.md

## Project Overview
This file contains essential configuration and commands for opencode to work effectively with this codebase. It serves as a reference for automated agents and human developers.

## Critical: The tools that you have access to

- `fabric` -- an AI-powered multipurpose tool. Details are in `FABRIC.md`
    - Use like a bash command: send relevant input from STDIN to the command
        - e.g. `curl example.com/article | analyze_prose_json`
- **OpenCode Agents** -- specialized AI agents configured for specific tasks (`.opencode/agent/`)
- `subagents/` -- legacy AI agents (deprecated, use OpenCode agents instead)

### Workflow

Use a fabric command if you want to perform a specific task that it can do.

Use specialized agents for domain-specific tasks:
- **security-auditor**: For security audits and vulnerability identification in code
- **code-quality**: For enforcing secure coding practices and quality standards
- **content-writer**: For creating clear, engaging content and documentation

### Available Specialized Agents
- **security-auditor** (`.opencode/agent/security-auditor.md`): Performs security audits, focuses on logic bugs, DoS vulnerabilities, input validation, and blockchain security. Use when code needs security review.
- **code-quality** (`.opencode/agent/code-quality.md`): Enforces ultra-secure coding practices with bounded resource management. Use when implementing or reviewing code for quality and security standards.
- **content-writer** (`.opencode/agent/content-writer.md`): Creates content with clear, high-energy prose. Use when writing blog posts.
