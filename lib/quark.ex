defmodule Quark do
  import Quark.Classic
  import Quark.Compose
  import Quark.Curry

  defdelegate flip, to: Quark.Classic.BCKW, as: :c
  defdelegate id, to: Quark.Classic.SKI, as: :i

  defdelegate constant, to: Quark.Classic.SKI, as: :k
  defdelegate first, to: Quark.Classic.SKI, as: :k

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
