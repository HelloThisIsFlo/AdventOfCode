defmodule Solution.Day6.HelperTest do
  use ExUnit.Case
  alias Solution.Day6.Helper

  test "Convert grid to grow stage" do
    assert Helper.to_grow_stage([
             [" ", " ", " ", " ", " "],
             [" ", " ", "x", " ", " "],
             [" ", "x", " ", "x", " "],
             [" ", " ", "x", " ", " "],
             [" ", " ", " ", " ", " "]
           ]) == Enum.sort([{2, 1}, {1, 2}, {3, 2}, {2, 3}])
  end
end
