defmodule Quark.FixedPoint do
  @moduledoc ~S"""
  Fixed point combinators generalize the idea of a recursive function. This can
  be used to great effect, simplifying many definitions.

  For example, here is the factorial function written in terms of `y/1`:

      iex> fac = fn fac ->
      ...>   fn
      ...>     0 -> 0
      ...>     1 -> 1
      ...>     n -> n * fac.(n - 1)
      ...>   end
      ...> end
      iex> factorial = Quark.FixedPoint.y(fac)
      iex> factorial.(9)
      362880

  The resulting functions will always be curried

      iex> import Quark.FixedPoint, only: [y: 1]
      iex> import Quark.SKI, only: [s: 3]
      iex> one_run = y(&s/3)
      iex> {_, arity} = :erlang.fun_info(one_run, :arity)
      iex> arity
      1

  """

  import Quark.Curry, only: [curry: 1]
  import Quark.BCKW, only: [b: 0, b: 1, b: 2, b: 3]

  @doc ~S"""
  The famous Y-combinator. The resulting function will always be curried.

      iex> import Quark.FixedPoint, only: [y: 1]
      iex> fac = fn fac ->
      ...>   fn
      ...>     0 -> 0
      ...>     1 -> 1
      ...>     n -> n * fac.(n - 1)
      ...>   end
      ...> end
      iex> factorial = y(fac)
      iex> factorial.(9)
      362880

   """
  @spec y() :: (any -> any)
  def y(), do: &y(&1)

  @spec y((... -> any)) :: (any -> any)
  def y(fun) do
    (fn x -> x.(x) end).(fn y ->
      curry(fun).(fn arg -> y.(y).(arg) end)
    end)
  end

  @doc ~S"""
  Alan Turing's fix-point combinator. This is the call-by-value formulation.

      iex> import Quark.FixedPoint, only: [turing: 1]
      iex> fac = fn fac ->
      ...>   fn
      ...>     0 -> 0
      ...>     1 -> 1
      ...>     n -> n * fac.(n - 1)
      ...>   end
      ...> end
      iex> factorial = turing(fac)
      iex> factorial.(9)
      362880

  """
  @spec turing() :: (any -> any)
  def turing(), do: turing_inner.(turing_inner())

  @spec turing((... -> any)) :: (any -> any)
  def turing(fun), do: turing.(fun)

  defp turing_inner(), do: &turing_inner(&1)
  defp turing_inner(x), do: &turing_inner(x, &1)
  defp turing_inner(x, y) do
    cx = curry(x)
    cy = curry(y)
    cy.(&(cx.(cx).(cy).(&1)))
  end

  @doc ~S"""
  A [normal order](https://en.wikipedia.org/wiki/Evaluation_strategy#Normal_order) fixed point

      iex> import Quark.FixedPoint, only: [z: 1]
      iex> fac = fn fac ->
      ...>   fn
      ...>     0 -> 0
      ...>     1 -> 1
      ...>     n -> n * fac.(n - 1)
      ...>   end
      ...> end
      iex> factorial = z(fac)
      iex> factorial.(9)
      362880

  """
  @spec z() :: (any -> any)
  def z(), do: curry(&z/2)

  @spec z((... -> any)) :: (any -> any)
  def z(g), do: z().(g)

  @spec z((... -> any), any) :: (any -> any)
  def z(g, v), do: g.(z.(g)).(v)
end
