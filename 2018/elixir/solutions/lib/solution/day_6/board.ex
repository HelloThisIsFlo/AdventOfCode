defmodule Solution.Day6.Board do
  alias Solution.Day6.ClosestPointsArea
  alias Solution.Day6.Grid
  alias Solution.Day6.Grid.GridPoint

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

  defp validate_grid_points(grid_points) do
    if Enum.any?(grid_points, fn %{value: val} -> val != "0" end) do
      raise InvalidBoard, "Board grid can only contain areas at stage 0 (origin only)"
    else
      grid_points
    end
  end

  @spec validate_grow_stages([ClosestPointsArea.grow_stage()]) :: [ClosestPointsArea.grow_stage()]
  def validate_grow_stages(candidate_grow_stages_for_all_points) do
    contested_points =
      contested_points(MapSet.new(), MapSet.new(), candidate_grow_stages_for_all_points)

    candidate_grow_stages_for_all_points
    |> Enum.map(fn grow_stage -> grow_stage -- contested_points end)
  end

  # ------- Private Functions -------------
  # ------- Private Functions -------------
  # ------- Private Functions -------------
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
