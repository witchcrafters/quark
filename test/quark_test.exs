defmodule QuarkTest do
  use ExUnit.Case
  doctest Quark
  doctest Quark.Compose
  doctest Quark.Classic.BCKW
  # doctest Quark.Classic.FixedPoint
  doctest Quark.Classic.SKI

  doctest Quark.Curry
end
