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

## How It Works

**For contributors:** Submit your PR. If something's wrong, a bot explains what and suggests a fix. Green CI? Merge.

**For upstream breaks:** Bots detect when Julia or dependencies break our tests, disable affected tests conditionally, and open `bug`-labeled issues. You never see failures that aren't yours.

**For maintenance:** 48 concurrent agents handle CI health, issue investigation, static analysis, and performance monitoring continuously.

```bash
sciml-agents list          # See active agents
sciml-ctl tasks show       # Control what runs
```

## The Result

Standards rise. Barriers fall. Contributors ship with confidence. Maintainers focus on code quality, not rule enforcement.

---

*The bots are running now across SciML repositories. Questions? [GitHub Discussions](https://github.com/orgs/SciML/discussions) or [Julia Discourse](https://discourse.julialang.org/).*
