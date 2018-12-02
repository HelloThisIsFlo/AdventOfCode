defmodule Solution.Day1Test do
  use ExUnit.Case
  alias Solution.Day1

  describe "Part 1" do
    test "Single Change" do
      assert "1" ==
               Day1.solve_part_1("""
                 +1
               """)
    end

    test "Multiple Changes" do
      assert "85" ==
               Day1.solve_part_1("""
               +1
               +1
               -44
               +127
               """)
    end
  end

  describe "Part 2" do
    test "Examples from Problem statement" do
      assert "0" ==
               Day1.solve_part_2("""
               +1
               -1
               """)

      assert "10" ==
               Day1.solve_part_2("""
               +3
               +3
               +4
               -2
               -4
               """)

      assert "5" ==
               Day1.solve_part_2("""
               -6
               +3
               +8
               +5
               -6
               """)

      assert "14" ==
               Day1.solve_part_2("""
               +7
               +7
               -2
               -7
               -4
               """)
    end
  end
end
