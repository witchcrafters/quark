defmodule Quark.SKI do
  @moduledoc ~S"""
  The classic [SKI](https://en.wikipedia.org/wiki/SKI_combinator_calculus)
  system of combinators. `s` and `k` alone can be used to express any algorithm,
  though generally not efficiently.
  """

  import Quark.Partial

  @doc ~S"""
  The identity combinator. Also aliased as `id`.

      iex> i(1)
      1

      iex> i("identity combinator")
      "identity combinator"

      iex> [1,2,3] |> id
      [1,2,3]

  """
  @spec i(any) :: any
  defpartial i(x), do: x

  defdelegate id(x), to: __MODULE__, as: :i

  @doc ~S"""
  The constant ("Konstant") combinator. Returns the first argument unchanged,
  and discards the second argument.

  Can be used to repeatedly apply the same value in functions such as folds.

  Aliased as `first` and `constant`.

  ## Examples

      iex> k(1, 2)
      1

      iex> k("happy", "sad")
      "happy"

      iex> Enum.reduce([1,2,3], [42], &k/2)
      3

      iex> Enum.reduce([1,2,3], [42], &constant/2)
      3

      iex> first(1,2)
      1

  """
  @spec k(any, any) :: any
  defpartial k(x, _y), do: x

  defdelegate constant(a, b), to: __MODULE__, as: :k
  defdelegate first(a, b),    to: __MODULE__, as: :k

  @doc ~S"""
  Opposite of `first` (the `k` combinator).

  While not strictly part of SKI, it's a common enough case.

  Returns the *second* of two arguments. Can be used to repeatedly apply
  the same value in functions such as folds.

  ## Examples

      iex> second(43, 42)
      42

      iex> Enum.reduce([1,2,3], [], &second/2)
      []

  """
  @spec second(any, any) :: any
  defpartial second(a, b), do: b

  @doc ~S"""
  The "substitution" combinator. Applies the last argument to the first two,
  and then the first two to each other.

  ## Examples

      iex> add = &(&1 + &2)
      ...> double = &(&1 * 2)
      ...> s(add, double, 8)
      24

  """
  @spec s(fun, fun, any) :: any
  defpartial s(x, y, z) do
    sub_x = &x.(z, &1)
    sub_y = y.(z)

    sub_x.(sub_y)
  end
end
