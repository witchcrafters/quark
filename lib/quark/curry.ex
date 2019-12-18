defmodule Quark.Curry do
  @moduledoc ~S"""
  [Currying](https://en.wikipedia.org/wiki/Currying) breaks up a function into a
  series of unary functions that apply their arguments to some inner
  n-ary function. This is a convenient way to achieve a general and flexible
  partial application on any curried function.
  """

  @doc ~S"""
  Curry a function at runtime, rather than upon definition

  ## Examples

      iex> curried_reduce_3 = curry &Enum.reduce/3
      ...> {_, arity} = :erlang.fun_info(curried_reduce_3, :arity)
      ...> arity
      1

      iex> curried_reduce_3 = curry &Enum.reduce/3
      ...> curried_reduce_3.([1,2,3]).(42).(&(&1 + &2))
      48

  """
  @spec curry(fun) :: fun
  def curry(fun) do
    {_, arity} = :erlang.fun_info(fun, :arity)
    curry(fun, arity, [])
  end

  @spec curry(fun, integer, [any]) :: fun
  defp curry(fun, 0, arguments), do: apply(fun, Enum.reverse(arguments))
  defp curry(fun, arity, arguments) do
    fn arg -> curry(fun, arity - 1, [arg | arguments]) end
  end

  @doc ~S"""
  Convert a curried function to a function on pairs

  ## Examples

      iex> curried_add = fn x -> (fn y -> x + y end) end
      iex> add = uncurry curried_add
      iex> add.(1,2)
      3

  """
  @spec uncurry((any -> fun)) :: ((any, any) -> any)
  def uncurry(fun), do: &(fun.(&1).(&2))

  @doc ~S"""
  Apply a series of arguments to a curried function

  ## Examples

      iex> curried_add = fn x -> (fn y -> x + y end) end
      ...> uncurry(curried_add, [1,2])
      3

  Apply an argument to a function

  ## Examples

      iex> add_one = &(&1 + 1)
      ...> uncurry(add_one, 1)
      2

      iex> curried_add = fn x -> (fn y -> x + y end) end
      ...> add_one = uncurry(curried_add, 1)
      ...> add_one.(3)
      4

  """
  @spec uncurry(fun, any | [any]) :: any
  def uncurry(fun, arg_list) when is_list(arg_list) do
    arg_list
    |> Enum.reduce(fun, &Kernel.apply/2)
  end
  def uncurry(fun, arg), do: fun.(arg)

  @doc "Define a curried function"
  defmacro defcurry(head, do: body) do
    {fun_name, ctx, args} = head

    quote do
      def unquote({fun_name, ctx, []}), do: unquote(wrap(args, body))
    end
  end

  @doc "Define a curried private function"
  defmacro defcurryp(head, do: body) do
    {fun_name, ctx, args} = head

    quote do
      defp unquote({fun_name, ctx, []}), do: unquote(wrap(args, body))
    end
  end

  defp wrap([arg|args], body) do
    quote do
      fn unquote(arg) ->
        unquote(wrap(args, body))
      end
    end
  end

  defp wrap([], body), do: body
end
