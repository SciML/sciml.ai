@def rss_pubdate = Date(2026,1,4)
@def rss = """Introducing SciML Health Bots: Lowering Barriers While Raising Standards"""
@def published = " 4 January 2026 "
@def title = "Introducing SciML Health Bots: Lowering Barriers While Raising Standards"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# Introducing SciML Health Bots: Lowering Barriers While Raising Standards

**How do you make contributing easier while demanding more from the code?**

SciML has 200+ packages with stricter standards than most of the Julia ecosystem. We test for static compilability, type stability, and interface consistency. Many upstream packages don't—AD packages like Zygote and Enzyme frequently introduce regressions, and foundational packages like Distributions.jl don't test for `juliac --trim` compatibility or static interfaces.

This means SciML is often the first to discover upstream bugs. We file issues, contribute fixes, and wait. But in the meantime, CI stays red. Maintainers have to remember "oh yeah, that's the Zygote issue." Contributors unfamiliar with the repo see red badges and don't know if their PR broke something or if it's a known issue. Merging requires manually checking logs to verify "the right test" is failing. This process is time-consuming and error-prone.

We want to raise standards even higher—every SciML package compatible with `juliac --trim`. But that's only possible if we can handle the upstream breakage without drowning contributors in mysterious CI failures.

Our answer: **AI agents that track upstream issues, keep CI green, and let humans focus on real work.**

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
