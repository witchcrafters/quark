defmodule Quark.Compose do
  @moduledoc ~S"""
  """

  alias Quark, as: Q

  @doc ~S"""
  Function composition

      iex> sum_plus_one = Quark.Compose.compose(&(&1 + 1), &Enum.sum/1)
      iex> [1,2,3] |> sum_plus_one.()
      7

  """
  @spec compose((... -> any), (... -> any)) :: any
  defdelegate compose(g, f), to: Quark.Classic.BCKW, as: :b

  @doc ~S"""
  Function composition, from the tail of the list to the head

      iex> sum_plus_one = Quark.Compose.compose([&(&1 + 1), &Enum.sum/1])
      iex> [1,2,3] |> sum_plus_one.()
      7

  """
  @spec compose([(... -> any)]) :: (... -> any)
  def compose(func_list), do: List.foldr(func_list, &Q.id/1, &compose(&1,&2))

  @doc ~S"""
  Infix compositon operator

      iex> import Quark.Compose
      iex> sum_plus_one = fn x -> x + 1 end <|> &Enum.sum/1
      iex> sum_plus_one.([1,2,3])
      7

      iex> import Quark.Compose
      iex> add_one = &(&1 + 1)
      iex> piped = [1,2,3] |> Enum.sum |> add_one.()
      iex> composed = [1,2,3] |> ((add_one <|> &Enum.sum/1)).()
      iex> piped == composed
      true

  """
  @spec (... -> any) <|> (... -> any) :: (... -> any)
  def g <|> f, do: compose(g, f)

  @doc ~S"""
  Function composition, from the back of the lift to the front

     iex> sum_plus_one = Quark.Compose.compose_forward(&(Enum.sum(&1)), &(&1 + 1))
     iex> [1,2,3] |> sum_plus_one.()
     7

  """
  @spec compose_forward((... -> any), (... -> any)) :: (... -> any)
  def compose_forward(f,g), do: &(g.(f.(&1)))


  @doc ~S"""
  Compose functions, from the head of the list of functions. The is the reverse
  order versus what one would normally expect (left to right rather than right to left).

      iex> sum_plus_one = Quark.Compose.compose_list_forward([&Enum.sum/1, &(&1 + 1)])
      iex> [1,2,3] |> sum_plus_one.()
      7

  """
  @spec compose_list_forward([(... -> any)]) :: (... -> any)
  def compose_list_forward(func_list), do: Enum.reduce(func_list, &Q.id/1, &compose/2)
end
