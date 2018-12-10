defmodule Solution.Day6.ClosestPointsArea do
  alias Solution.Day6.Board
  alias Solution.Day6.GridString
  alias Solution.Day6.GridString.GridPoint

  @type grow_stage() :: [Board.point()]

  @type t :: %__MODULE__{
          fully_grown?: boolean(),
          grow_stages: [grow_stage()],
          equidistant_points: MapSet.t(Board.point())
        }
  defstruct fully_grown?: false,
            grow_stages: [],
            equidistant_points: MapSet.new()

  defmodule InvalidArea do
    defexception [:message]

    @impl true
    def exception(reason) do
      %InvalidArea{message: "Invalid Area! => " <> reason}
    end
  end

  @spec from_origin(Board.point()) :: __MODULE__.t()
  def from_origin(origin) do
    %__MODULE__{
      grow_stages: [[origin]]
    }
  end

  @spec from_grid_string(GridString.t()) :: __MODULE__.t()
  def from_grid_string(grid_string) do
    valid_grid_points =
      grid_string
      |> GridString.to_grid_points()
      |> Enum.reject(&(&1.value == " "))

    %__MODULE__{
      grow_stages:
        valid_grid_points
        |> Enum.map(&parse_value_to_stage_number/1)
        |> Enum.sort(fn %{stage: stage1}, %{stage: stage2} -> stage1 <= stage2 end)
        |> Enum.chunk_by(fn %{stage: stage} -> stage end)
        |> Enum.map(fn stage_points ->
          stage_points
          |> Enum.map(fn %{point: point} -> point end)
        end),
      equidistant_points:
        valid_grid_points
        |> Enum.filter(&is_equidistant_point/1)
        |> Enum.map(&Map.get(&1, :point))
        |> MapSet.new()
    }
  end

  def to_grid_string(area) do
    area
    |> to_grid_points()
    |> GridString.from_grid_points()
  end

  def to_grid_points(%__MODULE__{grow_stages: grow_stages, equidistant_points: equidistant_points}) do
    do_to_grid_points(0, grow_stages, equidistant_points, [])
  end

  def all_points(%__MODULE__{grow_stages: grow_stages}) do
    grow_stages
    |> List.flatten()
    |> MapSet.new()
  end

  @spec next_grow_stage_candidate(Solution.Day6.ClosestPointsArea.t()) :: any()
  def next_grow_stage_candidate(%__MODULE__{grow_stages: grow_stages, fully_grown?: true}),
    do: List.last(grow_stages)
  def next_grow_stage_candidate(%__MODULE__{grow_stages: grow_stages}),
    do: do_next_grow_stage_candidate(Enum.reverse(grow_stages))

  def commit_valid_grow_stage(area, grow_stage_to_commit, equidistant_points_to_commit \\ []) do
    validate_commit(area, grow_stage_to_commit, equidistant_points_to_commit)

    %{
      area
      | grow_stages: area.grow_stages ++ [grow_stage_to_commit],
        equidistant_points:
          equidistant_points_to_commit |> MapSet.new() |> MapSet.union(area.equidistant_points)
    }
  end

  def fully_grown?(%__MODULE__{grow_stages: stages, equidistant_points: equidistants}) do
    last_stage_contains_only_equidistants =
      Enum.all?(List.last(stages), &MapSet.member?(equidistants, &1))

    last_stage_contains_only_equidistants
  end

  def current_grow_stage(%__MODULE__{grow_stages: []}), do: 0
  def current_grow_stage(%__MODULE__{grow_stages: grow_stages}),
    do: length(grow_stages) - 1

  # ------- Private Functions -------------
  # ------- Private Functions -------------
  # ------- Private Functions -------------

  defp is_equidistant_point(%GridPoint{value: value_as_string}),
    do: String.contains?(value_as_string, ".")

  defp parse_value_to_stage_number(%GridPoint{point: point, value: value_as_string}) do
    with {stage_number, _} <- Integer.parse(value_as_string) do
      %{point: point, stage: stage_number}
    else
      :error -> raise InvalidArea, "Grid point couldn't be parsed to a number"
    end
  end

  defp do_next_grow_stage_candidate(grow_stages_in_reverse_order)
  defp do_next_grow_stage_candidate([]),
    do: raise(InvalidArea, "No grow stages")
  defp do_next_grow_stage_candidate([only_stage]) when length(only_stage) > 1,
    do: raise(InvalidArea, "First stage should only contain origin")
  defp do_next_grow_stage_candidate([[origin]]),
    do: grow_in_all_4_directions(origin)
  defp do_next_grow_stage_candidate([last_stage | [second_last_stage | _]]) do
    last_stage
    |> Enum.flat_map(&grow_in_all_4_directions/1)
    |> Enum.uniq()
    |> Kernel.--(second_last_stage)
  end

  defp grow_in_all_4_directions({x, y}) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
  end

  defp validate_commit(area, grow_stage_to_commit, equidistant_points_to_commit) do
    if not Enum.all?(equidistant_points_to_commit, &Enum.member?(grow_stage_to_commit, &1)) do
      raise InvalidArea,
            "Wrong Commit: All new equidistant points should be included in the new grow stage"
    end

    if grow_stage_to_commit != equidistant_points_to_commit and fully_grown?(area) do
      raise InvalidArea,
            "After area is considered fully grown it can only 'grow' with equidistant points"
    end
  end

  defp do_to_grid_points(current_stage, grow_stages, equidistant_points, grid_points)
  defp do_to_grid_points(_, [], _, grid_points), do: grid_points
  defp do_to_grid_points(
         current_stage_number,
         [current_stage | other_stages],
         equidistant_points,
         grid_points
       ) do
    grid_points_for_current_stage =
      current_stage
      |> Enum.map(fn point ->
        stage_as_string = Integer.to_string(current_stage_number)

        %GridPoint{
          point: point,
          value:
            if not MapSet.member?(equidistant_points, point) do
              stage_as_string
            else
              stage_as_string <> "."
            end
        }
      end)

    do_to_grid_points(
      current_stage_number + 1,
      other_stages,
      equidistant_points,
      grid_points ++ grid_points_for_current_stage
    )
  end
end
