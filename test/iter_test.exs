defmodule IterTest do
  use ExUnit.Case
  doctest Iter

  test "greets the world" do
    assert Iter.hello() == :world
  end
end
