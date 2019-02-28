defmodule Quark.BCKW do
  @moduledoc ~S"""
  The classic [BCKW combinators](https://wikipedia.org/wiki/B,_C,_K,_W_system).
  A similar idea to `SKI`, but with different primitives.
  """

  import Quark.Partial
  import Quark.Curry, only: [curry: 1]

  @doc ~S"""
  Normal (binary) function composition

  ## Examples

      iex> sum_plus_one = b(&(&1 + 1), &Enum.sum/1)
      iex> [1,2,3] |> sum_plus_one.()
      7

  """
  @spec b(fun, fun, any) :: any
  defpartial b(x, y, z), do: curry(x).(curry(y).(z))

  @doc ~S"""
  Reverse (first) two arguments (`flip`). Aliased as `flip`.

  ## Examples

      iex> c(&div/2).(1, 2)
      2

      iex> reverse_concat = c(&Enum.concat/2)
      ...> reverse_concat.([1,2,3], [4,5,6])
      [4,5,6,1,2,3]

      iex> flip(&div/2).(1, 2)
      2

  """
  @spec c(fun) :: fun
  defpartial c(fun), do: &(curry(fun).(&2).(&1))

  defdelegate flip(fun), to: __MODULE__, as: :c

  defdelegate k(),     to: Quark.SKI
  defdelegate k(a),    to: Quark.SKI
  defdelegate k(a, b), to: Quark.SKI

  @doc ~S"""
  Apply the same argument to a functon twice

  ## Examples

      iex> repeat = w(&Enum.concat/2)
      iex> repeat.([1,2])
      [1,2,1,2]

      iex> w(&Enum.zip/2).([1,2,3])
      [{1, 1}, {2, 2}, {3, 3}]

  """
  @spec w(fun) :: any
  defpartial w(fun), do: &(curry(fun).(&1).(&1))
end
