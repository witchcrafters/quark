defmodule QuarkTest do
  use ExUnit.Case

  doctest Quark, import: true
  doctest Quark.BCKW, import: true
  doctest Quark.Compose, import: true
  doctest Quark.Curry, import: true
  doctest Quark.FixedPoint, import: true
  # doctest Quark.Partial, import: true
  doctest Quark.Sequence, import: true
  doctest Quark.SKI, import: true
end
