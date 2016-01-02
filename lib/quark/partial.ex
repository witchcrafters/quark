defmodule Quark.Partial do
  @moduledoc ~S"""
  Provide curried functions, that can also be partially bound without dot notation.
  Partially applying a function will always return a fully-curried function.

  Please note that these will use all of the arities up to the defined function.
  For example, `defpartial foo(a, b, c), do: a + b + c` will generate `foo/0`, `foo/1`,
  `foo/2`, and `foo/3`. If you need to use an arity in the range below the original
  function, fall back to `defcurry` and partially apply manually.
  """

  use Quark.Curry
  require Quark.Curry

  defmacro __using__(_) do
    quote do
      import Quark.Partial, only: [defpartial: 2, defpartialp: 2]
    end
  end

  @doc ~S"""
  A convenience on `defcurry`. Generates a series of partially-bound applications
  of a fully-curried function, for all arities _at and below_ the user-specified
  arity. For instance, `defpartial add(a,b), do: a + b` will generate `add/0`,
  `add/1` and `add/2`.

      defpartialp minus(a, b, c), do: a - b - c

      minus(3, 2, 1)
      # => 0

      minus.(3).(2).(1)
      # => 0

      below_ten = minus(5)
      below_ten.(2, 1)
      # => 7

      below_five = minus(20, 15)
      below_five.(2)
      # => 3

  """
  defmacro defpartial({fun_name, ctx, args}, do: body) do
    quote do
      defcurry unquote({fun_name, ctx, args}), do: unquote(body)
      unquote do: Enum.map(args_scan(args), &rehydrate(fun_name, ctx, &1))
    end

  end

  defp rehydrate(fun_name, ctx, args) do
    quote do
      def unquote({fun_name, ctx, args}), do: unquote(partial_apply(fun_name, args))
    end
  end

  @doc ~S"""
  `defpartial`, but generates private functions

      defpartialp minus(a, b, c), do: a - b - c

      minus(3, 2, 1)
      # => 0

      minus.(3).(2).(1)
      # => 0

      below10 = minus(5)
      below10.(2, 1)
      # => 7

      below5 = minus(10, 5)
      below5.(2)
      # => 3

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
