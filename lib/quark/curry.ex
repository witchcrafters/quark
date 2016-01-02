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
      iex> arity
      1

      iex> curried_reduce_3 = curry &Enum.reduce/3
      iex> import Quark.Curry
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
  defp curry(fun, 0, arguments), do: apply(fun, Enum.reverse(arguments))
  defp curry(fun, arity, arguments) do
    import Quark.Sequence, only: [pred: 1]
    fn arg -> curry(fun, pred(arity), [arg | arguments]) end
  end

  @doc ~S"""
  Convert a curried function to a function on pairs

      iex> curried_add = fn x -> (fn y -> x + y end) end
      iex> add = uncurry curried_add
      iex> add.(1,2)
      3

  """
  @spec uncurry((any -> (any -> any))) :: ((any, any) -> any)
  def uncurry(fun), do: &(fun.(&1).(&2))

  @doc ~S"""
  Apply a series of arguments to a curried function

      iex> import Quark.Curry, only: [uncurry: 2]
      iex> curried_add = fn x -> (fn y -> x + y end) end
      iex> uncurry(curried_add, [1,2])
      3

  """
  @spec uncurry((any -> any), [any]) :: any
  def uncurry(fun, [args]), do: reduce([args], fun)
  defp reduce([a|as], curried_fun), do: uncurry(curried_fun.(a), as)

  @doc ~S"""
  Apply an argument to a function

      iex> add_one = &(&1 + 1)
      iex> uncurry(add_one, 1)
      2

      iex> curried_add = fn x -> (fn y -> x + y end) end
      iex> add_one = uncurry(curried_add, 1)
      iex> add_one.(3)
      4

  """
  @spec uncurry(fun, any) :: any
  def uncurry(fun, arg), do: fun.(arg)

  defmacro __using__(_) do
    quote do
      import Quark.Curry, only: [defcurry: 2, defcurryp: 2]
    end
  end

  @doc ~S"""
  Define a curried function
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
