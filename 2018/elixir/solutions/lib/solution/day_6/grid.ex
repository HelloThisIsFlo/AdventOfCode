defmodule Solution.Day6.Grid do
  @type x() :: integer()
  @type y() :: integer()
  @type point() :: {x(), y()}

  defmodule GridPoint do
    alias Solution.Day6.Grid

    @type t :: %__MODULE__{
            point: Grid.point(),
            value: String.t()
          }
    defstruct [
      :point,
      :value
    ]
  end

  def to_grid_points(grid) do
    for y <- 0..(length(grid) - 1) do
      for x <- 0..(length(get_line(grid, y)) - 1) do
        %GridPoint{
          point: {x, y},
          value: get_point(grid, x, y)
        }
      end
    end
    |> List.flatten()
  end

  def to_grid(grid_points) do
    grid_width =
      grid_points
      |> Enum.map(fn %{point: {x, _}} -> x end)
      |> Enum.max()

    grid_height =
      grid_points
      |> Enum.map(fn %{point: {_, y}} -> y end)
      |> Enum.max()

    for y <- 0..grid_height do
      for x <- 0..grid_width do
        find_value_at_coordinates(grid_points, x, y)
      end
    end
  end

  # ------- Private Functions -------------
  # ------- Private Functions -------------
  # ------- Private Functions -------------
  defp get_line(grid, y) do
    grid
    |> Enum.at(y)
  end

  defp get_point(grid, x, y) do
    grid
    |> get_line(y)
    |> Enum.at(x)
  end

  defp find_value_at_coordinates(grid_points, x, y) do
    placeholder_if_not_found = " "

    grid_points
    |> Enum.find(
      %GridPoint{value: placeholder_if_not_found},
      fn %{point: {x_pt, y_pt}} ->
        x_pt == x and y_pt == y
      end
    )
    |> Map.get(:value, " ")
  end
end
