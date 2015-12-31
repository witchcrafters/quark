defmodule Besom.Common do
  @moduledoc ~S"""
  """

  import Besom.Ordinal.Integer

  defdelegate flip, to: Besom.Classic.BCKW, as: :c
  defdelegate id, to: Besom.Classic.SKI, as: :i

  defdelegate constant, to: Besom.Classic.SKI, as: :k
  defdelegate first, to: Besom.Classic.SKI, as: :k

  @doc ~S"""
  Opposite of `first` (the `k` combinator).

  Returns the *second* of two arguments. Can be used to repeatedly apply the same value
  in functions such as folds.

      iex> Besom.Common.second(43, 42)
      42

      iex> Enum.reduce([1,2,3], [], &second/2)
      []

  """
  @spec second(any, any) :: any
  def second(_, b), do: b
end
