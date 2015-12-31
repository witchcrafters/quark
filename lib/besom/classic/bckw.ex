defmodule Besom.Classic.BCKW do
  import Besom.Classic.SKI, only: [k: 2]

  @doc ~S"""
  Normal (binary) function composition
  """
  def b(x, y, z), do: x.(y.(z))

  @doc ~S"""
  Reverse two arguments (`flip`)
  """
  def c(fun), do: &(fun.(&2).(&1))

  @doc ~S"""
  Apply an argument to a functon twice
  """
  def w(fun), do: &(fun.(&1).(&1))
end
