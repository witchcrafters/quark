defprotocol Besom.Ordinal do
  @moduledoc ~S"""
  """

  @doc ~S"""
  """
  @spec zero?(any) :: any
  def zeroth?(element)

  @doc ~S"""
  Increment position in an ordinal collection
  """
  @spec succ(any) :: any
  def succ(element)

  @doc ~S"""
  Decrement position in an ordinal collection
  """
  @spec pred(any) :: any
  def pred(element)
end
