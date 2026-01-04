@def rss_pubdate = Date(2026,1,4)
@def rss = """Introducing SciML Health Bots: Lowering Barriers While Raising Standards"""
@def published = " 4 January 2026 "
@def title = "Introducing SciML Health Bots: Lowering Barriers While Raising Standards"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# Introducing SciML Health Bots: Lowering Barriers While Raising Standards

**How do you make contributing easier while demanding more from the code?**

SciML has 200+ packages on Julia's cutting edge. We need strict standards—trim compatibility, static interfaces, performance tracking. But strict requirements create barriers: new contributors submit PRs, CI fails mysteriously, they give up.

Our answer: **AI agents enforce the hard stuff, so humans focus on the interesting stuff.**

## The Key Insight

Strictness and accessibility only conflict when *humans* enforce the rules. With bots:

- Contributors don't memorize rules—bots explain violations
- No tribal knowledge about "known failures"—red means your code, green means merge
- Maintainers review architecture, not compliance

## New Standards

- **Always-green CI.** Green means merge. Red means your PR. No ambiguity.
- **Trim compatibility.** Explicit imports, static dispatch, no runtime codegen.
- **Static interfaces.** Type-stable APIs, consistent patterns.
- **Performance is a bug.** Regressions tracked and fixed automatically.

## Bot Types

13 specialized agents run continuously across all SciML repositories:

| Bot | Purpose |
|-----|---------|
| **CI Health Check** | Diagnose and fix CI failures, keep all repos green |
| **Issue Solver** | Investigate bugs, prioritize `bug`-labeled issues |
| **Dependency Update** | Handle upstream version bumps and breaking changes |
| **Explicit Imports** | Add explicit imports for trim compatibility |
| **Static Improvement** | Fix type instabilities and interface inconsistencies |
| **Performance Check** | Detect regressions, track benchmarks |
| **Deprecation Fix** | Update deprecated API usage |
| **Interface Check** | Verify consistent APIs across packages |
| **Docs Improvement** | Fix documentation issues |
| **Version Bump** | Check for needed releases |
| **Min Version Bump** | Update compat bounds |
| **Precompilation** | Improve load times |
| **Benchmark Check** | Monitor SciMLBenchmarks.jl |

Up to 48 agents run concurrently. Control which types are active:

```bash
sciml-ctl tasks show                    # See enabled bots
sciml-ctl tasks only ci_health_check    # Focus on CI health
sciml-agents list                       # See running agents
```

## The Bug Fix Flow

When CI Health Check detects a failure, it follows a resolution hierarchy:

**1. Try to fix it directly:**
- Cap a dependency version in `[compat]`?
- Fix the code?
- Make behavior conditional on Julia version?
- Add a missing explicit import?

**2. If it can't fix it, keep CI green anyway:**
- Mark the failing test as `@test_broken` or skip conditionally
- Open a `bug`-labeled issue with full diagnostics
- PR merges, CI stays green

**3. Issue Solver picks it up:**
- Issue Solver prioritizes `bug`-labeled issues
- It attempts deeper fixes the CI Health Check couldn't do
- If solved, removes the `@test_broken` marker and closes the issue

This creates a cycle: **CI stays green, but regressions are tracked as issues and continuously worked on.** Contributors never see mysterious red badges from problems that predate their PR. Maintainers see a clear issue queue of known problems being actively resolved.

## For Contributors

Submit your PR. If something's wrong, a bot explains what and suggests a fix. Green CI? Merge. You never see failures that aren't yours.

## The Result

Standards rise. Barriers fall. Contributors ship with confidence. Maintainers focus on code quality, not rule enforcement.

---

*The bots are running now across SciML repositories. Questions? [GitHub Discussions](https://github.com/orgs/SciML/discussions) or [Julia Discourse](https://discourse.julialang.org/).*
