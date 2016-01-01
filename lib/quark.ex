defmodule Quark do
  @moduledoc ~S"""
  For performance reasons, many of the combinators are given
  non-combinatory implementations.
  """

  defdelegate flip(a, b), to: Quark.BCKW, as: :c
  defdelegate id(x), to: Quark.SKI, as: :i

  defdelegate constant(a, b), to: Quark.SKI, as: :k
  defdelegate first(a, b), to: Quark.SKI, as: :k

  @doc ~S"""
  Opposite of `first` (the `k` combinator).

  Returns the *second* of two arguments. Can be used to repeatedly apply the same value
  in functions such as folds.

      iex> Quark.second(43, 42)
      42

      iex> Enum.reduce([1,2,3], [], &Quark.second/2)
      []

  """
  @spec second(any, any) :: any
  def second(_, b), do: b

  @doc ~S"""
  Apply a function to itself

      iex> import Quark, only: [m: 1]
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

  defdelegate self_apply(), to: __MODULE__, as: :m
  defdelegate self_apply(fun), to: __MODULE__, as: :m
end
