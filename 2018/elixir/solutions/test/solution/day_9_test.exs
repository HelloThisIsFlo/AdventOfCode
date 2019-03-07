defmodule Solution.Day9Test do
  use ExUnit.Case, async: false
  alias Solution.Day9

  setup do
    :ok
  end

  describe "Part 1" do
    @tag :skip
    test "Example from Problem Statement" do
      assert "138" ==
               Day9.solve_part_1("""
               2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
               """)
    end
  end

  describe "Part 2" do
    @tag :skip
    test "Example from Problem Statement" do
      assert "66" ==
               Day9.solve_part_2("""
               2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
               """)
    end
  end
end
