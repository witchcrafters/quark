defmodule Quark do
  defdelegate flip(a, b), to: Quark.Classic.BCKW, as: :c
  defdelegate id(x), to: Quark.Classic.SKI, as: :i

  defdelegate constant(a, b), to: Quark.Classic.SKI, as: :k
  defdelegate first(a, b), to: Quark.Classic.SKI, as: :k

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
end
