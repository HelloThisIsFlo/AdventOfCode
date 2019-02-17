defmodule Solution.Day6.GridString do
  alias Solution.Day6.Board

  @type t :: %__MODULE__{
          grid: [[String.t()]]
        }
  defstruct [:grid]

  defmodule GridPoint do
    @type t :: %__MODULE__{
            point: Board.point(),
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
    alias Solution.Day6.GridString

    def to_string(%{grid: grid}) do
      for y <- 0..(length(grid) - 1) do
        for x <- 0..(length(GridString.get_line(grid, y)) - 1) do
          grid
          |> GridString.get_point(x, y)
          |> add_padding(column_cell_max_width(grid, x))
        end
      end
      |> Enum.map(&format_line/1)
      |> Enum.join("\n")
      |> prepend_newline()
    end

    defp add_padding(cell_as_string, column_cell_max_width),
      do: append_spaces(cell_as_string, column_cell_max_width - String.length(cell_as_string))

    defp append_spaces(text, 0), do: text
    defp append_spaces(text, n) do
      spaces =
        1..n
        |> Enum.map(fn _ -> " " end)
        |> Enum.join()

      text <> spaces
    end

    defp column_cell_max_width(grid, column_number) do
      grid
      |> Enum.map(&Enum.at(&1, column_number))
      |> Enum.map(&String.length/1)
      |> Enum.max()
    end

    defp format_line(line_cells) when is_list(line_cells) do
      "| " <> Enum.join(line_cells, " | ") <> " |"
    end

    defp prepend_newline(string), do: "\n" <> string
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
          |> Enum.map(&to_value/1)
        end)
    }
  end

  def from_grid_points(grid_points, options \\ []) do
    grid_width =
      Keyword.get(
        options,
        :width,
        grid_points
        |> Enum.map(fn %{point: {x, _}} -> x end)
        |> Enum.max()
        |> Kernel.+(1)
      )

    grid_height =
      Keyword.get(
        options,
        :height,
        grid_points
        |> Enum.map(fn %{point: {_, y}} -> y end)
        |> Enum.max()
        |> Kernel.+(1)
      )

    %__MODULE__{
      grid:
        for y <- 0..(grid_height - 1) do
          for x <- 0..(grid_width - 1) do
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
  defp to_value(cell_content_as_string) do
    case String.trim(cell_content_as_string) do
      "" -> " "
      val -> val
    end
  end

  def get_line(grid, y) do
    grid
    |> Enum.at(y)
  end

  def get_point(grid, x, y) do
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
    |> Map.get(:value)
  end
end
