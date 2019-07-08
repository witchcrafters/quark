defmodule Quark.Partial do
  @moduledoc ~S"""
  Provide curried functions, that can also be partially bound without
  dot notation. Partially applying a function will always return a
  fully-curried function.

  Please note that these will use all of the arities up to the defined function.

  For instance:

      defpartial foo(a, b, c), do: a + b + c
      #=> foo/0, foo/1, foo/2, and foo/3

  If you need to use an arity in the range below the original
  function, fall back to [`defcurry/2`](Quark.Curry.html#defcurry/2) and partially apply manually.
  """

  import Quark.Curry

  @doc ~S"""
  A convenience on [`defcurry/2`](Quark.Curry.html#defcurry/2). Generates a series of partially-bound
  applications of a fully-curried function, for all arities _at and below_
  the user-specified arity.

  For instance:

      defpartial add(a,b), do: a + b
      #=> add/0, add/1, add/2.

  ## Examples

      defmodule A do
        defpartial minus(a, b, c), do: a - b - c
      end

      A.minus(3, 2, 1)
      #=> 0

      A.minus.(3).(2).(1)
      #=> 0

      below_ten = A.minus(10)
      below_ten.(2).(1)
      #=> 7

      below_five = A.minus(20, 15)
      below_five.(2)
      #=> 3

  """
  defmacro defpartial({fun_name, ctx, args}, do: body) do
    quote do
      defcurry unquote({fun_name, ctx, args}), do: unquote(body)
      unquote do: Enum.map(args_scan(args), &rehydrate(fun_name, ctx, &1))
    end
  end

  defp rehydrate(fun_name, ctx, args) do
    quote do
      def unquote({fun_name, ctx, args}) do
        unquote(partial_apply(fun_name, args))
      end
    end
  end

  @doc ~S"""
  `defpartial/2`, but generates private functions.
  """
  defmacro defpartialp({fun_name, ctx, args}, do: body) do
    quote do
      defcurryp unquote({fun_name, ctx, args}), do: unquote(body)
      unquote do: Enum.map(args_scan(args), &rehydratep(fun_name, ctx, &1))
    end
  end

  defp rehydratep(fun_name, ctx, args) do
    quote do
      defp unquote({fun_name, ctx, args}) do
        unquote(partial_apply(fun_name, args))
      end
    end
  end

  defp args_scan(args), do: Enum.scan(args, [], &(&2 ++ [&1]))

  defp partial_apply(fun_name, args) do
    {as, [a]} = Enum.split(args, -1)
    quote do
      unquote(fun_name)(unquote_splicing(as)).(unquote(a))
    end
  end
end
