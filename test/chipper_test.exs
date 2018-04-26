defmodule ChipperTest do
  use ExUnit.Case
  doctest Chipper

  test "greets the world" do
    assert Chipper.hello() == :world
  end
end
