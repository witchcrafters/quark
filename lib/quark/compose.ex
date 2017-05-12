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

  use Quark.Partial
  use Quark.Curry

  @doc ~S"""
  Function composition

  ## Examples

      iex> sum_plus_one = compose(&(&1 + 1), &Enum.sum/1)
      iex> [1,2,3] |> sum_plus_one.()
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
  defpartial compose(func_list), do: func_list |> List.foldr(&id/1, &compose/2)

  @doc ~S"""
  Infix compositon operator

  ## Examples

      iex> sum_plus_one = fn x -> x + 1 end <|> &Enum.sum/1
      iex> sum_plus_one.([1,2,3])
      7

      iex> add_one = &(&1 + 1)
      iex> piped = [1,2,3] |> Enum.sum |> add_one.()
      iex> composed = [1,2,3] |> ((add_one <|> &Enum.sum/1)).()
      iex> piped == composed
      true

  """
  @spec fun <|> fun :: fun
  def g <|> f, do: compose(g, f)

  @doc ~S"""
  Function composition, from the back of the list to the front

  ## Examples

      iex> sum_plus_one = compose_forward(&(Enum.sum(&1)), &(&1 + 1))
      iex> [1,2,3] |> sum_plus_one.()
      7

  """
  @spec compose_forward(fun, fun) :: fun
  defpartial compose_forward(f,g) do
    fn x ->
      x
      |> curry(f).()
      |> curry(g).()
    end
  end

  @doc ~S"""
  Infix "forward" compositon operator

  ## Examples

      iex> sum_plus_one = (&Enum.sum/1) <~> fn x -> x + 1 end
      iex> sum_plus_one.([1,2,3])
      7

      iex> x200 = (&(&1 * 2)) <~> (&(&1 * 10)) <~> (&(&1 * 10))
      iex> x200.(5)
      1000

      iex> add_one = &(&1 + 1)
      iex> piped = [1,2,3] |> Enum.sum |> add_one.()
      iex> composed = [1,2,3] |> ((&Enum.sum/1) <~> add_one).()
      iex> piped == composed
      true

  """
  @spec fun <~> fun :: fun
  def f <~> g, do: compose_forward(f, g)

  @doc ~S"""
  Compose functions, from the head of the list of functions. The is the reverse
  order versus what one would normally expect (left-to-right rather than
  right-to-left).

  ## Examples

      iex> sum_plus_one = compose_list_forward([&Enum.sum/1, &(&1 + 1)])
      ...> [1,2,3] |> sum_plus_one.()
      7

  """
  @spec compose_list_forward([fun]) :: fun
  defpartial compose_list_forward(func_list) do
    func_list |> Enum.reduce(&id/1, &compose/2)
  end
end
