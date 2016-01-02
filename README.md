![](https://github.com/robot-overlord/quark/blob/master/logo.png?raw=true)
## Common combinators for Elixir

| Build Status | Maintainer Message | Documentation | Hosted Package |
|--------------|--------------------|---------------|----------------|
| [![Circle CI](https://circleci.com/gh/robot-overlord/quark/tree/master.svg?style=svg)](https://circleci.com/gh/robot-overlord/quark/tree/master) | ![built with humanity](https://cloud.githubusercontent.com/assets/1052016/11023213/66d837a4-8627-11e5-9e3b-b295fafb1450.png) |[robotoverlord.io/quark](http://www.robotoverlord.io/quark/extra-readme.html) | [Hex](https://hex.pm/packages/quark) |

## Quick Start

```elixir

def deps do
  [{:quark, "~> 1.0.0"}]
end

```

# What's Included?
- A series of classic combinators (SKI, BCKW, and fixed-points), along with friendlier aliases
- Fully-curried and partially applied functions
- Macros for defining curried and partially applied functions
- Composition helpers
  - Also a composition operator: `<|>`
- A plethora of common functional programming primitives, including:
  - `id`
  - `flip`
  - `const`
  - `pred`
  - `succ`
  - `fix`
  - `self_apply`
