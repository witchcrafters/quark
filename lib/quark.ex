defmodule Quark do
  @moduledoc ~S"""
  Top-level module. Provides a convenient `use` macro for importing the most
  commonly used functions and macros.

  Due to performance reasons, many of the combinators are given non-combinatory
  implementations (ie: not everything is expressed in terms `s` and `k`)
  """

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      use Quark.Curry
      use Quark.Partial
    end
  end

  defdelegate compose(a), to: Quark.Compose
  defdelegate compose(a, b), to: Quark.Compose
  defdelegate a <|> b, to: Quark.Compose

  defdelegate fix(fun), to: Quark.FixedPoint

  defdelegate flip(fun), to: Quark.BCKW

  defdelegate constant(a, b), to: Quark.SKI
  defdelegate id(a), to: Quark.SKI
  defdelegate first(a, b), to: Quark.SKI
  defdelegate second(a, b), to: Quark.SKI

  defdelegate self_apply(a), to: Quark.M

  defdelegate origin(a), to: Quark.Sequence
  defdelegate succ(a),   to: Quark.Sequence
  defdelegate pred(a),   to: Quark.Sequence
end
