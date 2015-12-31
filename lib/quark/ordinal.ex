defprotocol Quark.Ordinal do
  @moduledoc ~S"""
  """

  @doc ~S"""
  """
  @spec zeroth(any) :: any
  def zeroth(specimen)

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
