@def rss_pubdate = Date(2026,1,4)
@def rss = """Introducing SciML Health Bots: Higher Standards Through AI-Powered Automation"""
@def published = " 4 January 2026 "
@def title = "Introducing SciML Health Bots: Higher Standards Through AI-Powered Automation"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# Introducing SciML Health Bots: Higher Standards Through AI-Powered Automation

SciML is a large, fast-moving organization. With over 200 packages spanning differential equations, optimization, machine learning, and scientific computing, we're often the first to encounter the rough edges of Julia and its ecosystem. When a new Julia release has an edge case, when an upstream package makes a breaking change, when a compiler optimization reveals undefined behavior—SciML packages tend to find it first.

This is the price of being on the cutting edge. And it's a price we're happy to pay, because it means our users get access to the latest advances in scientific computing. But it also creates a challenge: how do you maintain hundreds of packages at the frontier without drowning in maintenance work?

Our answer isn't to lower standards. **It's to raise them—and use AI to enforce them.**

## The Vision: Stricter Rules, Higher Velocity

In the age of agentic AI, we see an opportunity to fundamentally change how open-source ecosystems operate. Rather than accepting that maintenance burden limits what we can demand of our packages, we're using AI agents to enforce higher standards than have traditionally been possible in Julia libraries.

**Our new requirements:**

- **Tests must always be green.** Not "usually green" or "green except for known issues." Green. Always.
- **All packages must be trim-compatible.** We're pushing toward fully static, tree-shakeable code.
- **Static interfaces everywhere.** Type stability, consistent APIs, predictable behavior.
- **Performance is a bug.** Regressions are tracked, investigated, and fixed like any other defect.

These are ambitious standards. They're stricter than what most Julia packages enforce. And that's exactly the point.

## How Bots Enable Stricter Standards

The traditional problem with strict standards is enforcement. Every upstream change, every new Julia release, every dependency update can break something. Without automation, maintaining strict standards across 200+ packages would require an army of maintainers doing nothing but firefighting.

SciML Health Bots changes this equation. Here's how:

### Continuous Monitoring, Instant Response

Agents continuously monitor CI across all SciML repositories. When something breaks—whether from our code or upstream changes—they don't just report it. They investigate the root cause, determine if it's our bug or an upstream issue, and take appropriate action.

### Upstream Failures Become Tracked Issues, Not Red Badges

This is crucial: **when an upstream change breaks our tests, the failure doesn't show as a red CI badge.** Instead, agents identify the upstream cause, disable the affected tests conditionally, and open a bug-labeled issue to track the problem.

Why? Because a red CI badge should mean one thing: "don't merge this PR." If red badges accumulate from upstream issues, contributors lose trust in CI. They start merging despite red badges. Standards erode.

By keeping CI green and tracking upstream issues separately, we maintain the integrity of the merge signal. Green means merge. Red means stop. Always.

### The Hierarchy of Responses

When agents find a failure, they work through a strict hierarchy:

1. **Fix the bug** — If it's our code, fix it
2. **Bump compat bounds** — If an old dependency version is broken, require a newer one
3. **Version-conditional skip** — If we need to support old versions but they're broken, skip tests only on those versions
4. **Track and disable** — Last resort: disable the failing tests, but always with a `bug`-labeled issue

Every workaround creates a tracked issue. Nothing gets swept under the rug. The issue queue becomes the source of truth for technical debt.

### Bug Label Prioritization

Issues with the `bug` label are automatically prioritized by the agent system. This creates a feedback loop: when agents identify problems they can't immediately fix, they create `bug` issues. Other agents then prioritize those issues for resolution.

The result: problems surface quickly and get addressed quickly.

## What We're Building Toward

The health bots are part of a larger vision for SciML:

### Trim Compatibility

We're working toward making all SciML packages compatible with Julia's upcoming trim/tree-shaking capabilities. This means:
- Explicit imports throughout
- No runtime code generation where avoidable
- Static method dispatch where possible

Agents actively work on this: adding explicit imports, identifying dynamic dispatch patterns, and ensuring packages can be statically compiled.

### Static Interfaces

Consistent, predictable interfaces across the ecosystem. Agents check for:
- Type stability in critical paths
- Consistent API patterns across packages
- Proper use of abstract types and interfaces

### Performance Tracking

Performance regressions are bugs. Agents monitor benchmarks, detect slowdowns, and open issues when performance degrades. No silent regressions.

## For Contributors: Simplicity Through Consistency

Strict standards might sound intimidating, but they actually make contributing easier:

**Clear merge criteria:** Green CI means merge. No guessing, no "oh that failure is fine, it's a known issue."

**Automated enforcement:** You don't need to remember all the rules. Agents catch issues before they're merged.

**Less debugging:** When tests are always green, you know a new red is your PR's problem, not pre-existing debt.

**Faster iteration:** Trust the CI. If it's green, ship it.

The agents handle the tedious enforcement work so contributors can focus on building features and fixing real bugs.

## Architecture Overview

The system runs up to 48 concurrent Claude agents, each in isolated sandboxes:

- **Monitor Daemon:** Watches GitHub notifications, spawns agents for new issues
- **State Tracker:** SQLite database preventing duplicate work
- **Idle Behaviors:** Proactive tasks (static analysis, interface checks, benchmark monitoring)
- **CLI Tools:** Full observability into what agents are doing

```bash
sciml-ctl tasks only ci_health_check  # Focus agents on CI health
sciml-agents list                      # See active agents
sciml-agents attach 3                  # Watch an agent work
sciml-metrics summary                  # View success rates
```

## The Bottom Line

SciML Health Bots isn't about making our standards easier to meet. It's about making higher standards sustainable.

We want every SciML package to have always-green CI, trim compatibility, static interfaces, and tracked performance. These are ambitious goals for 200+ packages. But with AI agents handling the continuous enforcement and upstream tracking, we believe they're achievable.

The result: a faster-moving, more reliable ecosystem. Contributors ship with confidence. Users get stable packages. And when the next Julia release inevitably breaks something, the bots will be there to catch it, track it, and fix it.

---

*The SciML Health Bots are running now. You'll see their PRs and comments across SciML repositories. Have questions? Join us on [GitHub Discussions](https://github.com/orgs/SciML/discussions) or [Julia Discourse](https://discourse.julialang.org/).*
