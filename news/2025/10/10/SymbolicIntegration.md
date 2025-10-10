@def rss_pubdate = Date(2025,10,10)
@def rss = """SymbolicIntegration.jl: Best-of-Both-Worlds Symbolic Integration with Risch and 3400+ Integration Rules"""
@def published = " 10 October 2025 "
@def title = "SymbolicIntegration.jl: Best-of-Both-Worlds Symbolic Integration with Risch and 3400+ Integration Rules"
@def authors = """<a href="https://github.com/ChrisRackauckas">Chris Rackauckas</a>"""

# SymbolicIntegration.jl: Best-of-Both-Worlds Symbolic Integration with Risch and 3400+ Integration Rules

We're excited to announce that [SymbolicIntegration.jl](https://github.com/JuliaSymbolics/SymbolicIntegration.jl)
has reached v3.1.0 with a powerful new feature: a hybrid integration system that combines the theoretical
completeness of the Risch algorithm with the practical breadth of rule-based integration. This release brings
over 3400 integration rules from the renowned [RUBI (Rule-Based Integrator)](https://rulebasedintegration.org/)
system, originally from Mathematica, now available natively in Julia.

## The Problem: No Single Method Rules Them All

Symbolic integration is notoriously difficult. While the Risch algorithm is theoretically complete for
elementary functions, it struggles with algebraic functions like `sqrt(x)` and non-integer powers. On the
other hand, rule-based systems excel at pattern matching and can handle a vast variety of special cases, but
lack the theoretical guarantees of algorithmic completeness.

The solution? Use both. SymbolicIntegration.jl now automatically tries the Risch method first, then falls
back to rule-based integration if needed. This "best-of-both-worlds" approach ensures you get the theoretical
rigor when possible and practical results when necessary.

## Quick Start

```julia
using Pkg
Pkg.add("SymbolicIntegration")

using SymbolicIntegration, Symbolics

@variables x

# Works with Risch
integrate(exp(2x) + 2x^2 + sin(x))
# (1//2)*exp(2x) + (2//3)*(x^3) - cos(x)

# Falls back to rule-based for sqrt
integrate(sqrt(x))
# ┌ Warning: NotImplementedError: integrand contains unsupported expression sqrt(x)
# └ @ SymbolicIntegration
#
#  > RischMethod failed returning ∫(sqrt(x), x)
#  > Trying with RuleBasedMethod...
#
# (2//3)*(x^(3//2))
```

## The Intelligent Fallback System

When you call `integrate(f, x)` without specifying a method, SymbolicIntegration.jl follows a smart strategy:

1. **First attempt: Risch Method** - Tries the complete algorithm for elementary transcendental functions
2. **Fallback: Rule-Based Method** - If Risch fails (unsupported functions, algebraic expressions), automatically tries 3400+ integration rules
3. **Result: Maximum coverage** - You get a solution whenever one is available in either system

This automatic fallback means you don't need to know which method works for which integral. Just call
`integrate()` and let the system figure it out.

## Feature Comparison

Here's what each method brings to the table:

| Feature | Risch | Rule-based |
|---------|-------|------------|
| Rational functions | ✅ | ✅ |
| Non-integer powers | ❌ | ✅ |
| Exponential functions | ✅ | ✅ |
| Logarithms | ✅ | ✅ |
| Trigonometric functions | ❓ | Sometimes |
| Hyperbolic functions | ✅ | Sometimes |
| Non-elementary integrals | ❌ | Most of them |
| Multiple symbols | ❌ | ✅ |

The complementary strengths of these methods ensure broad coverage across different integral types.

## Rule-Based Integration: 3400+ Rules from RUBI

The rule-based integration system in SymbolicIntegration.jl is based on a comprehensive translation of the
RUBI (Rule-Based Integrator) package from Mathematica. With over 3400 integration rules, it handles an
incredibly diverse range of integrals through sophisticated pattern matching.

### How It Works

Each rule is defined using SymbolicUtils pattern matching and specifies:
- A pattern to match against (e.g., `∫(x^m, x)`)
- Conditions to check before applying the rule
- The transformation to apply

For example, here's a simple rule:

```julia
@rule ∫((~x)^(~!m), (~x)) =>
    !contains_var((~m), (~x)) &&
    !eq((~m), -1) ?
    (~x)^((~m) + 1) / ((~m) + 1) : nothing
```

When you integrate an expression, the system walks the expression tree and tries to apply rules at each node
containing an integral. Rules are ordered from specific to general, ensuring the most appropriate
transformation is applied.

### Example: Complex Integration with Verbose Output

You can see exactly which rules are applied with the `verbose` option:

```julia
integrate(sqrt(4 - 12*x + 9*x^2) + sqrt(1+x), x, RuleBasedMethod(verbose=true))

# ┌-------Applied rule 0_1_0 on ∫(sqrt(1 + x) + sqrt(4 - 12x + 9(x^2)), x)
# | ∫(a + b + ..., x) => ∫(a,x) + ∫(b,x) + ...
# └-------with result: ∫(sqrt(4 - 12x + 9(x^2)), x) + ∫(sqrt(1 + x), x)
#
# ┌-------Applied rule 1_1_1_1_4 on ∫(sqrt(1 + x), x)
# | ∫((a + b * x)^m, x) => (a + b * x)^(m + 1) / (b * (m + 1))
# └-------with result: (2//3)*((1 + x)^(3//2))
#
# ┌-------Applied rule 1_2_1_1_3 on ∫(sqrt(4 - 12x + 9(x^2)), x)
# | ∫((a + b*x + c*x^2)^p, x) => ((b + 2*c*x)*(a + b*x + c*x^2)^p) / (2*c*(2*p + 1))
# └-------with result: (1//36)*(-12 + 18x)*((4 - 12x + 9(x^2))^(1//2))
#
# Final result: (2//3)*((1 + x)^(3//2)) + (1//36)*(-12 + 18x)*sqrt(4 - 12x + 9(x^2))
```

This transparency is invaluable for understanding how the integration proceeds and debugging complex cases.

## Explicit Method Selection

While the automatic fallback is convenient, you can also explicitly choose which method to use:

```julia
# Use only Risch
integrate(x^2 + 1, x, RischMethod(use_algebraic_closure=false))

# Use only rule-based, skip Risch entirely
integrate(sqrt(x), x, RuleBasedMethod(verbose=false))

# Configure rule-based options
integrate(f, x, RuleBasedMethod(verbose=true, use_gamma=false))
```

The `RuleBasedMethod` accepts options for:
- `verbose`: Print the integration rules applied (default: `true`)
- `use_gamma`: Allow rules that introduce the gamma function (default: `false`)

## Risch Method: Theoretical Completeness

The Risch implementation is based on Manuel Bronstein's definitive book
["Symbolic Integration I: Transcendental Functions"](https://link.springer.com/book/10.1007/b138171).
This provides a complete algorithm for integrating elementary transcendental functions, including:

- Rational functions
- Exponential functions
- Logarithms
- Hyperbolic functions
- Certain trigonometric functions

The Risch method guarantees that if an elementary antiderivative exists within its supported function classes,
it will find it. If no elementary antiderivative exists, it correctly returns the integral unevaluated.

## Extensive Testing: 27,585 Verified Integrals

To ensure correctness and coverage, SymbolicIntegration.jl includes a comprehensive test suite with 27,585
solved integrals taken from the RUBI test suite:

- 1,796 tests from independent test suites
- 25,798 tests for algebraic functions
- Continuous integration verifies correctness on every commit

This extensive testing ensures that the package handles both common and edge cases reliably.

## Integration with the SciML Ecosystem

SymbolicIntegration.jl seamlessly integrates with the broader SciML symbolic computing stack:

- **Symbolics.jl**: Uses Symbolics for symbolic expression manipulation
- **SymbolicUtils.jl**: Built on SymbolicUtils for pattern matching and rewriting
- **ModelingToolkit.jl**: Symbolic integrals can be used in MTK models
- **TermInterface.jl**: Compatible with the standard term interface, enabling interoperability with
  other symbolic systems

This integration means symbolic integration works naturally with differential equations, optimization
problems, and other SciML workflows.

## Performance: Native Julia Implementation

Unlike wrappers around external computer algebra systems, SymbolicIntegration.jl is written entirely in
native Julia. This provides several advantages:

- **No external dependencies**: Works out of the box with `Pkg.add("SymbolicIntegration")`
- **Composability**: Easily integrates with other Julia packages
- **Performance**: Benefits from Julia's JIT compilation and type inference
- **Extensibility**: Users can add custom integration rules using the same rule system
- **Transparency**: Full source code is available and inspectable

## Future Directions

The SymbolicIntegration.jl roadmap includes several exciting developments:

- **Algebraic function support in Risch**: Extending the Risch algorithm to handle algebraic extensions
- **Additional RUBI rules**: Translating remaining untranslated rules from the RUBI suite
- **Performance optimizations**: Improving rule matching and simplification speed
- **Definite integration**: Support for computing definite integrals with bounds
- **Integration with automatic differentiation**: Seamless interplay with ForwardDiff.jl and Enzyme.jl

## Getting Started

Install SymbolicIntegration.jl with:

```julia
using Pkg
Pkg.add("SymbolicIntegration")
```

Check out the [documentation](https://docs.sciml.ai/SymbolicIntegration/stable/) for detailed usage
instructions, method selection guidance, and API reference.

## Acknowledgments

SymbolicIntegration.jl is the result of collaborative effort from the JuliaSymbolics community:

- **Harald Hofstätter**: Core Risch implementation
- **Mattia Micheletta Merlin (Bumblebee00)**: Rule-based integration system and RUBI translation
- **Chris Rackauckas**: Integration with SciML ecosystem

The package builds on the theoretical foundations of Manuel Bronstein's work on the Risch algorithm and
Albert Rich's comprehensive RUBI rule-based integration system.

## Citation

If you use SymbolicIntegration.jl in your research, please cite:

```bibtex
@software{SymbolicIntegration.jl,
  author = {Harald Hofstätter and Mattia Micheletta Merlin and Chris Rackauckas},
  title = {SymbolicIntegration.jl: Symbolic Integration for Julia},
  url = {https://github.com/JuliaSymbolics/SymbolicIntegration.jl},
  year = {2023-2025}
}
```

## Conclusion

SymbolicIntegration.jl represents a significant milestone in Julia's symbolic computing capabilities. By
combining the theoretical rigor of the Risch algorithm with the practical breadth of 3400+ integration
rules, it provides a powerful and user-friendly tool for symbolic integration. The intelligent fallback
system ensures you get results whenever possible, while the native Julia implementation ensures smooth
integration with the broader SciML ecosystem.

Try it out today and see how it can simplify your symbolic mathematics workflows!
