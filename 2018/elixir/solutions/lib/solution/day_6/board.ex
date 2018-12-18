defmodule Solution.Day6.Board do
  alias Solution.Day6.ClosestPointsArea
  alias Solution.Day6.GridString

  @type x() :: integer()
  @type y() :: integer()
  @type point() :: {x(), y()}

  @type t :: %__MODULE__{
          areas: [ClosestPointsArea.t()]
        }
  defstruct areas: []

  defmodule InvalidBoard do
    defexception [:message]

    @impl true
    def exception(reason) do
      %InvalidBoard{message: "Invalid Board! => " <> reason}
    end
  end

  @spec from_grid_string(Solution.Day6.GridString.t()) :: Solution.Day6.Board.t()
  def from_grid_string(board_grid_string) do
    areas =
      board_grid_string
      |> GridString.to_grid_points()
      |> Enum.reject(fn %{value: val} -> val == " " end)
      |> validate_grid_points()
      |> Enum.map(fn %{point: point} -> point end)
      |> Enum.map(&ClosestPointsArea.from_origin/1)

    %__MODULE__{areas: areas}
  end

  def from_origin_points(origin_points) do
    %__MODULE__{areas: Enum.map(origin_points, &ClosestPointsArea.from_origin/1)}
  end

  @spec to_grid_string(Solution.Day6.Board.t()) :: GridString.t()
  def to_grid_string(%__MODULE__{areas: areas}) do
    areas
    |> Enum.map(&ClosestPointsArea.to_grid_points/1)
    |> List.flatten()
    |> GridString.from_grid_points()
  end

  def grow(%__MODULE__{areas: areas} = board) do
    grown_areas =
      areas
      |> generate_grow_stage_candidates()
      |> validate_grow_stage_candidates_and_calculate_equidistants(areas)
      |> commit_valid_grow_stages_and_equidistants(areas)

    %{board | areas: grown_areas}
  end

  # ------- Private Functions -------------
  # ------- Private Functions -------------
  # ------- Private Functions -------------
  defp validate_grid_points(grid_points) do
    if Enum.any?(grid_points, fn %{value: val} -> val != "0" end) do
      raise InvalidBoard, "Board grid can only contain areas at stage 0 (origin only)"
    else
      grid_points
    end
  end

  defp generate_grow_stage_candidates(areas) do
    areas
    |> Enum.map(&ClosestPointsArea.next_grow_stage_candidate/1)
  end

  defp validate_grow_stage_candidates_and_calculate_equidistants(all_candidate_grow_stages, areas) do
    points_already_claimed =
      areas
      |> Enum.flat_map(&ClosestPointsArea.all_points/1)
      |> to_set()

    all_candidate_grow_stages
    |> Enum.map(fn current_grow_stage ->
      points_of_all_other_candidate_grow_stages =
        all_candidate_grow_stages
        |> List.delete(current_grow_stage)
        |> List.flatten()
        |> to_set()

      validated_stage =
        current_grow_stage
        |> to_set()
        |> MapSet.difference(points_already_claimed)

      equidistants =
        validated_stage
        |> MapSet.intersection(points_of_all_other_candidate_grow_stages)

      %{
        validated_stage: MapSet.to_list(validated_stage),
        equidistants: MapSet.to_list(equidistants)
      }
    end)
  end

  defp to_set(list), do: MapSet.new(list)

  defp commit_valid_grow_stages_and_equidistants(all_candidate_grow_stages, areas) do
    all_candidate_grow_stages
    |> Enum.zip(areas)
    |> Enum.map(fn {%{validated_stage: validated_stage, equidistants: equidistants}, area} ->
      ClosestPointsArea.commit_valid_grow_stage(area, validated_stage, equidistants)
    end)
  end
end
