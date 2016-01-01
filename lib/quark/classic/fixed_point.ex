defmodule Quark.Classic.FixedPoint do
  @moduledoc ~S"""
  """

  import Quark.Curry, only: [curry: 1]
  import Quark.Classic.BCKW

  @doc ~S"""
  The famous Y-combinator. This is a [fixed-point](https://en.wikipedia.org/wiki/Fixed-point_combinator),
  which means that applying arguments to this function will always result in a function
  with two or more arguments available.

      iex> import Quark.Classic.FixedPoint
      iex> import Quark.Classic.SKI
      iex> one_run = y(&s/3)
      iex> {_, arity} = :erlang.fun_info(one_run, :arity)
      iex> arity
      1

  """
  @spec y((... -> any)) :: (any -> any)
  def y(fun) do
    curry_fun = curry(fun)
    curry_fun.(&self_apply/1).(&(curry_fun.(self_apply(&1))))
  end

  defp self_apply(fun) do
    curried_fun = curry(fun)
    curried_fun.(curried_fun)
  end

  def turing() do
    # Θ = (λx. λy. (y (x x y))) (λx. λy. (y (x x y)))
    # Θv = (λx. λy. (y (λz. x x y z))) (λx. λy. (y (λz. x x y z)))
  end

  @doc ~S"""
  A normal order fixed point
  """
  @spec z((... -> any), any) :: (... -> any)
  def z(g, v), do: g.(z.(g)).(v)
  def z(g), do: z().(g)
  def z(), do: curry(&z/2)

  @doc ~S"""
  A strictly non-standard fixed-point combinator
  """
  @spec n((... -> any)) :: (... -> any)
  def n(arg), do: b(m, (b(b(m), b)), arg)

  @doc ~S"""
  Apply a function to itself
  """
  @spec m() :: (... -> any)
  defp m(), do: fn fun -> &fun.(fun.(&1)) end
end
