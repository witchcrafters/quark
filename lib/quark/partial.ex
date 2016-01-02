defmodule Quark.Partial do
  @moduledoc ~S"""
  RENAME TO "Quark.Partial"
  Not *actually* lazy, but want to keep apart from `defcurry` so that users can
  write multiple arities thenselves with `defcurry`, and auto-arity with `deflazy`
  """

  use Quark.Curry

  defmacro __using__(_) do
    quote do
      import Quark.Partial, only: [defpartial: 2, defpartialp: 2]
    end
  end

  defmacro defpartial(head, do: body), do: rehydrate(head, body)

  defp rehydrate({fun_name, ctx, []}, body) do
    quote do defcurry(head, do: body) end
  end

  defp rehydrate({fun_name, ctx, [arg|args]}, body) do
    quote do
      def unquote({fun_name, ctx, [arg|args]}) do
        Enum.reduce(args, unquote({fun_name, ctx, []}), &(&1.(&2)))
      end
    end

    rehydrate({fun_name, ctx, args}, body)
  end
end
