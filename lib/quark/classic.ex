defmodule Quark.Classic do
  @moduledoc ~S"""
  The classic "letter" combinators. `s` and `k` alone can be used to express any
  algorithm, though generally not efficiently.

  For performance reasons, many of the combinators are given
  non-combinatory implementations.
  """

  import Quark.Classic.SKI
  import Quark.Classic.BCKW
  import Quark.Classic.FixedPoint
end
