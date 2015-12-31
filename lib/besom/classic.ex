defmodule Besom.Classic do
  @moduledoc ~S"""
  The classic "letter" combinators. `s` and `k` alone can be used to express any
  algorithm, though generally not efficiently.
  """

  @doc ~S"""
  The identity combinator

      iex> i(1)
      1

      iex> i("idenity combinator")
      "identity combinator"

  """
  @spec i(any) :: any
  def i(x), do: x

  @doc ~S"""
  The constant ("Konstant") combinator. Returns the first argument, unchanged, and
  discards the second argument.

      iex> k(1,2)
      1

      iex> k("happy", "sad")
      "happy"

  """
  @spec k(any, any) :: any
  def k(x, _), do: x

  @doc ~S"""
  The "substitution" combinator. Applies the last argument to the first two, and then
  the first two to each other.

      iex> s()
      ghjkl;

  """
  # TODO: CURRY ALL ARGS
  @spec s((... -> any), (... -> any), any) :: any
  def s(x, y, z) do
    sub_x = &x.(z, &1)
    sub_y = y(z)

    sub_x.(sub_y)
  end

  @doc ~S"""
  The famous Y-combinator. This is a [fixed-point](https://en.wikipedia.org/wiki/Fixed-point_combinator),
  which means that applying arguments to this function will always result in a function
  with two or more arguments available.

      iex> {_, arity} = :erlang.fun_info(s, :arity)
      iex> s_arity = arity
      iex> one_run = y(s, i)
      iex> {_, arity} = :erlang.fun_info(one_run, :arity)
      iex> arity == s_arity
      True

  """
  @spec y((... -> any), any) :: (... -> any)
  def y(func, x) do
    y_apply(func, x).(y_apply(func, x))
  end

  defp y_apply(func, x), do: func.(x, x)
end
