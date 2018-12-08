defmodule Solution.Day6.Helper do
  def to_grow_stage(grid) do
    for y <- 0..(length(grid) - 1) do
      for x <- 0..(length(get_line(grid, y)) - 1) do
        case get_point(grid, x, y) do
          " " -> nil
          "x" -> {x, y}
        end
      end
    end
    |> List.flatten()
    |> Enum.reject(&(&1 == nil))
    |> Enum.sort()
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
end
