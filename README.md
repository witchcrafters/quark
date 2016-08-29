# Quark: Common combinators for Elixir

![](https://github.com/expede/quark/blob/master/brand/logo.png?raw=true)

| Build Status |  Doc Coverage  | Documentation |  Hosted Package |
|--------------|----------------|---------------|-----------------|
| [![Build Status](https://travis-ci.org/expede/quark.svg?branch=master)](https://travis-ci.org/expede/quark)| [![Inline docs](http://inch-ci.org/github/expede/quark.svg?branch=master)](http://inch-ci.org/github/expede/quark) | [hexdocs.pm/quark](https://hexdocs.pm/quark) | [Hex](https://hex.pm/packages/quark) |


# Table of Contents
- [Quick Start](#quick-start)
- [Summary](#summary)
  - [Includes](#includes)
- [Functional Overview](#functional-overview)
  - [Curry](#curry)
    - [Functions](#functions)
    - [Macros](#macros-defcurry-and-defcurryp)
  - [Partial](#partial)
    - [Macros](##macros-defpartial-and-defpartialp)
  - [Compose](#compose)
  - [Common Combinators](#common-combinators)
    - [Classics](#classics)
      - [SKI System](#ski-system)
      - [BCKW System](#bckw-system)
      - [Fixed Point](#fixed-point)
    - [Sequence](#sequence)

# Quick Start

```elixir

def deps do
  [{:quark, "~> 2.0"}]
end

defmodule MyModule do
  use Quark

  # ...
end
```

# Summary

[Elixir](http://elixir-lang.org) is a functional programming language,
but it lacks some of the common built-in constructs that many other functional
languages provide. This is not all-together surprising, as Elixir has a strong
focus on handling the complexities of concurrency and fault-tolerance, rather than
deeper functional composition on functions for reuse.

## Includes

- A series of classic combinators (SKI, BCKW, and fixed-points), along with friendlier aliases
- Fully-curried and partially applied functions
- Macros for defining curried and partially applied functions
- Composition helpers
  - Composition operator: `<|>`
- A plethora of common functional programming primitives, including:
  - `id`
  - `flip`
  - `const`
  - `pred`
  - `succ`
  - `fix`
  - `self_apply`

# Functional Overview

## Curry

### Functions
`curry` creates a 0-arity function that curries an existing function. `uncurry` applies arguments to curried functions, or if passed a function creates a function on pairs.

### Macros: `defcurry` and `defcurryp`
Why define the function before currying it? `defcurry` and `defcurryp` return
fully-curried 0-arity functions.

```elixir

defmodule Foo do
  use Quark.Curry

  defcurry div(a, b), do: a / b
  defcurryp minus(a, b), do: a - b
end

# Regular
div(10, 2)
# => 5

# Curried
div.(10).(5)
# => 2

# Partially applied
div_ten = div.(10)
div_ten.(2)
# => 5

```

## Partial

:crown: We think that this is really the crowning jewel of `Quark`.
`defpartial` and `defpartialp` create all arities possible for the defined
function, bare, partially applied, and fully curried.
This does use up all the full arity-space for that function name, however.

### Macros: `defpartial` and `defpartialp`

```elixir

defmodule Foo do
  use Quark.Partial

  defpartial one(), do: 1
  defpartial minus(a, b, c), do: a - b - c
  defpartialp plus(a, b, c), do: a + b + c
end

# Normal zero-arity
one
# => 1

# Normal n-arity
minus(4, 2, 1)
# => 1

# Partially-applied first two arguments
minus(100, 5).(10)
# => 85

# Partially-applied first argument
minus(100).(10).(50)
# => 40

# Fully-curried
minus.(10).(2).(1)
# => 7

```

## Compose
Compose functions to do convenient partial applications.
Versions for composing left-to-right and right-to-left are provided, but the
operator `<|>` is done "the math way" (right-to-left).

Versions on lists also available.

## Common Combinators
A number of basic, general functions, including `id`, `flip`, `const`, `pred`, `succ`, `fix`, and `self_apply`.

## Classics

### SKI System
The SKI system combinators. `s` and `k` alone can be combined to express any
algorithm, but not usually with much efficiency.

We've aliased the names at the top-level (`Quark`), so you can use `const`
rather than having to remember what `k` means.

```elixir
 1 |> i
#=> 1

"identity combinator" |> i
#=> "identity combinator"

Enum.reduce([1,2,3], [42], &k/2)
#=> 3

```

### BCKW System
The classic `b`, `c`, `k`, and `w` combinators. A similar "full system" as SKI,
but with some some different functionality out of the box.

As usual, we've aliased the names at the top-level (`Quark`).

```elixir
c(&div/2).(1, 2)
#=> 2

reverse_concat = c(&Enum.concat/2)
reverse_concat.([1,2,3], [4,5,6])
#=> [4,5,6,1,2,3]

repeat = w(&Enum.concat/2)
repeat.([1,2])
#=> [1,2,1,2]
```

### Fixed Point
Several fixed point combinators, for helping with recursion. Several formulations are provided,
but if in doubt, use `fix`. Fix is going to be kept as an alias to the most efficient
formulation at any given time, and thus reasonably future-proof.

```elixir
fac = fn fac ->
  fn
    0 -> 0
    1 -> 1
    n -> n * fac.(n - 1)
  end
end

factorial = y(fac)
factorial.(9)
#=> 362880
```

### Sequence
Really here for `pred` and `succ` on integers, by why stop there?
This works with any ordered collection via the `Quark.Sequence` protocol.

```elixir
succ 10
#=> 11

#=> 42 |> origin |> pred |> pred
-2
```
