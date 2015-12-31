defmodule Besom.Classic.FixedPoint do
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
