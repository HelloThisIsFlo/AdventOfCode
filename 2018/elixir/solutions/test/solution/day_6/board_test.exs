defmodule Solution.Day6.BoardTest do
  use ExUnit.Case
  alias Solution.Day6.Board
  alias Solution.Day6.Board.InvalidBoard
  alias Solution.Day6.ClosestPointsArea
  import Solution.Day6.Helper, only: [to_grow_stage: 1]

  describe "Build from Grid" do
    test "Areas already grown - Raise error" do
      grid_with_with_areas_not_at_stage_0 = [
        [" ", "1", " ", " ", " ", " ", " "],
        ["1", "0", "1", " ", " ", " ", " "],
        [" ", "1", " ", " ", " ", " ", " "],
        [" ", " ", " ", "1", " ", " ", " "],
        [" ", " ", "1", "0", "1", " ", " "],
        [" ", " ", " ", "1", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "]
      ]

      assert_raise InvalidBoard, fn ->
        Board.from_grid(grid_with_with_areas_not_at_stage_0)
      end
    end

    test "Single Area" do
      grid = [
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", "0", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "]
      ]

      board = Board.from_grid(grid)

      assert board.areas == [ClosestPointsArea.from_origin({1, 1})]
    end

    test "Multiple Area" do
      grid = [
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", "0", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", "0", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", "0", " "],
        [" ", " ", " ", " ", " ", " ", " "]
      ]

      board = Board.from_grid(grid)

      assert board.areas == [
               ClosestPointsArea.from_origin({1, 1}),
               ClosestPointsArea.from_origin({2, 4}),
               ClosestPointsArea.from_origin({5, 5})
             ]
    end
  end

  describe "Validate Grow Stages" do
    test "Single Grow Stage -> Always valid" do
      grow_stage =
        [
          [" ", " ", " ", " ", " "],
          [" ", " ", "x", " ", " "],
          [" ", "x", " ", "x", " "],
          [" ", " ", "x", " ", " "],
          [" ", " ", " ", " ", " "]
        ]
        |> to_grow_stage()

      validated_grow_stages = Board.validate_grow_stages([grow_stage])

      assert validated_grow_stages == [grow_stage]
    end

    test "- Multiple Grow Stages - No Intersection" do
      grow_stage_1 =
        [
          [" ", " ", " ", " ", " ", " ", " "],
          [" ", " ", "x", " ", " ", " ", " "],
          [" ", "x", " ", "x", " ", " ", " "],
          [" ", " ", "x", " ", " ", " ", " "],
          [" ", " ", " ", " ", " ", " ", " "],
          [" ", " ", " ", " ", " ", " ", " "],
          [" ", " ", " ", " ", " ", " ", " "]
        ]
        |> to_grow_stage()

      grow_stage_2 =
        [
          [" ", " ", " ", " ", " ", " ", " "],
          [" ", " ", " ", " ", " ", " ", " "],
          [" ", " ", " ", " ", " ", " ", " "],
          [" ", " ", " ", " ", "x", " ", " "],
          [" ", " ", " ", "x", " ", "x", " "],
          [" ", " ", " ", " ", "x", " ", " "],
          [" ", " ", " ", " ", " ", " ", " "]
        ]
        |> to_grow_stage()

      grow_stage_3 =
        [
          [" ", " ", " ", " ", "x", " ", " "],
          [" ", " ", " ", "x", " ", "x", " "],
          [" ", " ", " ", " ", "x", " ", " "],
          [" ", " ", " ", " ", " ", " ", " "],
          [" ", " ", " ", " ", " ", " ", " "],
          [" ", " ", " ", " ", " ", " ", " "],
          [" ", " ", " ", " ", " ", " ", " "]
        ]
        |> to_grow_stage()

      first_two = [grow_stage_1, grow_stage_2]
      all_three = [grow_stage_1, grow_stage_2, grow_stage_3]

      validated_first_two_grow_stages = Board.validate_grow_stages(first_two)
      validated_all_three_grow_stages = Board.validate_grow_stages(all_three)

      assert validated_first_two_grow_stages == first_two
      assert validated_all_three_grow_stages == all_three
    end

    test "- 2 Grow Stages - Intersection - Validated stages do not contain points at intersection" do
      # Note: CAPS X highlights the points of intersection
      grow_stage_1 =
        [
          [" ", "x", " ", " ", " "],
          ["x", " ", "X", " ", " "],
          [" ", "x", " ", " ", " "]
        ]
        |> to_grow_stage()

      grow_stage_2 =
        [
          [" ", " ", " ", "x", " "],
          [" ", " ", "X", " ", "x"],
          [" ", " ", " ", "x", " "]
        ]
        |> to_grow_stage()

      validated_grow_stages = Board.validate_grow_stages([grow_stage_1, grow_stage_2])

      assert Enum.at(validated_grow_stages, 0) ==
               [
                 [" ", "x", " ", " ", " "],
                 ["x", " ", " ", " ", " "],
                 [" ", "x", " ", " ", " "]
               ]
               |> to_grow_stage()

      assert Enum.at(validated_grow_stages, 1) ==
               [
                 [" ", " ", " ", "x", " "],
                 [" ", " ", " ", " ", "x"],
                 [" ", " ", " ", "x", " "]
               ]
               |> to_grow_stage()
    end

    test "- Multiple Grow Stages - Intersection - Validated stages do not contain points at intersection" do
      grow_stage_1 =
        [
          [" ", "x", " ", " ", " "],
          ["x", " ", "X", " ", " "],
          [" ", "X", " ", " ", " "],
          [" ", " ", " ", " ", " "],
          [" ", " ", " ", " ", " "]
        ]
        |> to_grow_stage()

      grow_stage_2 =
        [
          [" ", " ", " ", " ", " "],
          [" ", " ", "X", " ", " "],
          [" ", "X", " ", "X", " "],
          [" ", " ", "X", " ", " "],
          [" ", " ", " ", " ", " "]
        ]
        |> to_grow_stage()

      grow_stage_3 =
        [
          [" ", " ", " ", " ", " "],
          [" ", " ", " ", " ", " "],
          [" ", " ", " ", "X", " "],
          [" ", " ", "X", " ", "x"],
          [" ", " ", " ", "x", " "]
        ]
        |> to_grow_stage()

      validated_grow_stages =
        Board.validate_grow_stages([grow_stage_1, grow_stage_2, grow_stage_3])

      assert Enum.at(validated_grow_stages, 0) ==
               [
                 [" ", "x", " ", " ", " "],
                 ["x", " ", " ", " ", " "],
                 [" ", " ", " ", " ", " "],
                 [" ", " ", " ", " ", " "],
                 [" ", " ", " ", " ", " "]
               ]
               |> to_grow_stage()

      assert Enum.at(validated_grow_stages, 1) ==
               [
                 [" ", " ", " ", " ", " "],
                 [" ", " ", " ", " ", " "],
                 [" ", " ", " ", " ", " "],
                 [" ", " ", " ", " ", " "],
                 [" ", " ", " ", " ", " "]
               ]
               |> to_grow_stage()

      assert Enum.at(validated_grow_stages, 2) ==
               [
                 [" ", " ", " ", " ", " "],
                 [" ", " ", " ", " ", " "],
                 [" ", " ", " ", " ", " "],
                 [" ", " ", " ", " ", "x"],
                 [" ", " ", " ", "x", " "]
               ]
               |> to_grow_stage()

      IO.puts("TODO")
    end
  end

  describe "Grow Points" do
    test "Single point" do
    end
  end
end
