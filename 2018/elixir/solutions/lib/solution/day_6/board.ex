defmodule Solution.Day6.Board do
  alias Solution.Day6.ClosestPointsArea

  @spec validate_grow_stages([ClosestPointsArea.grow_stage()]) :: [ClosestPointsArea.grow_stage()]
  def validate_grow_stages(candidate_grow_stages_for_all_points) do
    contested_points =
      contested_points(MapSet.new(), MapSet.new(), candidate_grow_stages_for_all_points)

    candidate_grow_stages_for_all_points
    |> Enum.map(fn grow_stage -> grow_stage -- contested_points end)
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
