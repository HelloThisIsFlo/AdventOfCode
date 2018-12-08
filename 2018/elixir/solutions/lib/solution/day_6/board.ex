defmodule Solution.Day6.Board do
  alias Solution.Day6.ClosestPointsArea

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

  # TODO: Refactor all grid realted functions in separated module
  def from_grid(board_grid) do
    areas =
      for y <- 0..(length(board_grid) - 1) do
        for x <- 0..(length(get_line(board_grid, y)) - 1) do
          case get_point(board_grid, x, y) do
            " " -> nil
            "0" -> {x, y}
            _ -> raise InvalidBoard, "Board grid can only contain areas at stage 0 (origin only)"
          end
        end
      end
      |> List.flatten()
      |> Enum.reject(&(&1 == nil))
      |> Enum.map(&ClosestPointsArea.from_origin/1)

    %__MODULE__{areas: areas}
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
