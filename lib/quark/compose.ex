defmodule Quark.Compose do
  @moduledoc ~S"""
  """

  alias Quark.Classic.BCKW, as: BCKW

  @doc ~S"""
  Function composition

      iex> sum_plus_one = compose(&(&1 + 1), &(Enum.sum(&1)))
      iex> [1,2,3] |> sum_plus_one.()
      7

  """
  @spec compose((... -> any), (... -> any)) :: any
  def compose(g, f), do: BCKW.b(g, f)

  @doc ~S"""
  Infix compositon operator

      iex> sum_plus_one = &(&1 + 1) <|> &(Enum.sum(&1))
      iex> sum_plus_one.([1,2,3])
      7

      iex> pipe = [1,2,3] |> &(Enum.sum(&1)).() |> &(&1 + 1).()
      iex> compose = [1,2,3] |> (&(&1 + 1) <|> &(Enum.sum(&1))).()
      iex> pipe == compose
      True

  """
  @spec (... -> any) <|> (... -> any) :: (... -> any)
  def g <|> f, do: compose(g, f)

  @doc ~S"""
  Function composition, from the back of the lift to the front

     iex> sum_plus_one = Witchcraft.Utility.compose_forward(&(Enum.sum(&1)), &(&1 + 1))
     iex> [1,2,3] |> sum_plus_one.()
     7

  """
  @spec compose_forward((... -> any), (... -> any)) :: (... -> any)
  def compose_forward(f,g), do: &(g.(f.(&1)))

  @doc ~S"""
  Function composition, from the tail of the list to the head

      iex> sum_plus_one = Witchcraft.Utility.compose([&(&1 + 1), &(Enum.sum(&1))])
      iex> [1,2,3] |> sum_plus_one.()
      7

  """
  @spec compose_list([(... -> any)]) :: (... -> any)
  def compose_list(func_list), do: List.foldr(func_list, &C.id/1, &compose(&1,&2))

  @doc ~S"""
  Compose functions, from the head of the list of functions. The is the reverse
  order versus what one would normally expect (left to right rather than right to left).

      iex> sum_plus_one = Witchcraft.Utility.compose_list_forward([&(Enum.sum(&1)), &(&1 + 1)])
      iex> [1,2,3] |> sum_plus_one.()
      7

  """
  @spec compose_list_forward([(... -> any)]) :: (... -> any)
  def compose_list_forward(func_list), do: Enum.reduce(func_list, &C.id/1, &compose/2)
end
