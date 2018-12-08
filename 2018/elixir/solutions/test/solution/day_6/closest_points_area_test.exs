defmodule Solution.Day6.ClosestPointsAreaTest do
  use ExUnit.Case
  alias Solution.Day6.ClosestPointsArea
  alias Solution.Day6.ClosestPointsArea.InvalidArea

  test "Build from Origin" do
    assert ClosestPointsArea.from_origin({3, 4}) == %ClosestPointsArea{
             fully_grown?: false,
             grow_stages: [
               [{3, 4}]
             ]
           }
  end

  describe "Build from Grid" do
    test "Origin only" do
      #
      # x-----> x
      # |
      # |
      # v y
      #
      assert ClosestPointsArea.from_grid([
               [" ", " ", " ", " ", " "],
               [" ", " ", " ", " ", " "],
               [" ", " ", "0", " ", " "],
               [" ", " ", " ", " ", " "],
               [" ", " ", " ", " ", " "]
             ]) == %ClosestPointsArea{
               fully_grown?: false,
               grow_stages: [
                 [{2, 2}]
               ]
             }
    end

    test "Complete Area" do
      #   0 1 2
      # 0 x-----> x
      # 1 |
      # 2 |
      #   v y
      #
      assert ClosestPointsArea.from_grid([
               [" ", " ", "2", " ", " "],
               [" ", "2", "1", "2", " "],
               ["2", "1", "0", "1", "2"],
               [" ", "2", "1", "2", " "],
               [" ", " ", "2", " ", " "]
             ]) == %ClosestPointsArea{
               fully_grown?: false,
               grow_stages: [
                 [{2, 2}],
                 [{2, 1}, {1, 2}, {3, 2}, {2, 3}],
                 [{2, 0}, {1, 1}, {3, 1}, {0, 2}, {4, 2}, {1, 3}, {3, 3}, {2, 4}]
               ]
             }
    end

    test "Smaller Area" do
      #   0 1 2
      # 0 x-----> x
      # 1 |
      # 2 |
      #   v y
      #
      assert ClosestPointsArea.from_grid([
               [" ", "1", " "],
               ["1", "0", "1"],
               [" ", "1", " "]
             ]) == %ClosestPointsArea{
               fully_grown?: false,
               grow_stages: [
                 [{1, 1}],
                 [{1, 0}, {0, 1}, {2, 1}, {1, 2}]
               ]
             }
    end

    test "Irregular Area" do
      #   0 1 2
      # 0 x-----> x
      # 1 |
      # 2 |
      #   v y
      #
      assert ClosestPointsArea.from_grid([
               [" ", "1", "2"],
               [" ", "0", "1"],
               [" ", " ", " "]
             ]) == %ClosestPointsArea{
               fully_grown?: false,
               grow_stages: [
                 [{1, 1}],
                 [{1, 0}, {2, 1}],
                 [{2, 0}]
               ]
             }
    end
  end

  describe "Current Grow stage" do
    test "Empty Area" do
      assert 0 ==
               [
                 [" ", " ", " ", " ", " "],
                 [" ", " ", " ", " ", " "],
                 [" ", " ", "0", " ", " "],
                 [" ", " ", " ", " ", " "],
                 [" ", " ", " ", " ", " "]
               ]
               |> ClosestPointsArea.from_grid()
               |> ClosestPointsArea.current_grow_stage()
    end

    test "Complete Area" do
      assert 2 ==
               [
                 [" ", " ", "2", " ", " "],
                 [" ", "2", "1", "2", " "],
                 ["2", "1", "0", "1", "2"],
                 [" ", "2", "1", "2", " "],
                 [" ", " ", "2", " ", " "]
               ]
               |> ClosestPointsArea.from_grid()
               |> ClosestPointsArea.current_grow_stage()
    end
  end

  describe "Get All points" do
    test "Complete Area" do
      all_points =
        [
          [" ", " ", "2", " ", " "],
          [" ", "2", "1", "2", " "],
          ["2", "1", "0", "1", "2"],
          [" ", "2", "1", "2", " "],
          [" ", " ", "2", " ", " "]
        ]
        |> ClosestPointsArea.from_grid()
        |> ClosestPointsArea.all_points()

      assert all_points ==
               MapSet.new([
                 {2, 2},
                 {1, 2},
                 {2, 1},
                 {2, 3},
                 {3, 2},
                 {0, 2},
                 {1, 1},
                 {1, 3},
                 {2, 0},
                 {2, 4},
                 {3, 1},
                 {3, 3},
                 {4, 2}
               ])
    end
  end

  defp to_grow_stage(grid) do
    for y <- 0..(length(grid) - 1) do
      for x <- 0..(length(get_line(grid, y)) - 1) do
        case get_point(grid, x, y) do
          " " -> nil
          "x" -> {x, y}
        end
      end
    end
    |> List.flatten()
    |> Enum.reject(&(&1 == nil))
    |> Enum.sort()
  end

  defp get_line(grid, y) do
    grid
    |> Enum.at(y)
  end

  defp get_point(grid, x, y) do
    grid
    |> get_line(y)
    |> Enum.at(x)
  end

  describe "Generate next candidate grow stage" do
    test "- Test the test helper" do
      assert to_grow_stage([
               [" ", " ", " ", " ", " "],
               [" ", " ", "x", " ", " "],
               [" ", "x", " ", "x", " "],
               [" ", " ", "x", " ", " "],
               [" ", " ", " ", " ", " "]
             ]) == Enum.sort([{2, 1}, {1, 2}, {3, 2}, {2, 3}])
    end

    test "- Invalid Area - Emtpy" do
      invalid_area =
        [
          [" ", " ", " "],
          [" ", " ", " "],
          [" ", " ", " "]
        ]
        |> ClosestPointsArea.from_grid()

      assert_raise InvalidArea, fn ->
        ClosestPointsArea.next_candidate_area(invalid_area)
      end
    end

    test "- At stage 0 - Only origin" do
      candidate_area_for_step_1 =
        [
          [" ", " ", " ", " ", " "],
          [" ", " ", " ", " ", " "],
          [" ", " ", "0", " ", " "],
          [" ", " ", " ", " ", " "],
          [" ", " ", " ", " ", " "]
        ]
        |> ClosestPointsArea.from_grid()
        |> ClosestPointsArea.next_candidate_area()

      assert candidate_area_for_step_1 |> Enum.sort() ==
               [
                 [" ", " ", " ", " ", " "],
                 [" ", " ", "x", " ", " "],
                 [" ", "x", " ", "x", " "],
                 [" ", " ", "x", " ", " "],
                 [" ", " ", " ", " ", " "]
               ]
               |> to_grow_stage()
    end

    test "- At stage 0 - Invalid Stage 0" do
      invalid_area =
        [
          [" ", " ", "0"],
          [" ", "0", "0"],
          [" ", " ", "0"]
        ]
        |> ClosestPointsArea.from_grid()

      assert_raise InvalidArea, fn ->
        ClosestPointsArea.next_candidate_area(invalid_area)
      end
    end

    test "- At stage 1" do
      candidate_area_for_step_2 =
        [
          [" ", " ", " ", " ", " "],
          [" ", " ", "1", " ", " "],
          [" ", "1", "0", "1", " "],
          [" ", " ", "1", " ", " "],
          [" ", " ", " ", " ", " "]
        ]
        |> ClosestPointsArea.from_grid()
        |> ClosestPointsArea.next_candidate_area()

      assert candidate_area_for_step_2 |> Enum.sort() ==
               [
                 [" ", " ", "x", " ", " "],
                 [" ", "x", " ", "x", " "],
                 ["x", " ", " ", " ", "x"],
                 [" ", "x", " ", "x", " "],
                 [" ", " ", "x", " ", " "]
               ]
               |> to_grow_stage()
    end

    test "- At stage 2 - Regular Area" do
      candidate_area_for_step_3 =
        [
          [" ", " ", " ", " ", " ", " ", " "],
          [" ", " ", " ", "2", " ", " ", " "],
          [" ", " ", "2", "1", "2", " ", " "],
          [" ", "2", "1", "0", "1", "2", " "],
          [" ", " ", "2", "1", "2", " ", " "],
          [" ", " ", " ", "2", " ", " ", " "],
          [" ", " ", " ", " ", " ", " ", " "]
        ]
        |> ClosestPointsArea.from_grid()
        |> ClosestPointsArea.next_candidate_area()

      assert candidate_area_for_step_3 |> Enum.sort() ==
               [
                 [" ", " ", " ", "x", " ", " ", " "],
                 [" ", " ", "x", " ", "x", " ", " "],
                 [" ", "x", " ", " ", " ", "x", " "],
                 ["x", " ", " ", " ", " ", " ", "x"],
                 [" ", "x", " ", " ", " ", "x", " "],
                 [" ", " ", "x", " ", "x", " ", " "],
                 [" ", " ", " ", "x", " ", " ", " "]
               ]
               |> to_grow_stage()
    end

    test "- At stage 2 - Irregular Area - Only grow points from last stage" do
      candidate_area_for_step_3 =
        [
          [" ", " ", " ", " ", " ", " ", " "],
          [" ", " ", " ", "2", " ", " ", " "],
          [" ", " ", "2", "1", " ", " ", " "],
          [" ", "2", "1", "0", " ", " ", " "],
          [" ", " ", "2", "1", " ", " ", " "],
          [" ", " ", " ", "2", " ", " ", " "],
          [" ", " ", " ", " ", " ", " ", " "]
        ]
        |> ClosestPointsArea.from_grid()
        |> ClosestPointsArea.next_candidate_area()

      assert candidate_area_for_step_3 |> Enum.sort() ==
               [
                 [" ", " ", " ", "x", " ", " ", " "],
                 [" ", " ", "x", " ", "x", " ", " "],
                 [" ", "x", " ", " ", " ", " ", " "],
                 ["x", " ", " ", " ", " ", " ", " "],
                 [" ", "x", " ", " ", " ", " ", " "],
                 [" ", " ", "x", " ", "x", " ", " "],
                 [" ", " ", " ", "x", " ", " ", " "]
               ]
               |> to_grow_stage()
    end

    test "- Fully grown -> Return last grow stage" do
      fully_grown_area =
        [
          [" ", " ", " ", " ", " "],
          [" ", " ", "1", " ", " "],
          [" ", "1", "0", "1", " "],
          [" ", " ", "1", " ", " "],
          [" ", " ", " ", " ", " "]
        ]
        |> ClosestPointsArea.from_grid()
        |> Map.replace!(:fully_grown?, true)

      next_candidate_area = ClosestPointsArea.next_candidate_area(fully_grown_area)

      last_grow_stage =
        fully_grown_area
        |> Map.get(:grow_stages)
        |> List.last()

      assert next_candidate_area == last_grow_stage

      assert Enum.sort(next_candidate_area) ==
               [
                 [" ", " ", " ", " ", " "],
                 [" ", " ", "x", " ", " "],
                 [" ", "x", " ", "x", " "],
                 [" ", " ", "x", " ", " "],
                 [" ", " ", " ", " ", " "]
               ]
               |> to_grow_stage()
    end
  end

  describe "Commit next valid Grow Stage" do
    test "- Not fully grown - Different from last stage - Add to the list of Grow stages" do
      area = %ClosestPointsArea{
        fully_grown?: false,
        grow_stages: [
          [{2, 2}],
          [{2, 1}, {1, 2}, {3, 2}, {2, 3}]
        ]
      }

      new_valid_stage = [{2, 0}, {1, 1}, {3, 1}, {0, 2}, {4, 2}, {1, 3}, {3, 3}, {2, 4}]

      after_commit = ClosestPointsArea.commit_valid_grow_stage(area, new_valid_stage)

      assert after_commit == %ClosestPointsArea{
               fully_grown?: false,
               grow_stages: [
                 [{2, 2}],
                 [{2, 1}, {1, 2}, {3, 2}, {2, 3}],
                 new_valid_stage
               ]
             }
    end

    test "- Not fully grown - Stage equal to last stage - Unchanged & Set fully_grow? to true" do
      area = %ClosestPointsArea{
        fully_grown?: false,
        grow_stages: [
          [{2, 2}],
          [{2, 1}, {1, 2}, {3, 2}, {2, 3}]
        ]
      }

      new_valid_stage = List.last(area.grow_stages)
      after_commit = ClosestPointsArea.commit_valid_grow_stage(area, new_valid_stage)

      assert after_commit.fully_grown? == true
      assert after_commit.grow_stages == area.grow_stages
    end

    test "- Fully grown - Stage equal to last stage - Unchanged" do
      fully_grown_area = %ClosestPointsArea{
        fully_grown?: true,
        grow_stages: [
          [{2, 2}],
          [{2, 1}, {1, 2}, {3, 2}, {2, 3}]
        ]
      }

      new_valid_stage = List.last(fully_grown_area.grow_stages)
      after_commit = ClosestPointsArea.commit_valid_grow_stage(fully_grown_area, new_valid_stage)

      assert after_commit.fully_grown? == true
      assert after_commit.grow_stages == fully_grown_area.grow_stages
    end

    test "- Fully grown - Stage isn't equal to last stage - Raise error" do
      fully_grown_area = %ClosestPointsArea{
        fully_grown?: true,
        grow_stages: [
          [{2, 2}],
          [{2, 1}, {1, 2}, {3, 2}, {2, 3}]
        ]
      }

      new_valid_stage = [{2, 0}, {1, 1}, {3, 1}, {0, 2}, {4, 2}, {1, 3}, {3, 3}, {2, 4}]

      assert_raise InvalidArea, fn ->
        ClosestPointsArea.commit_valid_grow_stage(fully_grown_area, new_valid_stage)
      end
    end
  end
end
