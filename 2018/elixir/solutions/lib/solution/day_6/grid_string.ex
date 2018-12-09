defmodule Solution.Day6.GridString do
  @type x() :: integer()
  @type y() :: integer()
  @type point() :: {x(), y()}

  @type t :: %__MODULE__{
          grid: [[String.t()]]
        }
  defstruct [:grid]

  defmodule GridPoint do
    alias Solution.Day6.GridString

    @type t :: %__MODULE__{
            point: GridString.point(),
            value: String.t()
          }
    defstruct [
      :point,
      :value
    ]
  end

  defimpl Inspect, for: __MODULE__ do
    def inspect(grid_string, _opts) do
      to_string(grid_string)
    end
  end

  defimpl String.Chars, for: __MODULE__ do
    def to_string(%{grid: grid}) do
      grid
      |> Enum.map(fn line ->
        line
        |> Enum.join(" | ")
        |> String.trim()
      end)
      |> Enum.join("\n")
    end
  end

  @spec from_string(binary()) :: Solution.Day6.GridString.t()
  def from_string(grid_as_string) do
    %__MODULE__{
      grid:
        grid_as_string
        |> String.split("\n")
        |> Enum.reject(&(&1 == ""))
        |> Enum.map(fn line ->
          line
          |> String.split("|")
          |> Enum.reject(&(&1 == ""))
          |> Enum.map(&String.at(&1, 1))
        end)
    }
  end

  def from_grid_points(grid_points) do
    grid_width =
      grid_points
      |> Enum.map(fn %{point: {x, _}} -> x end)
      |> Enum.max()

    grid_height =
      grid_points
      |> Enum.map(fn %{point: {_, y}} -> y end)
      |> Enum.max()

    %__MODULE__{
      grid:
        for y <- 0..grid_height do
          for x <- 0..grid_width do
            find_value_at_coordinates(grid_points, x, y)
          end
        end
    }
  end

  @spec to_grid_points(__MODULE__.t()) :: [__MODULE__.GridPoint.t()]
  def to_grid_points(%__MODULE__{grid: grid}) do
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
