defmodule Quark.Curry do
  @moduledoc ~S"""
  [Currying](https://en.wikipedia.org/wiki/Currying) breaks up a function into a
  series of unary functions that apply their arguments to some inner
  n-ary function. This is a convenient way to achieve a general and flexble
  partial application on any curried function.
  """

  @doc ~S"""
  This allows you to curry a function at runtime, rather than upon definition.

      iex> curried_reduce_3 = curry &Enum.reduce/3
      iex> {_, arity} = :erlang.fun_info(curried_reduce_3, :arity)
      {:arity, 1}

      iex> curried_reduce_3.([1,2,3]).(42).(&(&1 + &2))
      48

  [Original code](http://blog.patrikstorm.com/function-currying-in-elixir) by [Patrik Storm](https://twitter.com/stormpat)
  """
  @spec curry((... -> any)) :: (any -> any)
  def curry(fun) do
    {_, arity} = :erlang.fun_info(fun, :arity)
    curry(fun, arity, [])
  end

  @spec curry((... -> any), integer, [any]) :: (any -> any)
  def curry(fun, 0, arguments) do
    apply(fun, Enum.reverse(arguments))
  end

  def curry(fun, arity, arguments) do
    fn arg -> curry(fun, arity - 1, [arg | arguments]) end
  end


  @doc ~S"""
  Convert a curried function to a function on pairs
  """
  @spec uncurry((any -> any)) :: ((any, any) -> any)
  def uncurry(fun), do: &(fun.(&1).(&2))

  @doc ~S"""
  Apply arguments to a curried function
  """
  @spec uncurry((any -> any), any) :: any
  def uncurry(fun, [args]) do
    Enum.reduce(Enum.reverse([args]), fun, C.flip(&uncurry/2))
  end

  def uncurry(fun, arg), do: fun.(arg)

  @doc ~S"""
  """
  defmacro __using__(_) do
    quote do
      import Quark.Curry, only: [defcurry: 2, defcurryp: 2]
    end
  end

  @doc ~S"""
  """
  defmacro defcurry(head, do: body) do
    {fun_name, ctx, args} = head

    quote do
      def unquote({fun_name, ctx, []}), do: unquote(wrap(args, body))
    end
  end

  defmacro defcurryp(head, do: body) do
    {fname, ctx, args} = head

    quote do
      defp unquote({fname, ctx, []}), do: unquote(wrap(args, body))
    end
  end

  defp wrap([arg|args], body) do
    quote do
      fn unquote(arg) ->
        unquote(wrap(args, body))
      end
    end
  end

  defp wrap(_, body), do: body
end
