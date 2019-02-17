defmodule Solution.Day6.GridStringTest do
  use ExUnit.Case
  alias Solution.Day6.GridString
  alias Solution.Day6.GridString.GridPoint

  describe "From String" do
    test "Only numbers" do
      assert GridString.from_string("""
             |   |   | 2 |   |   |   |   |   |   |
             |   | 2 | 1 | 2 |   |   |   |   |   |
             | 2 | 1 | 0 | 1 | 2 |   |   |   |   |
             |   | 2 | 1 | 2 |   |   | 2 |   |   |
             |   |   | 2 |   |   | 2 | 1 | 2 |   |
             |   |   |   |   | 2 | 1 | 0 | 1 | 2 |
             |   |   |   |   |   | 2 | 1 | 2 |   |
             |   |   |   |   |   |   | 2 |   |   |
             """) == %GridString{
               grid: [
                 [" ", " ", "2", " ", " ", " ", " ", " ", " "],
                 [" ", "2", "1", "2", " ", " ", " ", " ", " "],
                 ["2", "1", "0", "1", "2", " ", " ", " ", " "],
                 [" ", "2", "1", "2", " ", " ", "2", " ", " "],
                 [" ", " ", "2", " ", " ", "2", "1", "2", " "],
                 [" ", " ", " ", " ", "2", "1", "0", "1", "2"],
                 [" ", " ", " ", " ", " ", "2", "1", "2", " "],
                 [" ", " ", " ", " ", " ", " ", "2", " ", " "]
               ]
             }
    end

    test "Number of space doesn't matter" do
      assert GridString.from_string("""
             |   |      | 2 |     |   |
             |   | 2    | 1 |   2 |    |
             | 2 | 1    | 0 |   1 | 2 |
             |   | 2    | 1 |   2 |        |
             |   |      | 2 |     |   |
             """) == %GridString{
               grid: [
                 [" ", " ", "2", " ", " "],
                 [" ", "2", "1", "2", " "],
                 ["2", "1", "0", "1", "2"],
                 [" ", "2", "1", "2", " "],
                 [" ", " ", "2", " ", " "]
               ]
             }
    end

    test "Multiple chars" do
      assert GridString.from_string("""
             |   |     | 2. |   |   |
             |   | 234 | 1  | 2 |   |
             | 2 | 1   | 0  | 1 | 2 |
             |   | 2   | 1  | x |   |
             |   |     | 2  |   |   |
             """) == %GridString{
               grid: [
                 [" ", " ", "2.", " ", " "],
                 [" ", "234", "1", "2", " "],
                 ["2", "1", "0", "1", "2"],
                 [" ", "2", "1", "x", " "],
                 [" ", " ", "2", " ", " "]
               ]
             }
    end
  end

  describe "To String" do
    test "Add empty line at top" do
      assert """
             |   |   | 2 |   |   |
             |   | 2 | 1 | 2 |   |
             | 2 | 1 | 0 | 1 | 2 |
             |   | 2 | 1 | x |   |
             |   |   | 2 |   |   |
             """
             |> GridString.from_string()
             |> String.Chars.to_string() ==
               """

               |   |   | 2 |   |   |
               |   | 2 | 1 | 2 |   |
               | 2 | 1 | 0 | 1 | 2 |
               |   | 2 | 1 | x |   |
               |   |   | 2 |   |   |\
               """
    end

    test "Varied width" do
      assert """
             |   |     | 2. |   |   |
             |   | 234 | 1  | 2 |   |
             | 2 | 1   | 0  | 1 | 2 |
             |   | 2   | 1  | x |   |
             |   |     | 2  |   |   |
             """
             |> GridString.from_string()
             |> String.Chars.to_string() ==
               """

               |   |     | 2. |   |   |
               |   | 234 | 1  | 2 |   |
               | 2 | 1   | 0  | 1 | 2 |
               |   | 2   | 1  | x |   |
               |   |     | 2  |   |   |\
               """
    end
  end

  describe "From Grid Points" do
    test "Positive coordinate" do
      points = [
        %GridPoint{point: {4, 6}, value: "a"},
        %GridPoint{point: {1, 6}, value: "b"},
        %GridPoint{point: {0, 3}, value: "c"}
      ]

      grid_from_points = GridString.from_grid_points(points)

      assert grid_from_points.grid == [
               [" ", " ", " ", " ", " "],
               [" ", " ", " ", " ", " "],
               [" ", " ", " ", " ", " "],
               ["c", " ", " ", " ", " "],
               [" ", " ", " ", " ", " "],
               [" ", " ", " ", " ", " "],
               [" ", "b", " ", " ", "a"]
             ]
    end

    test "Only show quadrant with positive coordinates" do
      point_with_negative_coordinates = %GridPoint{point: {-1, 3}, value: "negative"}

      points = [
        point_with_negative_coordinates,
        %GridPoint{point: {1, 2}, value: "b"},
        %GridPoint{point: {0, 3}, value: "c"}
      ]

      grid_from_points = GridString.from_grid_points(points)

      refute Enum.any?(grid_from_points.grid, fn line ->
               Enum.any?(line, fn cell ->
                 cell == point_with_negative_coordinates.value
               end)
             end)
    end

    @tag :only
    test "Fixed Height / Width" do
      points = [
        %GridPoint{point: {4, 6}, value: "a"},
        %GridPoint{point: {1, 6}, value: "b"},
        %GridPoint{point: {0, 3}, value: "c"}
      ]

      grid_from_points = GridString.from_grid_points(points, width: 4, height: 9)

      assert grid_from_points.grid == [
               [" ", " ", " ", " "],
               [" ", " ", " ", " "],
               [" ", " ", " ", " "],
               ["c", " ", " ", " "],
               [" ", " ", " ", " "],
               [" ", " ", " ", " "],
               [" ", "b", " ", " "],
               [" ", " ", " ", " "],
               [" ", " ", " ", " "],
             ]
    end
  end
end
