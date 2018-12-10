defmodule Solution.Day6.ClosestPointsAreaTest do
  use ExUnit.Case
  alias Solution.Day6.GridString
  alias Solution.Day6.ClosestPointsArea
  alias Solution.Day6.ClosestPointsArea.InvalidArea
  import Solution.Day6.Helper, only: [to_list_of_points: 1]

  test "Build from Origin" do
    assert ClosestPointsArea.from_origin({3, 4}) == %ClosestPointsArea{
             fully_grown?: false,
             grow_stages: [
               [{3, 4}]
             ]
           }
  end

  describe "From Grid - " do
    test "Invalid Grid" do
      # "x" is not a number
      assert_raise InvalidArea, fn ->
        """
        |   |   |   |   |   |
        |   |   |   |   |   |
        |   |   | x |   |   |
        |   |   |   |   |   |
        |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()
      end
    end

    test "Origin only" do
      #
      # x-----> x
      # |
      # |
      # v y
      #
      area =
        """
        |   |   |   |   |   |
        |   |   |   |   |   |
        |   |   | 0 |   |   |
        |   |   |   |   |   |
        |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      assert area == %ClosestPointsArea{
               fully_grown?: false,
               grow_stages: [[{2, 2}]]
             }
    end

    test "Complete Area" do
      #   0 1 2
      # 0 x-----> x
      # 1 |
      # 2 |
      #   v y
      #
      area =
        """
        |   |   | 2 |   |   |
        |   | 2 | 1 | 2 |   |
        | 2 | 1 | 0 | 1 | 2 |
        |   | 2 | 1 | 2 |   |
        |   |   | 2 |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      assert area == %ClosestPointsArea{
               fully_grown?: false,
               grow_stages: [
                 [{2, 2}],
                 [{2, 1}, {1, 2}, {3, 2}, {2, 3}],
                 [{2, 0}, {1, 1}, {3, 1}, {0, 2}, {4, 2}, {1, 3}, {3, 3}, {2, 4}]
               ]
             }
    end

    test "With Equidistant points" do
      #   0 1 2
      # 0 x-----> x
      # 1 |
      # 2 |
      #   v y
      #
      area =
        """
        |   |   | 2. |    |    |
        |   | 2 | 1  | 2. |    |
        | 2 | 1 | 0  | 1. | 2. |
        |   | 2 | 1  | 2  |    |
        |   |   | 2  |    |    |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      assert area == %ClosestPointsArea{
               fully_grown?: false,
               grow_stages: [
                 [{2, 2}],
                 [{2, 1}, {1, 2}, {3, 2}, {2, 3}],
                 [{2, 0}, {1, 1}, {3, 1}, {0, 2}, {4, 2}, {1, 3}, {3, 3}, {2, 4}]
               ],
               equidistant_points: MapSet.new([{3, 2}, {2, 0}, {3, 1}, {4, 2}])
             }
    end

    test "Smaller Area" do
      #   0 1 2
      # 0 x-----> x
      # 1 |
      # 2 |
      #   v y
      #
      area =
        """
        |   | 1 |   |
        | 1 | 0 | 1 |
        |   | 1 |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      assert area == %ClosestPointsArea{
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
      area =
        """
        |   | 1 | 2 |
        |   | 0 | 1 |
        |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      assert area == %ClosestPointsArea{
               fully_grown?: false,
               grow_stages: [
                 [{1, 1}],
                 [{1, 0}, {2, 1}],
                 [{2, 0}]
               ]
             }
    end
  end

  describe "To Grid" do
    test "Valid area" do
      valid_area =
        """
        |   |   | 2 |   |   |
        |   | 2 | 1 | 2 |   |
        | 2 | 1 | 0 | 1 | 2 |
        |   | 2 | 1 | 2 |   |
        |   |   | 2 |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      assert ClosestPointsArea.to_grid_string(valid_area) ==
               """
               |   |   | 2 |   |   |
               |   | 2 | 1 | 2 |   |
               | 2 | 1 | 0 | 1 | 2 |
               |   | 2 | 1 | 2 |   |
               |   |   | 2 |   |   |
               """
               |> GridString.from_string()
    end

    test "Valid area - With Equidistant" do
      valid_area =
        """
        |   |   | 2. |    |    |
        |   | 2 | 1  | 2. |    |
        | 2 | 1 | 0  | 1. | 2. |
        |   | 2 | 1  | 2  |    |
        |   |   | 2  |    |    |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      assert ClosestPointsArea.to_grid_string(valid_area) ==
               """
               |   |   | 2. |    |    |
               |   | 2 | 1  | 2. |    |
               | 2 | 1 | 0  | 1. | 2. |
               |   | 2 | 1  | 2  |    |
               |   |   | 2  |    |    |
               """
               |> GridString.from_string()
    end
  end

  describe "Current Grow stage" do
    test "Empty Area" do
      assert 0 ==
               """
               |   |   |   |   |   |
               |   |   |   |   |   |
               |   |   | 0 |   |   |
               |   |   |   |   |   |
               |   |   |   |   |   |
               """
               |> GridString.from_string()
               |> ClosestPointsArea.from_grid_string()
               |> ClosestPointsArea.current_grow_stage()
    end

    test "Complete Area" do
      assert 2 ==
               """
               |   |   | 2 |   |   |
               |   | 2 | 1 | 2 |   |
               | 2 | 1 | 0 | 1 | 2 |
               |   | 2 | 1 | 2 |   |
               |   |   | 2 |   |   |
               """
               |> GridString.from_string()
               |> ClosestPointsArea.from_grid_string()
               |> ClosestPointsArea.current_grow_stage()
    end
  end

  describe "Get All points" do
    test "Complete Area" do
      all_points =
        """
        |   |   | 2 |   |   |
        |   | 2 | 1 | 2 |   |
        | 2 | 1 | 0 | 1 | 2 |
        |   | 2 | 1 | 2 |   |
        |   |   | 2 |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()
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

  describe "Generate next candidate grow stage" do
    test "- Invalid Area - Emtpy" do
      invalid_area =
        """
        |   |   |   |
        |   |   |   |
        |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      assert_raise InvalidArea, fn ->
        ClosestPointsArea.next_grow_stage_candidate(invalid_area)
      end
    end

    test "- At stage 0 - Only origin" do
      candidate_area_for_step_1 =
        """
        |   |   |   |   |   |
        |   |   |   |   |   |
        |   |   | 0 |   |   |
        |   |   |   |   |   |
        |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()
        |> ClosestPointsArea.next_grow_stage_candidate()

      assert candidate_area_for_step_1 |> Enum.sort() ==
               """
               |   |   |   |   |   |
               |   |   | x |   |   |
               |   | x |   | x |   |
               |   |   | x |   |   |
               |   |   |   |   |   |
               """
               |> GridString.from_string()
               |> to_list_of_points()
    end

    test "- At stage 0 - Invalid Stage 0" do
      invalid_area =
        """
        |   |   | 0 |
        |   | 0 | 0 |
        |   |   | 0 |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      assert_raise InvalidArea, fn ->
        ClosestPointsArea.next_grow_stage_candidate(invalid_area)
      end
    end

    test "- At stage 1" do
      candidate_area_for_step_2 =
        """
        |   |   |   |   |   |
        |   |   | 1 |   |   |
        |   | 1 | 0 | 1 |   |
        |   |   | 1 |   |   |
        |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()
        |> ClosestPointsArea.next_grow_stage_candidate()

      assert candidate_area_for_step_2 |> Enum.sort() ==
               """
               |   |   | x |   |   |
               |   | x |   | x |   |
               | x |   |   |   | x |
               |   | x |   | x |   |
               |   |   | x |   |   |
               """
               |> GridString.from_string()
               |> to_list_of_points()
    end

    test "- At stage 2 - Regular Area" do
      candidate_area_for_step_3 =
        """
        |   |   |   |   |   |   |   |
        |   |   |   | 2 |   |   |   |
        |   |   | 2 | 1 | 2 |   |   |
        |   | 2 | 1 | 0 | 1 | 2 |   |
        |   |   | 2 | 1 | 2 |   |   |
        |   |   |   | 2 |   |   |   |
        |   |   |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()
        |> ClosestPointsArea.next_grow_stage_candidate()

      assert candidate_area_for_step_3 |> Enum.sort() ==
               """
               |   |   |   | x |   |   |   |
               |   |   | x |   | x |   |   |
               |   | x |   |   |   | x |   |
               | x |   |   |   |   |   | x |
               |   | x |   |   |   | x |   |
               |   |   | x |   | x |   |   |
               |   |   |   | x |   |   |   |
               """
               |> GridString.from_string()
               |> to_list_of_points()
    end

    test "- At stage 2 - Irregular Area - Only grow points from last stage" do
      candidate_area_for_step_3 =
        """
        |   |   |   |   |   |   |   |
        |   |   |   | 2 |   |   |   |
        |   |   | 2 | 1 |   |   |   |
        |   | 2 | 1 | 0 |   |   |   |
        |   |   | 2 | 1 |   |   |   |
        |   |   |   | 2 |   |   |   |
        |   |   |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()
        |> ClosestPointsArea.next_grow_stage_candidate()

      assert candidate_area_for_step_3 |> Enum.sort() ==
               """
               |   |   |   | x |   |   |   |
               |   |   | x |   | x |   |   |
               |   | x |   |   |   |   |   |
               | x |   |   |   |   |   |   |
               |   | x |   |   |   |   |   |
               |   |   | x |   | x |   |   |
               |   |   |   | x |   |   |   |
               """
               |> GridString.from_string()
               |> to_list_of_points()
    end

    test "- Fully grown -> Return last grow stage" do
      fully_grown_area =
        """
        |   |   |   |   |   |
        |   |   | 1 |   |   |
        |   | 1 | 0 | 1 |   |
        |   |   | 1 |   |   |
        |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()
        |> Map.replace!(:fully_grown?, true)

      next_grow_stage_candidate = ClosestPointsArea.next_grow_stage_candidate(fully_grown_area)

      last_grow_stage =
        fully_grown_area
        |> Map.get(:grow_stages)
        |> List.last()

      assert next_grow_stage_candidate == last_grow_stage

      assert Enum.sort(next_grow_stage_candidate) ==
               """
               |   |   |   |   |  |
               |   |   | x |   |  |
               |   | x |   | x |  |
               |   |   | x |   |  |
               |   |   |   |   |  |
               """
               |> GridString.from_string()
               |> to_list_of_points()
    end
  end

  describe "Commit next valid Grow Stage" do
    test "- Equidistant points not contained in closest -> Raise Error" do
      area =
        """
        |   |   |   |   |   |
        |   |   |   |   |   |
        |   |   | 0 |   |   |
        |   |   |   |   |   |
        |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      closest_to_commit =
        """
        |   |   |   |   |   |
        |   |   | x |   |   |
        |   | x |   | x |   |
        |   |   | x |   |   |
        |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> to_list_of_points()

      equidistant_points_to_commit =
        """
        |   |   |   |   | x |
        |   |   |   |   |   |
        |   |   |   |   |   |
        |   |   |   |   |   |
        |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> to_list_of_points()

      assert_raise InvalidArea, fn ->
        ClosestPointsArea.commit_valid_grow_stage(
          area,
          closest_to_commit,
          equidistant_points_to_commit
        )
      end
    end

    test "- Fully grown - New closest points - Only some equidistant -> Raise Error" do
      fully_grown_area =
        """
        |   |   |   |   |   |
        |   |   | 1 |   |   |
        |   | 1 | 0 | 1 |   |
        |   |   | 1 |   |   |
        |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()
        |> Map.replace!(:fully_grown?, true)

      closest_to_commit =
        """
        |   |   | x |   |   |
        |   | x |   | x |   |
        | x |   |   |   | x |
        |   | x |   | x |   |
        |   |   | x |   |   |
        """
        |> GridString.from_string()
        |> to_list_of_points()

      equidistant_points_to_commit =
        """
        |   |   |   |   |   |
        |   | x |   |   |   |
        | x |   |   |   | x |
        |   | x |   | x |   |
        |   |   | x |   |   |
        """
        |> GridString.from_string()
        |> to_list_of_points()

      assert_raise InvalidArea, fn ->
        ClosestPointsArea.commit_valid_grow_stage(
          fully_grown_area,
          closest_to_commit,
          equidistant_points_to_commit
        )
      end
    end

    test "- Fully grown - New closest points - All equidistant -> Update" do
      fully_grown_area =
        """
        |   |   |   |   |   |
        |   |   | 1 |   |   |
        |   | 1 | 0 | 1 |   |
        |   |   | 1 |   |   |
        |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()
        |> Map.replace!(:fully_grown?, true)

      closest_to_commit =
        """
        |   |   | x |   |   |
        |   | x |   | x |   |
        | x |   |   |   | x |
        |   | x |   | x |   |
        |   |   | x |   |   |
        """
        |> GridString.from_string()
        |> to_list_of_points()

      equidistant_points_to_commit =
        """
        |   |   | x |   |   |
        |   | x |   | x |   |
        | x |   |   |   | x |
        |   | x |   | x |   |
        |   |   | x |   |   |
        """
        |> GridString.from_string()
        |> to_list_of_points()

      after_commit =
        ClosestPointsArea.commit_valid_grow_stage(
          fully_grown_area,
          closest_to_commit,
          equidistant_points_to_commit
        )

      assert after_commit.fully_grown? == true

      assert after_commit
             |> ClosestPointsArea.to_grid_string() ==
               """
               |    |    | 2. |    |    |
               |    | 2. | 1  | 2. |    |
               | 2. | 1  | 0  | 1  | 2. |
               |    | 2. | 1  | 2. |    |
               |    |    | 2. |    |    |
               """
               |> GridString.from_string()
    end

    test "- Not fully grown - New closest points - None equidistant -> Update" do
      area =
        """
        |   |   |   |   |   |
        |   |   | 1 |   |   |
        |   | 1 | 0 | 1 |   |
        |   |   | 1 |   |   |
        |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      closest_to_commit =
        """
        |   |   | x |   |   |
        |   | x |   | x |   |
        | x |   |   |   | x |
        |   | x |   | x |   |
        |   |   | x |   |   |
        """
        |> GridString.from_string()
        |> to_list_of_points()

      equidistant_points_to_commit =
        """
        |   |   |   |   |   |
        |   |   |   |   |   |
        |   |   |   |   |   |
        |   |   |   |   |   |
        |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> to_list_of_points()

      after_commit =
        ClosestPointsArea.commit_valid_grow_stage(
          area,
          closest_to_commit,
          equidistant_points_to_commit
        )

      assert after_commit.fully_grown? == false

      assert after_commit
             |> ClosestPointsArea.to_grid_string() ==
               """
               |    |    | 2  |    |    |
               |    | 2  | 1  | 2  |    |
               | 2  | 1  | 0  | 1  | 2  |
               |    | 2  | 1  | 2  |    |
               |    |    | 2  |    |    |
               """
               |> GridString.from_string()
    end

    test "- Not fully grown - New closest points - Some equidistant -> Update" do
      area =
        """
        |   |   |   |   |   |
        |   |   | 1 |   |   |
        |   | 1 | 0 | 1 |   |
        |   |   | 1 |   |   |
        |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      closest_to_commit =
        """
        |   |   | x |   |   |
        |   | x |   | x |   |
        | x |   |   |   | x |
        |   | x |   | x |   |
        |   |   | x |   |   |
        """
        |> GridString.from_string()
        |> to_list_of_points()

      equidistant_points_to_commit =
        """
        |   |   | x |   |   |
        |   | x |   |   |   |
        | x |   |   |   |   |
        |   | x |   |   |   |
        |   |   | x |   |   |
        """
        |> GridString.from_string()
        |> to_list_of_points()

      after_commit =
        ClosestPointsArea.commit_valid_grow_stage(
          area,
          closest_to_commit,
          equidistant_points_to_commit
        )

      assert after_commit.fully_grown? == false

      assert after_commit
             |> ClosestPointsArea.to_grid_string() ==
               """
               |    |    | 2. |   |   |
               |    | 2. | 1  | 2 |   |
               | 2. | 1  | 0  | 1 | 2 |
               |    | 2. | 1  | 2 |   |
               |    |    | 2. |   |   |
               """
               |> GridString.from_string()
    end

    test "- Not fully grown - New closest points - All equidistant -> Update & Set to Fully Grown" do
      not_fully_grown_area =
        """
        |   |   |   |   |   |
        |   |   | 1 |   |   |
        |   | 1 | 0 | 1 |   |
        |   |   | 1 |   |   |
        |   |   |   |   |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      closest_to_commit =
        """
        |   |   | x |   |   |
        |   | x |   | x |   |
        | x |   |   |   | x |
        |   | x |   | x |   |
        |   |   | x |   |   |
        """
        |> GridString.from_string()
        |> to_list_of_points()

      equidistant_points_to_commit =
        """
        |   |   | x |   |   |
        |   | x |   | x |   |
        | x |   |   |   | x |
        |   | x |   | x |   |
        |   |   | x |   |   |
        """
        |> GridString.from_string()
        |> to_list_of_points()

      after_commit =
        ClosestPointsArea.commit_valid_grow_stage(
          not_fully_grown_area,
          closest_to_commit,
          equidistant_points_to_commit
        )

      assert not_fully_grown_area.fully_grown? == false
      assert after_commit.fully_grown? == true

      assert after_commit
             |> ClosestPointsArea.to_grid_string() ==
               """
               |    |    | 2. |    |    |
               |    | 2. | 1  | 2. |    |
               | 2. | 1  | 0  | 1  | 2. |
               |    | 2. | 1  | 2. |    |
               |    |    | 2. |    |    |
               """
               |> GridString.from_string()
    end

    test "- Not fully grown - No new closest points - No equidistant -> Set to Fully Grown" do
      not_fully_grown_area =
        """
        |   | 1 |   |
        | 1 | 0 | 1 |
        |   | 1 |   |
        """
        |> GridString.from_string()
        |> ClosestPointsArea.from_grid_string()

      closest_to_commit =
        """
        |   |   |   |
        |   |   |   |
        |   |   |   |
        """
        |> GridString.from_string()
        |> to_list_of_points()

      equidistant_points_to_commit =
        """
        |   |   |   |
        |   |   |   |
        |   |   |   |
        """
        |> GridString.from_string()
        |> to_list_of_points()

      after_commit =
        ClosestPointsArea.commit_valid_grow_stage(
          not_fully_grown_area,
          closest_to_commit,
          equidistant_points_to_commit
        )

      assert not_fully_grown_area.fully_grown? == false
      assert after_commit.fully_grown? == true

      assert after_commit
             |> ClosestPointsArea.to_grid_string() ==
               """
               |   | 1 |   |
               | 1 | 0 | 1 |
               |   | 1 |   |
               """
               |> GridString.from_string()
    end
  end
end
