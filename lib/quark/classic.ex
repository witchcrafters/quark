defmodule Quark.Classic do
  @moduledoc ~S"""
  The classic "letter" combinators. `s` and `k` alone can be used to express any
  algorithm, though generally not efficiently.

  For performance reasons, many of the combinators are given
  non-combinatory implementations.
  """

  @doc ~S"""
  Apply a function to itself

      iex> import Quark.Classic, only: [m: 1]
      iex> add_one = fn x -> x + 1 end
      iex> add_two = m(add_one)
      iex> add_two.(8)
      10

  """
  @spec m() :: (... -> any)
  def m(), do: &(m(&1))

  @spec m((... -> any)) :: (... -> any)
  def m(fun) do
    import Quark.Curry, only: [curry: 1]
    c_fun = curry(fun)
    &c_fun.(c_fun.(&1))
  end
end
