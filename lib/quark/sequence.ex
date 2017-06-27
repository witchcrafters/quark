defprotocol Quark.Sequence do
  @moduledoc "A protocol for stepping through ordered enumerables"

  @doc ~S"""
  The beginning of the sequence.

  For instance, integers are generally thought of as centering around 0.

  ## Examples

      origin(9)
      #=> 0

  """
  @spec origin(any) :: any
  def origin(specimen)

  @doc ~S"""
  The `succ`essor in sequence.

  For integers, this is the number above.

  ## Examples

      iex> succ(1)
      #=> 2

      iex> 10 |> origin() |> succ() |> succ()
      #=> 2

  """
  @spec succ(any) :: any
  def succ(element)

  @doc ~S"""
  The `pred`essor in the sequence.

  For integers, this is the number below.

  ## Examples

      pred(10)
      #=> 9

      42 |> origin() |> pred() |> pred()
      #=> -2

  """
  @spec pred(any) :: any
  def pred(element)
end

defimpl Quark.Sequence, for: Integer do
  @doc ~S"""
  ## Examples

      iex> origin(9)
      0

  """
  def origin(_num), do: 0

  @doc ~S"""
  ## Examples
      iex> succ(1)
      2

      iex> 10 |> origin() |> succ() |> succ()
      2

  """
  def succ(num), do: num + 1

  @doc ~S"""
  ## Examples

      iex> pred(10)
      9

      iex> 42 |> origin() |> pred() |> pred()
      -2

  """
  def pred(num), do: num - 1
end
