defmodule Solution.Day6.Helper do
  alias Solution.Day6.GridString

  def to_list_of_points(grid_string) do
    grid_string
    |> GridString.to_grid_points()
    |> Enum.reject(fn %{value: val} -> val == " " end)
    |> Enum.map(fn %{point: pt} -> pt end)
    |> Enum.sort()
  end
end
