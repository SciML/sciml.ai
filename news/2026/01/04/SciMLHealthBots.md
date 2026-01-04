@def rss_pubdate = Date(2026,1,4)
@def rss = """Introducing SciML Health Bots: Lowering Barriers While Raising Standards"""
@def published = " 4 January 2026 "
@def title = "Introducing SciML Health Bots: Lowering Barriers While Raising Standards"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# Introducing SciML Health Bots: Lowering Barriers While Raising Standards

Here's a question that has haunted open-source maintainers forever: **How do you make it easier for new contributors while simultaneously demanding more from your codebase?**

Traditionally, these goals conflict. Strict requirements—comprehensive tests, type stability, performance benchmarks, static analysis—create barriers. New contributors must learn not just the code, but all the rules. They submit a PR, CI fails for reasons they don't understand, and they give up. Meanwhile, maintainers spend their time explaining rules instead of reviewing code.

SciML has 200+ packages. We're on the cutting edge of Julia, often the first to hit compiler edge cases and ecosystem rough spots. We *need* strict standards—trim compatibility, static interfaces, performance guarantees. But we also desperately need contributors. The ecosystem is too large for any team to maintain alone.

**Our answer: AI agents that enforce the hard stuff, so humans can focus on the interesting stuff.**

## The Paradox Resolved

The insight is simple: strictness and accessibility only conflict when *humans* must enforce the rules.

When bots enforce rules:
- **Contributors don't need to memorize them.** Submit your PR. If something's wrong, a bot explains what and why.
- **No tribal knowledge required.** You don't need to know "oh, that CI failure is a known upstream issue, ignore it." If CI is red, it's your PR. If it's green, you're good.
- **Instant, patient feedback.** Bots don't get frustrated explaining the same thing for the hundredth time.
- **Maintainers review code, not compliance.** Human review time goes to architecture and logic, not checking if you ran the formatter.

The result: we can demand *more* from the code while asking *less* from contributors.

## What We Now Require

With bot enforcement, we're raising the bar:

**Always-green CI.** Not "usually green" or "green except for known issues." If you see green, merge. If you see red, your PR needs work. No exceptions, no ambiguity.

**Trim compatibility.** All SciML packages are moving toward full compatibility with Julia's static compilation. Explicit imports, no runtime code generation, predictable dispatch.

**Static interfaces.** Type-stable APIs, consistent patterns across packages, proper use of abstract types.

**Performance as a bug.** Regressions are tracked and fixed like any other defect. Silent slowdowns don't accumulate.

These are ambitious requirements. Most Julia packages don't enforce them. We can, because bots do the enforcing.

## How It Works for Contributors

### Submit Your PR

You don't need to know all the rules. Write your code, submit the PR.

### Get Clear Feedback

CI runs. If something fails, it's specific to your changes. No wading through pre-existing failures. No asking "is this failure real or known?"

If a bot finds an issue—missing explicit import, type instability in a hot path, performance regression—it comments with a clear explanation and often a suggested fix.

### Iterate Quickly

Fix the issues, push again. Bots re-check. Green means done.

### Merge with Confidence

When CI is green, merge. You don't need maintainer approval for compliance—bots already verified that. Maintainers focus on whether the change is *good*, not whether it follows rules.

## How Bots Handle the Hard Stuff

### Upstream Breaks? Not Your Problem.

When Julia updates or a dependency changes and it breaks our tests, bots detect it. They don't leave a red badge for you to puzzle over. Instead:

1. They identify the upstream cause
2. They disable affected tests *conditionally* (only for the broken configuration)
3. They open a `bug`-labeled issue to track resolution
4. CI stays green

You never see mysterious failures from problems that aren't yours.

### Static Analysis, Automatically

Bots continuously scan for:
- Missing explicit imports (needed for trim)
- Type instabilities in critical paths
- Inconsistent interfaces across packages
- Deprecated API usage

When they find issues, they either fix them directly or open clear issues explaining what needs to change.

### Performance Monitoring

Bots run benchmarks, track results over time, and flag regressions. If your PR makes something slower, you'll know—with numbers, not vague complaints.

## What This Means in Practice

### For New Contributors

**Before bots:**
1. Find an issue you want to fix
2. Write the code
3. Submit PR
4. CI fails with 3 red checks
5. Ask in Discord: "Are these failures real?"
6. Learn that two are "known issues" and one is yours
7. Fix your issue
8. Wait for maintainer to notice your PR
9. Get feedback about formatting/style
10. Fix, push, wait, iterate...

**With bots:**
1. Find an issue you want to fix
2. Write the code
3. Submit PR
4. CI green? Merge. CI red? It's your code—fix shown.
5. Done.

### For Experienced Contributors

Less time explaining rules to newcomers. Less time triaging CI failures. Less time on mechanical fixes. More time on interesting problems.

### For Maintainers

You set the standards—trim compatibility, static interfaces, performance requirements. Bots enforce them. Your review time goes to architecture, correctness, design. Not "please run the formatter" or "this breaks the type stability check."

## The Architecture

48 concurrent Claude agents running continuously:

- **Monitor Daemon:** Watches GitHub, spawns agents for issues
- **CI Health Agents:** Keep all repos green, track upstream failures
- **Issue Solvers:** Investigate bugs, prioritize `bug`-labeled issues
- **Proactive Maintenance:** Static analysis, performance checks, interface verification

Everything's observable:

```bash
sciml-agents list          # What's running now?
sciml-agents attach 3      # Watch an agent work
sciml-ctl tasks show       # What tasks are enabled?
sciml-metrics summary      # Success rates, trends
```

## The Bigger Picture

Open source has a sustainability problem. Maintainer burnout is real. The traditional answer is "lower your standards or burn out enforcing them."

We're trying a different answer: **automate enforcement so standards can rise without burning anyone out.**

SciML packages should be trim-compatible, type-stable, fast, and well-tested. These shouldn't be aspirational goals that we sometimes achieve. They should be guaranteed properties that bots maintain.

And contributing shouldn't require a PhD in our CI system. Submit code, get clear feedback, iterate, merge. That's it.

## Try It Now

The bots are running. You'll see their PRs, their comments, their issue investigations. When you contribute to SciML:

- **Trust the CI.** Green means merge.
- **Read bot comments.** They explain what's wrong and often how to fix it.
- **Don't worry about rules you don't know.** Bots know them.
- **Focus on your code.** That's what matters.

Welcome to SciML. The bots will help you contribute. The maintainers will help you build something great.

---

*Questions? Join us on [GitHub Discussions](https://github.com/orgs/SciML/discussions) or [Julia Discourse](https://discourse.julialang.org/). Found a bot doing something weird? Open an issue—we're always improving.*
