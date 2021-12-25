defmodule ExjDemoTest do
  use ExUnit.Case
  doctest ExjDemo

  test "greets the world" do
    assert ExjDemo.hello() == :world
  end
end
