defmodule Solution.Day2Test do
  use ExUnit.Case
  alias Solution.Day2

  describe "Part 1" do
    test "Single entry" do
      assert "0" ==
               Day2.solve_part_1("""
               abcdef
               """)

      # Duplicate but no triplicate
      assert "0" ==
               Day2.solve_part_1("""
               abbcde
               """)

      # Triplicate but no duplicate
      assert "0" ==
               Day2.solve_part_1("""
               abcccd
               """)

      # Triplicate and duplicate
      assert "1" ==
               Day2.solve_part_1("""
               bababc
               """)
    end

    test "Example from Problem Statement" do
      assert "12" ==
               Day2.solve_part_1("""
                   abcdef
                   bababc
                   abbcde
                   abcccd
                   aabcdd
                   abcdee
                   ababab
               """)
    end
  end

  describe "Part 2" do
    @tag :skip
    test "todo 2"
  end
end
