defmodule Besom.Classic do
  @moduledoc ~S"""
  The classic "letter" combinators. `s` and `k` alone can be used to express any
  algorithm, though generally not efficiently.

  For performance reasons, many of the combinators are given
  non-combinatory implementations.
  """

  import Besom.Classic.SKI
  import Besom.Classic.BCKW
  import Besom.Classic.FixedPoint
end
