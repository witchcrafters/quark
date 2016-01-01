defmodule QuarkTest do
  use ExUnit.Case
  doctest Quark

  doctest Quark.Classic
  doctest Quark.Classic.BCKW
  doctest Quark.Classic.FixedPoint
  doctest Quark.Classic.SKI

  doctest Quark.Compose

  doctest Quark.Curry

  doctest Quark.Sequence
end
