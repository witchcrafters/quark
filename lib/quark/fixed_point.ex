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
      ...> factorial = y(fac)
      ...> factorial.(9)
      362880

  The resulting function will always be curried

      iex> import Quark.SKI, only: [s: 3]
      ...> one_run = y(&s/3)
      ...> {_, arity} = :erlang.fun_info(one_run, :arity)
      ...> arity
      1

  """

  import Quark.Partial
  import Quark.Curry, only: [curry: 1]

  defdelegate fix(),  to: __MODULE__, as: :y
  defdelegate fix(a), to: __MODULE__, as: :y

  @doc ~S"""
  The famous Y-combinator. The resulting function will always be curried.

  ## Examples

      iex> fac = fn fac ->
      ...>   fn
      ...>     0 -> 0
      ...>     1 -> 1
      ...>     n -> n * fac.(n - 1)
      ...>   end
      ...> end
      ...> factorial = y(fac)
      ...> factorial.(9)
      362880

   """
  @spec y(fun) :: fun
  defpartial y(fun) do
    (fn x -> x.(x) end).(fn y ->
      curry(fun).(fn arg -> y.(y).(arg) end)
    end)
  end

  @doc ~S"""
  Alan Turing's fix-point combinator. This is the call-by-value formulation.

  ## Examples

      iex> fac = fn fac ->
      ...>   fn
      ...>     0 -> 0
      ...>     1 -> 1
      ...>     n -> n * fac.(n - 1)
      ...>   end
      ...> end
      ...> factorial = turing(fac)
      ...> factorial.(9)
      362880

  """
  @spec turing(fun) :: fun
  defpartial turing(fun), do: turing_inner().(turing_inner()).(fun)

  defpartialp turing_inner(x, y) do
    cx = curry(x)
    cy = curry(y)
    cy.(&(cx.(cx).(cy).(&1)))
  end

  @doc ~S"""
  A [normal order](https://wikipedia.org/wiki/Evaluation_strategy#Normal_order)
  fixed point.

  ## Examples

      iex> fac = fn fac ->
      ...>   fn
      ...>     0 -> 0
      ...>     1 -> 1
      ...>     n -> n * fac.(n - 1)
      ...>   end
      ...> end
      ...> factorial = z(fac)
      ...> factorial.(9)
      362880

  """
  @spec z(fun, any) :: fun
  defpartial z(g, v), do: g.(z(g)).(v)
end
