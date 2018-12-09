defmodule Solution.Day6.Board do
  alias Solution.Day6.ClosestPointsArea
  alias Solution.Day6.Grid

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

  def from_grid(board_grid) do
    areas =
      board_grid
      |> Grid.to_grid_points()
      |> Enum.reject(fn %{value: val} -> val == " " end)
      |> validate_grid_points()
      |> Enum.map(fn %{point: point} -> point end)
      |> Enum.map(&ClosestPointsArea.from_origin/1)

    %__MODULE__{areas: areas}
  end

  @spec to_grid(Solution.Day6.Board.t()) :: [any()]
  def to_grid(%__MODULE__{areas: areas}) do
    areas
    |> Enum.map(&ClosestPointsArea.to_grid_points/1)
    |> List.flatten()
    |> Grid.to_grid()
  end

  def grow(%__MODULE__{areas: areas} = board) do
    grown_areas =
      areas
      |> Enum.map(&ClosestPointsArea.next_grow_stage_candidate/1)
      |> Enum.zip(areas)
      |> validate_and_commit_grow_stages()

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

  @spec validate_and_commit_grow_stages([{ClosestPointsArea.grow_stage(), ClosestPointsArea.t()}]) ::
          [ClosestPointsArea.t()]
  defp validate_and_commit_grow_stages(candidate_grow_stages_with_associated_areas) do
    {candidate_grow_stages_for_all_points, areas} =
      Enum.unzip(candidate_grow_stages_with_associated_areas)

    all_claimed_points = Enum.flat_map(areas, &ClosestPointsArea.all_points/1)

    contested_points =
      contested_points(MapSet.new(), MapSet.new(), candidate_grow_stages_for_all_points)

    candidate_grow_stages_for_all_points
    |> Enum.map(fn grow_stage -> grow_stage -- contested_points end)
    |> Enum.map(fn grow_stage -> grow_stage -- all_claimed_points end)
    |> Enum.zip(areas)
    |> Enum.map(fn {valid_next_stage, area} ->
      ClosestPointsArea.commit_valid_grow_stage(area, valid_next_stage)
    end)
  end

  defp contested_points(contested_pts, claimed_or_contested_pts, candidate_grow_stages)

  defp contested_points(contested_points, _, []),
    do: Enum.to_list(contested_points)

  defp contested_points(contested_pts, claimed_or_contested_pts, [candidate | rest_of_candidates]) do
    new_contested_points =
      candidate
      |> MapSet.new()
      |> MapSet.intersection(claimed_or_contested_pts)
      |> MapSet.union(contested_pts)

    new_claimed_or_contested_pts =
      candidate
      |> MapSet.new()
      |> MapSet.union(claimed_or_contested_pts)

    contested_points(new_contested_points, new_claimed_or_contested_pts, rest_of_candidates)
  end
end
