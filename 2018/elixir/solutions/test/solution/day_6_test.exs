defmodule Solution.Day6Test do
  use ExUnit.Case, async: false
  # alias Solution.Day6
  # alias Solution.Day6.Board
  # alias Solution.Day6.ClosestPointsArea
  # alias Solution.Day6.ClosestPointsArea.InvalidArea
  # import Solution.Day6.Helper, only: [to_grow_stage: 1]

  @moduletag :capture_log

  describe "Test Area Growth" do
    test "asdf" do

    end
  end

  describe "Part 1" do
    @tag :skip
    test "Example from Problem Statement" do
      assert "17" ==
               Day6.solve_part_1("""
               1, 1
               1, 6
               8, 3
               3, 4
               5, 5
               8, 9
               """)
    end
  end

  describe "Part 2" do
    @tag :skip
    test "Example from Problem Statement" do
      assert "?????" ==
               Day6.solve_part_1("""
               1, 1
               1, 6
               8, 3
               3, 4
               5, 5
               8, 9
               """)
    end
  end
end
