defmodule Solution.Day11Test do
  use ExUnit.Case, async: false
  alias Solution.Day11

  describe "Fuel cell power level" do
    test "Example from Problem Statement" do
      assert Day11.fuel_cell_power({122, 79}, 57) == -5
      assert Day11.fuel_cell_power({217, 196}, 39) == 0
      assert Day11.fuel_cell_power({101, 153}, 71) == 4
    end
  end

  describe "Build grid" do
    test "3x3 grid - Serial number: 7" do
      serial_number = 7

      p = fn x, y ->
        Day11.fuel_cell_power({x, y}, serial_number)
      end

      assert Day11.build_grid(serial_number, 3) ==
               [
                 [p.(1, 1), p.(2, 1), p.(3, 1)],
                 [p.(1, 2), p.(2, 2), p.(3, 2)],
                 [p.(1, 3), p.(2, 3), p.(3, 3)]
               ]
    end

  end

  describe "Part 1" do
    @tag timeout: 10_000
    test "Example from Problem Statement" do
      assert "33,45" ==
               Day11.solve_part_1("""
               18
               """)
    end
  end

  describe "Part 2" do
    @tag :skip
    test "Example from Problem Statement" do
      assert "3" ==
               Day11.solve_part_2("""
               """)
    end
  end
end
