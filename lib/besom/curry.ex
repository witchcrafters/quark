defmodule Besom.Curry do
  @moduledoc ~S"""
  """

  @doc ~S"""
      iex> curried_reduce_3 = curry &Enum.reduce/3
      iex> {_, arity} = :erlang.fun_info(curried_reduce_3, :arity)
      {:arity, 1}

  [Original code](http://blog.patrikstorm.com/function-currying-in-elixir) by [Patrik Storm](https://twitter.com/stormpat)
  """
  def curry(fun) do
    {_, arity} = :erlang.fun_info(fun, :arity)
    curry(fun, arity, [])
  end

  def curry(fun, 0, arguments) do
    apply(fun, Enum.reverse(arguments))
  end

  def curry(fun, arity, arguments) do
    fn arg -> curry(fun, arity - 1, [arg | arguments]) end
  end
end
