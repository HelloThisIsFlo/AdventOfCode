defmodule SolutionsTest do
  use ExUnit.Case
  doctest Solutions

  test "greets the world" do
    assert Solutions.hello() == :world
  end
end
