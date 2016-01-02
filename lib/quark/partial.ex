defmodule Quark.Partial do
  @moduledoc ~S"""
  Provide curried functions, that can also be partially applied without dot notation.

  Please note that these will use all of the arities up to the defined function.
  For example, `defpartial foo(a, b, c), do: a + b + c` will generate `foo/0`, `foo/1`,
  `foo/2`, and `foo/3`.
  """

  use Quark.Curry
  require Quark.Curry

  defmacro __using__(_) do
    quote do
      import Quark.Partial, only: [defpartial: 2, defpartialp: 2]
    end
  end

  @doc ~S"""
  """
  defmacro defpartial({fun_name, ctx, args}, do: body) do
    Enum.map(args_scan(args), &rehydrate(fun_name, ctx, &1, body, args))
  end

  defp rehydrate(fun_name, ctx, [], body, full_args) do
    quote do
      defcurry unquote({fun_name, ctx, full_args}), do: unquote(body)
    end
  end

  defp rehydrate(fun_name, ctx, args, _, _) do
    quote do
      def unquote({fun_name, ctx, args}), do: unquote(partial_apply(fun_name, args))
    end
  end

  defmacro defpartialp({fun_name, ctx, args}, do: body) do
    Enum.map(args_scan(args), &rehydratep(fun_name, ctx, &1, body, args))
  end

  defp rehydratep(fun_name, ctx, [], body, full_args) do
    quote do
      defcurryp unquote({fun_name, ctx, full_args}), do: unquote(body)
    end
  end

  defp rehydratep(fun_name, ctx, args, _, _) do
    quote do
      defp unquote({fun_name, ctx, args}), do: unquote(partial_apply(fun_name, args))
    end
  end

  defp args_scan(args), do: [[] | Enum.scan(args, [], &(&2 ++ [&1]))]

  defp partial_apply(fun_name, args) do
    {as, [a]} = Enum.split(args, -1)
    quote do
      unquote(fun_name)(unquote_splicing(as)).(unquote(a))
    end
  end
end
