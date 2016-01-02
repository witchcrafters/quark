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
      import Quark.Partial, only: [defpartial: 2] #, defpartialp: 2]
    end
  end

  @doc ~S"""
  defpartial add(a, b), do: a + b
  """
  defmacro defpartial({fun_name, ctx, args}, do: body) do
    rehydrate({fun_name, ctx, []}, body, args)
  end

  defp rehydrate({fun_name, ctx, []}, body, args) do
    quote do
      defcurry unquote({fun_name, ctx, args}), do: unquote(body)
    end
  end

  defp rehydrate({fun_name, ctx, args}, body, []) do
    # quote do
    #   defcurry unquote({fun_name, ctx, []}), do: unquote(body)
    # end
  end

  defp rehydrate({fun_name, ctx, args}, body, next_args) do
    quote do
      def unquote({fun_name, ctx, args}) do
        uncurry(unquote(fun_name)(), unquote(args))
      end
    end

    [na|nas] = next_args
    rehydrate({fun_name, ctx, [na|args]}, body, nas)
  end
end
