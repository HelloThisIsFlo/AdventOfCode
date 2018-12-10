defmodule Solution.Day6.HelperTest do
  use ExUnit.Case
  alias Solution.Day6.Helper
  alias Solution.Day6.GridString

  test "Convert grid_string to grow stage" do
    assert """
           |   |   |   |   |   |
           |   |   | x |   |   |
           |   | x |   | x |   |
           |   |   | x |   |   |
           |   |   |   |   |   |
           """
           |> GridString.from_string()
           |> Helper.to_list_of_points()
           == Enum.sort([{2, 1}, {1, 2}, {3, 2}, {2, 3}])
  end

  test "Case invariant" do
    assert """
           |   |   |   |   |   |
           |   |   | X |   |   |
           |   | X |   | x |   |
           |   |   | x |   |   |
           |   |   |   |   |   |
           """
           |> GridString.from_string()
           |> Helper.to_list_of_points() == Enum.sort([{2, 1}, {1, 2}, {3, 2}, {2, 3}])
  end
end
