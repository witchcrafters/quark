defmodule Besom.Classic.FixedPoint do
  @moduledoc ~S"""
  """

  import Besom.Classix.BCKW, only: [b: 3]

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

  def turing() do
    Θ = (λx. λy. (y (x x y))) (λx. λy. (y (x x y)))
    Θv = (λx. λy. (y (λz. x x y z))) (λx. λy. (y (λz. x x y z)))
  end

  @doc ~S"""
  A normal order fixed point
  """
  @spec z((... -> any), any) :: (... -> any)
  def z(g, v), do: g.(z(g)).(v)

  @doc ~S"""
  A strictly non-standard fixed-point combinator
  """
  @spec n((... -> any)) :: (... -> any)
  def n(arg), do: b(m, (b(b(m),b)), arg)

  @doc ~S"""
  Apply a function to itself
  """
  @spec m((... -> any)) :: (... -> any)
  defp m(fun), do: &fun.(fun.(&1))
end
