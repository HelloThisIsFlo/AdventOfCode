defmodule Solution.Day6.ClosestPointsArea do
  alias Solution.Day6.Grid
  alias Solution.Day6.Grid.GridPoint

  @type grow_stage() :: [Grid.point()]

  @type t :: %__MODULE__{
          fully_grown?: boolean(),
          grow_stages: [grow_stage()]
        }
  defstruct fully_grown?: false,
            grow_stages: []

  defmodule InvalidArea do
    defexception [:message]

    @impl true
    def exception(reason) do
      %InvalidArea{message: "Invalid Area! => " <> reason}
    end
  end

  @spec from_origin([Grid.point()]) :: __MODULE__.t()
  def from_origin(origin) do
    %__MODULE__{
      grow_stages: [[origin]]
    }
  end

  @spec from_grid([[String.t()]]) :: __MODULE__.t()
  def from_grid(grid) do
    %__MODULE__{
      grow_stages: to_grow_stages(grid)
    }
  end

  def to_grid(%__MODULE__{grow_stages: grow_stages}) do
    grow_stages
    |> to_grid_points()
    |> Grid.to_grid()
  end

  defp to_grid_points(grow_stages) do
    do_to_grid_points(0, grow_stages, [])
  end

  defp do_to_grid_points(current_stage, grow_stages, grid_points)
  defp do_to_grid_points(_, [], grid_points), do: grid_points

  defp do_to_grid_points(current_stage_number, [current_stage | other_stages], grid_points) do
    grid_points_for_current_stage =
      current_stage
      |> Enum.map(fn point ->
        %GridPoint{
          point: point,
          value: Integer.to_string(current_stage_number)
        }
      end)

    do_to_grid_points(
      current_stage_number + 1,
      other_stages,
      grid_points ++ grid_points_for_current_stage
    )
  end

  def all_points(%__MODULE__{grow_stages: grow_stages}) do
    grow_stages
    |> List.flatten()
    |> MapSet.new()
  end

  def next_candidate_area(%__MODULE__{grow_stages: grow_stages, fully_grown?: true}),
    do: List.last(grow_stages)
  def next_candidate_area(%__MODULE__{grow_stages: grow_stages}),
    do: do_next_candidate_area(Enum.reverse(grow_stages))

  def commit_valid_grow_stage(area, valid_grow_stage_to_commit) do
    do_commit_valid_grow_stage(
      area,
      area.fully_grown?,
      List.last(area.grow_stages),
      valid_grow_stage_to_commit
    )
  end

  def current_grow_stage(%__MODULE__{grow_stages: []}), do: 0
  def current_grow_stage(%__MODULE__{grow_stages: grow_stages}),
    do: length(grow_stages) - 1

  # ------- Private Functions -------------
  # ------- Private Functions -------------
  # ------- Private Functions -------------

  defp to_grow_stages(grid) do
    grid
    |> Grid.to_grid_points()
    |> Enum.reject(&(&1.value == " "))
    |> Enum.map(&parse_value_to_stage_number/1)
    |> Enum.sort(fn %{stage: stage1}, %{stage: stage2} -> stage1 <= stage2 end)
    |> Enum.chunk_by(fn %{stage: stage} -> stage end)
    |> Enum.map(fn stage_points ->
      stage_points
      |> Enum.map(fn %{point: point} -> point end)
    end)
  end

  defp parse_value_to_stage_number(%GridPoint{point: point, value: value_as_string}) do
    with {stage_number, _} <- Integer.parse(value_as_string) do
      %{point: point, stage: stage_number}
    else
      :error -> raise InvalidArea, "Grid point couldn't be parsed to a number"
    end
  end

  defp do_next_candidate_area(grow_stages_in_reverse_order)
  defp do_next_candidate_area([]),
    do: raise(InvalidArea, "No grow stages")
  defp do_next_candidate_area([only_stage]) when length(only_stage) > 1,
    do: raise(InvalidArea, "First stage should only contain origin")
  defp do_next_candidate_area([[origin]]),
    do: grow_in_all_4_directions(origin)
  defp do_next_candidate_area([last_stage | [second_last_stage | _]]) do
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

  defp do_commit_valid_grow_stage(area, fully_grown?, last_grow_stage, valid_grow_stage_to_commit)
  defp do_commit_valid_grow_stage(_area, true, last_grow_stage, valid_grow_stage_to_commit)
       when last_grow_stage != valid_grow_stage_to_commit,
       do:
         raise(
           InvalidArea,
           "Invalid Grow Stage! Area is fully grown, yet it is attempted to add a new grow stage not equal to the last one!"
         )
  defp do_commit_valid_grow_stage(area, true, _last_grow_stage, _valid_grow_stage_to_commit),
    do: area
  defp do_commit_valid_grow_stage(area, false, last_grow_stage, valid_grow_stage_to_commit)
       when last_grow_stage != valid_grow_stage_to_commit,
       do: %{area | grow_stages: area.grow_stages ++ [valid_grow_stage_to_commit]}
  defp do_commit_valid_grow_stage(area, false, _last_grow_stage, _valid_grow_stage_to_commit),
    do: %{area | fully_grown?: true}
end
