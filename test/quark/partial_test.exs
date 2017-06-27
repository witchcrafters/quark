defmodule Quark.PartialTest do
  use ExUnit.Case, async: true
  use Quark.Partial

  defpartial one(), do: 1
  test "creates zero arity functions" do
    assert one() == 1
  end

  defpartial minus(a, b, c), do: a - b - c
  test "creates fully-curried functions" do
    assert minus().(10).(2).(1) == 7
  end

  test "can partially apply functions" do
    assert minus(100).(5).(10) == 85
  end

  test "can use functions in an uncurried manner" do
    assert minus(4, 2, 1) == 1
  end

  defpartialp minusp(a, b, c), do: a - b - c
  test "creates fully-curried private functions" do
    assert minusp().(10).(2).(1) == 7
  end

  test "can partially apply private functions" do
    assert minusp(100).(5).(10) == 85
  end

  test "can use private functions in an uncurried manner" do
    assert minusp(4, 2, 1) == 1
  end
end
