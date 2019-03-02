defmodule Solution.Day7Test do
  use ExUnit.Case, async: false
  alias Solution.Day7

  @moduletag capture_log: false

  describe "Part 1" do
    test "Example from Problem Statement" do
      assert "CABDFE" ==
               Day7.solve_part_1("""
               Step C must be finished before step A can begin.
               Step C must be finished before step F can begin.
               Step A must be finished before step B can begin.
               Step A must be finished before step D can begin.
               Step B must be finished before step E can begin.
               Step D must be finished before step E can begin.
               Step F must be finished before step E can begin.
               """)
    end
  end

  describe "Part 2" do
    @tag :skip
    test "Example from Problem Statement" do
      assert "??" ==
               Day7.solve_part_2("""
               """)
    end
  end
end
