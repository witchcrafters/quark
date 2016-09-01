defmodule Quark do
  @moduledoc ~S"""
  Top-level module. Provides a convenient `use` macro for importing the most
  commonly used functions and macros.

  Due to performance reasons, many of the combinators are given non-combinatory
  implementations (ie: not everything is expressed in terms `s` and `k`)
  """

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__), only: []

      import Quark.Compose, only: [compose: 1, compose: 2, <|>: 2]
      import Quark.FixedPoint, only: [fix: 1]
      import Quark.Sequence
      import Quark.BCKW, only: [flip: 1]
      import Quark.SKI, only: [constant: 2, id: 1, first: 2]
      import Quark.M

      use Quark.Curry
      use Quark.Partial
    end
  end
end
