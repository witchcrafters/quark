defmodule Quark.CurryTest do
  use ExUnit.Case, async: true
  import Quark.Curry

  defcurry div(a, b), do: a / b
  defcurryp minus(a, b), do: a - b

  test "applies in sequence" do
    assert div().(10).(5) == 2
  end

  test "curried functions can partially apply" do
    div10 = div().(10)
    assert div10.(2) == 5
  end

  test "private functions apply in sequence" do
    assert minus().(10).(2) == 8
  end

  test "private curried functions can partially apply" do
    below10 = minus().(10)
    assert below10.(9) == 1
  end
end
