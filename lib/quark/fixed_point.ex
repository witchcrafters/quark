defmodule Quark.FixedPoint do
  @moduledoc ~S"""
  Fixed point combinators generalize the idea of a recursive function. This can
  be used to great effect, simplifying many definitions.

  For example, here is the factorial function written in terms of `y/1`:

  ```elixir

  iex> fac = fn fac ->
  ...>   fn
  ...>     0 -> 0
  ...>     1 -> 1
  ...>     n -> n * fac.(n - 1)
  ...>   end
  ...> end
  iex> factorial = y fac
  iex> factorial.(9)
  362880

  ```

  The resulting functions will always be curried

  ```elixir

  iex> import Quark.SKI, only: [s: 3]
  iex> one_run = y(&s/3)
  iex> {_, arity} = :erlang.fun_info(one_run, :arity)
  iex> arity
  1

  ```

  """

  use Quark.Partial
  import Quark.Curry, only: [curry: 1]

  defdelegate fix(), to: __MODULE__, as: :y
  defdelegate fix(a), to: __MODULE__, as: :y

  @doc ~S"""
  The famous Y-combinator. The resulting function will always be curried.

  ```elixir

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

  ```

   """
  @spec y((... -> any)) :: (any -> any)
  defpartial y(fun) do
    (fn x -> x.(x) end).(fn y ->
      curry(fun).(fn arg -> y.(y).(arg) end)
    end)
  end

  @doc ~S"""
  Alan Turing's fix-point combinator. This is the call-by-value formulation.

  ```elixir

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

  ```

  """
  @spec turing((... -> any)) :: (any -> any)
  defpartial turing(fun), do: turing_inner.(turing_inner).(fun)

  defpartialp turing_inner(x, y) do
    cx = curry(x)
    cy = curry(y)
    cy.(&(cx.(cx).(cy).(&1)))
  end

  @doc ~S"""
  A [normal order](https://en.wikipedia.org/wiki/Evaluation_strategy#Normal_order) fixed point

  ```elixir

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

  ```

  """
  @spec z((... -> any), any) :: (any -> any)
  defpartial z(g, v), do: g.(z.(g)).(v)
end
