defmodule Quark.BCKW do
  @moduledoc ~S"""
  """

  use Quark.Partial
  import Quark.Curry, only: [curry: 1]

  @doc ~S"""
  Normal (binary) function composition

      iex> sum_plus_one = b(&(&1 + 1), &Enum.sum/1)
      iex> [1,2,3] |> sum_plus_one.()
      7

  """
  @spec b((... -> any), (... -> any), any) :: any
  defpartial b(x, y, z), do: curry(x).(curry(y).(z))

  @doc ~S"""
  Reverse (first) two arguments (`flip`)

      iex> c(&div/2).(1, 2)
      2

      iex> reverse_concat = c(&Enum.concat/2)
      iex> reverse_concat.([1,2,3], [4,5,6])
      [4,5,6,1,2,3]

  """
  @spec c((... -> any)) :: (... -> any)
  defpartial c(fun), do: &(curry(fun).(&2).(&1))

  @doc ~S"""
  Apply the same argument to a functon twice

      iex> repeat = w(&Enum.concat/2)
      iex> repeat.([1,2])
      [1,2,1,2]

      iex> w(&Enum.zip/2).([1,2,3])
      [{1, 1}, {2, 2}, {3, 3}]

  """
  @spec w((... -> any)) :: any
  defpartial w(fun), do: &(curry(fun).(&1).(&1))
end
