defmodule Quark.Lazy do
  @moduledoc ~S"""
  Not *actually* lazy, but want to keep apart from `defcurry` so that users can
  write multiple arities thenselves with `defcurry`, and auto-arity with `deflazy`
  """

  use Quark.Curry

  defmacro __using__(_) do
    quote do
      import Quark.Lazy, only: [deflazy: 2, deflazyp: 2]
    end
  end

  defmacro deflazy(head, do: body) do
    {fname, ctx, args} = head
    curried = quote do: defcurry(head, do: body)

    Enum.reduce({args, []}, &rehydrate(&1, curried, head))
  end

  defp rehydrate(curried, {_, _, []}) do
    quote do: unquote(curried)
  end

  defp rehydrate(curried, {fun_name, ctx, _}) do
    quote do
      def unquote({fun_name, ctx, args}) do
        Enum.reduce(args, curried, &(&1.(&2)))
      end
    end

    rehydrate(curried, {fun_name, ctx, rest(args)})
  end
end
