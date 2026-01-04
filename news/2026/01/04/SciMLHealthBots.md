@def rss_pubdate = Date(2026,1,4)
@def rss = """Introducing SciML Health Bots: AI Agents Keeping 200+ Packages Green"""
@def published = " 4 January 2026 "
@def title = "Introducing SciML Health Bots: AI Agents Keeping 200+ Packages Green"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# Introducing SciML Health Bots: AI Agents Keeping 200+ Packages Green

Maintaining an open-source ecosystem is hard. Maintaining one with over 200 actively developed packages across differential equations, optimization, machine learning, and scientific computing? That's a full-time job for an entire team. As SciML has grown from a handful of packages to the comprehensive scientific computing ecosystem it is today, we've faced an increasingly difficult challenge: how do you keep everything working, tested, and healthy when there simply aren't enough hours in the day?

Today, we're excited to share our answer: **SciML Health Bots**—a fleet of AI agents that continuously monitor, diagnose, and fix issues across the entire SciML ecosystem.

## The Problem: Scale Without Sacrifice

The SciML ecosystem has always prioritized quality. Every package needs comprehensive tests. CI must pass. Documentation should be accurate. But as we've grown, the maintenance burden has grown faster than our contributor base. A typical week might see:

- Dozens of new issues opened across different repositories
- Upstream Julia changes breaking downstream packages
- Dependency updates requiring compat bumps
- CI failures from transient infrastructure issues vs. real bugs
- Stale issues that may already be fixed

Each of these requires human attention—investigating, triaging, fixing, and verifying. Multiply this by 200+ packages, and you quickly understand why even the most dedicated maintainers can fall behind.

## The Solution: Always-On AI Maintenance

SciML Health Bots is a system of Claude-powered agents running continuously in the background. These agents don't replace human maintainers—they augment them, handling the repetitive investigative work that consumes so much time.

### What the Bots Do

**CI Health Monitoring**: Agents regularly check CI status across all SciML repositories. When they find failures, they don't just report them—they investigate root causes, create fixes, and open PRs. The goal is simple: **all CI checks should be green, all the time.**

**Issue Investigation**: When new issues are opened, agents analyze them, attempt to reproduce the problem, and either fix the bug or provide detailed diagnostic information. Issues with the `bug` label are automatically prioritized.

**Dependency Management**: When upstream packages release new versions, agents check for compatibility issues, bump version constraints in `Project.toml`, and verify tests still pass.

**Proactive Maintenance**: During quiet periods, agents work through a backlog of improvement tasks:
- Adding explicit imports for better precompilation
- Fixing deprecation warnings
- Improving documentation
- Checking interface consistency across packages
- Reviewing benchmarks for performance regressions

### The "Always Green" Philosophy

Traditional CI tells you when something breaks. Our health bots go further: they fix it. When a CI failure can't be immediately fixed, the agents employ a hierarchy of responses:

1. **Fix the bug** - The ideal outcome
2. **Bump compat bounds** - For version compatibility issues
3. **Skip conditionally** - When specific versions have known issues
4. **Disable and track** - Last resort, with a bug-labeled issue for follow-up

The key principle: **CI should never show red**. Failures are either fixed or converted to tracked issues with the `bug` label. This means when you see a red CI badge, it's a genuine new problem—not accumulated technical debt.

### Smart Prioritization

Not all issues are equal. The bots prioritize work based on:

- **Bug labels**: Issues marked `bug` get worked on first
- **CI health**: Failing CI takes priority over new features
- **Staleness**: Old issues are checked to see if they're already resolved
- **Impact**: Changes affecting multiple packages get attention faster

## Architecture: 48 Agents, One Mission

Under the hood, SciML Health Bots runs up to 48 concurrent Claude agents, each in its own isolated sandbox. The system includes:

- **Monitor Daemon**: Polls GitHub notifications and spawns agents for new issues
- **State Tracker**: SQLite database preventing duplicate work and tracking progress
- **Idle Behaviors**: Proactive tasks when agent capacity is available
- **CLI Tools**: `sciml-ctl`, `sciml-agents`, `sciml-status` for monitoring and control

Each agent operates in a full development environment: cloning repos, creating branches, running tests, and opening PRs. They iterate on CI failures, respond to review comments, and update issues with their findings.

### Observability

Everything is logged and traceable. You can:

```bash
# See what agents are working on
sciml-agents list

# Attach to watch an agent work in real-time
sciml-agents attach 3

# Check system health
sciml-ctl status

# View metrics
sciml-metrics summary
```

When an agent opens a PR or comments on an issue, it's clearly marked as bot-generated. Maintainers retain full control to approve, modify, or reject any changes.

## What This Means for You

### For Users

More reliable packages. Faster bug fixes. Issues that get investigated promptly rather than sitting for months. When you report a bug, there's a good chance an agent will have a diagnosis or fix ready before a human maintainer even sees it.

### For Contributors

Less time on maintenance drudgery, more time on interesting problems. The bots handle the "did the new Julia release break anything?" checks, the dependency bumps, the CI babysitting. Contributors can focus on features, algorithms, and architecture.

### For the Ecosystem

A healthier, more sustainable open-source project. The bots don't get tired, don't get discouraged by repetitive work, and don't take vacations. They provide a consistent baseline of maintenance that ensures the ecosystem keeps running smoothly.

## Looking Ahead

This is just the beginning. We're continuing to improve the health bots with:

- Better diagnosis of complex, multi-package issues
- Automatic generation of regression tests from bug reports
- Performance regression detection and bisection
- Smarter prioritization based on user impact

We're also exploring how to make this tooling available to other Julia ecosystems. The challenges of maintaining a large package collection aren't unique to SciML, and we'd love to see similar systems helping other communities.

## Try It Out

The SciML Health Bots are already running. You'll see their PRs and comments across SciML repositories, marked with the telltale "Generated with Claude Code" signature. If you're curious about a specific interaction or want to understand why a bot made a particular change, the full context is always available in the PR or issue thread.

For maintainers of SciML packages: welcome your new robot colleagues. They're here to help.

---

*Have questions about SciML Health Bots? Join the discussion on [GitHub Discussions](https://github.com/orgs/SciML/discussions) or the [Julia Discourse](https://discourse.julialang.org/). And if you're interested in contributing to the bots themselves, the system is open source and welcomes improvements!*
