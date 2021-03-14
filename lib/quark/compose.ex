defmodule Quark.Compose do
  @moduledoc ~S"""
  Function composition is taking two functions, and joining them together to
  create a new function. For example:

  ## Examples

      iex> sum_plus_one = compose([&(&1 + 1), &Enum.sum/1])
      ...> sum_plus_one.([1,2,3])
      7

  In this case, we have joined `Enum.sum` with a function that adds one,
  to create a new function that takes a list, sums it, and adds one.

  Note that composition normally applies _from right to left_, though `Quark`
  provides the opposite in the form of `*_forward` functions.
  """

  import Quark.SKI

  import Quark.Curry

  @doc ~S"""
  Function composition

  ## Examples

      iex> sum_plus_one = compose(&(&1 + 1), &Enum.sum/1)
      ...> [1, 2, 3] |> sum_plus_one.()
      7

  """
  @spec compose(fun, fun) :: any
  def compose(g, f) do
    fn x ->
      x
      |> curry(f).()
      |> curry(g).()
    end
  end

  @doc ~S"""
  Function composition, from the tail of the list to the head

  ## Examples

      iex> sum_plus_one = compose([&(&1 + 1), &Enum.sum/1])
      ...> [1,2,3] |> sum_plus_one.()
      7

  """
  @spec compose([fun]) :: fun
  def compose(funcs) when is_list(funcs), do: funcs |> List.foldr(&id/1, &compose/2)

  @doc ~S"""
  Infix compositon operator

  ## Examples

      iex> sum_plus_one = fn x -> x + 1 end <|> &Enum.sum/1
      ...> sum_plus_one.([1,2,3])
      7

      iex> add_one  = &(&1 + 1)
      ...> piped    = [1, 2, 3] |> Enum.sum() |> add_one.()
      ...> composed = [1, 2, 3] |> ((add_one <|> &Enum.sum/1)).()
      ...> piped == composed
      true

  """
  @spec fun <|> fun :: fun
  def g <|> f, do: compose(g, f)

  @doc ~S"""
  Function composition, from the head to tail (left-to-right)

  ## Examples

      iex> sum_plus_one = compose_forward(&Enum.sum/1, &(&1 + 1))
      ...> [1, 2, 3] |> sum_plus_one.()
      7

  """
  @spec compose_forward(fun, fun) :: fun
  def compose_forward(f, g) do
    compose(g, f)
  end

  @doc ~S"""
  Infix "forward" compositon operator

  ## Examples

      iex> sum_plus_one = (&Enum.sum/1) <~> fn x -> x + 1 end
      ...> sum_plus_one.([1, 2, 3])
      7

      iex> x200 = (&(&1 * 2)) <~> (&(&1 * 10)) <~> (&(&1 * 10))
      ...> x200.(5)
      1000

      iex> add_one  = &(&1 + 1)
      ...> piped    = [1, 2, 3] |> Enum.sum() |> add_one.()
      ...> composed = [1, 2, 3] |> ((&Enum.sum/1) <~> add_one).()
      ...> piped == composed
      true

  """
  @spec fun <~> fun :: fun
  def f <~> g, do: compose_forward(f, g)

  @doc ~S"""
  Compose functions, from the head of the list of functions.

  ## Examples

      iex> sum_plus_one = compose_forward([&Enum.sum/1, &(&1 + 1)])
      ...> sum_plus_one.([1, 2, 3])
      7

  """
  @spec compose_forward([fun]) :: fun
  def compose_forward(funcs) when is_list(funcs), do: funcs |> List.foldl(&id/1, &compose/2)
end