defmodule Solution.Day5Test do
  use ExUnit.Case, async: false
  alias Solution.Day5

  describe "Part 1" do
    test "Same letter - Opposite polarity" do
      assert Day5.solve_part_1("aA") == "0"
    end

    test "Same letter - Same polarity" do
      assert Day5.solve_part_1("aa") == "2"
      assert Day5.solve_part_1("AA") == "2"
    end

    test "Different letters" do
      assert Day5.solve_part_1("ab") == "2"
      assert Day5.solve_part_1("AB") == "2"
      assert Day5.solve_part_1("aB") == "2"
      assert Day5.solve_part_1("Ab") == "2"
    end

    test "Two pairs - Not reacting" do
      assert Day5.solve_part_1("aaBB") == "4"
    end

    test "Nested opposite polarities" do
      assert Day5.solve_part_1("abBA") == "0"
    end

    test "Example from Problem Statement" do
      assert Day5.solve_part_1("dabAcCaCBAcCcaDA") == "10"
    end

    test "Needs 4 passes" do
      assert Day5.solve_part_1("abcdDCBA") == "0"
    end

    test "Trim newlines" do
      assert Day5.solve_part_1("""

      abcdDCBA

      """) == "0"
    end

    @tag :skip
    test "Debug Performance" do
      from_file = File.read!("../../inputs/day5.txt")
      res = Day5.solve_part_1(from_file)
    end

  end

  # describe "Part 2" do
  #   test "Example from Problem Statement" do
  #   end
  # end
end
