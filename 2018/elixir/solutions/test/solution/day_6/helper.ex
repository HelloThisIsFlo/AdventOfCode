defmodule Solution.Day6.Helper do
  alias Solution.Day6.GridString

  def to_grow_stage(grid_string) do
    grid_string
    |> GridString.from_string()
    |> GridString.to_grid_points()
    |> Enum.reject(fn %{value: val} -> val == " " end)
    |> Enum.map(fn %{point: pt} -> pt end)
    |> Enum.sort()
  end
end
