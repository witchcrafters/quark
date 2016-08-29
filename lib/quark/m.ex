defmodule Quark.M do
  @moduledoc "The self-applyication combinator"

  use Quark.Partial

  @doc ~S"""
  Apply a function to itself. Also aliased as `self_apply`.

  ## Examples

      iex> add_one = fn x -> x + 1 end
      ...> add_two = m(add_one)
      ...> add_two.(8)
      10

  """
  @spec m(fun) :: fun
  defpartial m(fun) do
    import Quark.Curry, only: [curry: 1]
    c_fun = curry(fun)
    &c_fun.(c_fun.(&1))
  end

  defdelegate self_apply(), to: __MODULE__, as: :m
  defdelegate self_apply(fun), to: __MODULE__, as: :m
end
