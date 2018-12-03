defmodule Solution.Day3Test do
  use ExUnit.Case
  alias Solution.Day3
  alias Solution.Day3.ClaimedArea
  alias Solution.Day3.ClaimedCoordinates
  alias Solution.Day3.FabricCoordinates

  describe "Part 1" do
    test "Claim parsing" do
      assert ClaimedArea.from_string("#333 @ 4,5: 4x5") == %ClaimedArea{
               id: 333,
               top_left: %FabricCoordinates{x: 4, y: 5},
               width: 4,
               height: 5
             }

      assert ClaimedArea.from_string("#9 @ 488,544: 2114x5000") == %ClaimedArea{
               id: 9,
               top_left: %FabricCoordinates{x: 488, y: 544},
               width: 2114,
               height: 5000
             }
    end

    def coordinates(x: x, y: y, owner: owner) do
      %ClaimedCoordinates{
        coordinates: %FabricCoordinates{x: x, y: y},
        claimed_by: [owner]
      }
    end

    test "Claim coordinate mapping" do
      top_left = %FabricCoordinates{x: 1, y: 4}
      area_1_by_1 = %ClaimedArea{id: 1, top_left: top_left, width: 1, height: 1}
      area_2_by_2 = %ClaimedArea{id: 1, top_left: top_left, width: 2, height: 2}

      assert ClaimedArea.all_claimed_coordinates(area_1_by_1) == [
               coordinates(x: 1, y: 4, owner: 1)
             ]

      assert_equal_in_any_order(ClaimedArea.all_claimed_coordinates(area_2_by_2), [
        coordinates(x: 1, y: 4, owner: 1),
        coordinates(x: 2, y: 4, owner: 1),
        coordinates(x: 1, y: 5, owner: 1),
        coordinates(x: 2, y: 5, owner: 1)
      ])
    end

    def assert_equal_in_any_order(list_1, list_2) do
      assert Enum.sort(list_1) == Enum.sort(list_2)
    end

    test "Example from Problem Statement" do
      assert "4" ==
               Day3.solve_part_1("""
               #1 @ 1,3: 4x4
               #2 @ 3,1: 4x4
               #3 @ 5,5: 2x2
               """)
    end
  end

  describe "Part 2" do
    test "Example from Problem Statement" do
      assert "3" ==
               Day3.solve_part_2("""
               #1 @ 1,3: 4x4
               #2 @ 3,1: 4x4
               #3 @ 5,5: 2x2
               """)
    end
  end
end
