defmodule WhereamiTest do
  use ExUnit.Case
  doctest Whereami

  test "greets the world" do
    assert Whereami.hello() == :world
  end
end
