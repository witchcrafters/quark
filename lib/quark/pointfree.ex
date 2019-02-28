defmodule Quark.Pointfree do
  @moduledoc ~S"""
  Allows defining functions as straight function composition
  (ie: no need to state the argument).

  Provides a clean, composable named functions
  """

  @doc ~S"""
  Define a unary function with an implied subject

  ## Examples

      iex> defmodule Foo do
      ...>   import Quark.Pointfree
      ...>   defx foo(), do: Enum.sum |> fn x -> x + 1 end.()
      ...> end
      ...> Foo.foo([1,2,3])
      7

      iex> defmodule Bar do
      ...>   import Quark.Pointfree
      ...>   defx bar, do: Enum.sum |> fn x -> x + 1 end.()
      ...> end
      ...> Bar.bar([1,2,3])
      7

  """
  defmacro defx(head, do: body) do
    {fun_name, ctx, _} = head

    quote do
      def unquote({fun_name, ctx, [{:subject, [], Elixir}]}) do
        unquote({:subject, [], Elixir}) |> unquote(body)
      end
    end
  end

  @doc ~S"""
  Define a private unary function with an implied subject

  ## Examples

      defmodule Foo do
        import Quark.Pointfree
        defxp foo(), do: Enum.sum |> fn x -> x + 1 end.()
      end

  """
  defmacro defxp(head, do: body) do
    {fun_name, ctx, []} = head

    quote do
      defp unquote({fun_name, ctx, [{:subject, [], Elixir}]}) do
        unquote({:subject, [], Elixir}) |> unquote(body)
      end
    end
  end
end
