defmodule Quark.PartialTest do
  use ExUnit.Case, async: true
  use Quark.Partial

  defpartial one(), do: 1
  test "creates zero arity functions" do
    assert one() == 1
  end

  defpartial div(a, b), do: a / b
  test "creates fully-curried functions" do
    assert div.(10).(2) == 5
  end
end
