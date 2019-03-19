defmodule Solution.Day6.GridString do
  alias Solution.Day6.Board
  import Solution.Utils

  @defaults default_value: " ",
            start: "|",
            separator: "|",
            end: "|",
            padding: " "

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
      p = GridString.get_config(:padding)
      s = GridString.get_config(:separator)
      st = GridString.get_config(:start)
      e = GridString.get_config(:end)
      st <> p <> Enum.join(line_cells, p <> s <> p) <> p <> e
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
      grid: grid(grid_points, grid_width, grid_height)
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

  def configure(opts \\ []) do
    ensure_config_agent_started()

    valid_options = Keyword.keys(@defaults)

    Enum.each(opts, fn {key, val} ->
      if not Enum.member?(valid_options, key) do
        raise "Invalid option: #{key}"
      end

      update_config(key, val)
    end)
  end

  defp update_config(key, val) do
    Agent.update(__MODULE__, &Keyword.put(&1, key, val))
  end

  def get_config(key) do
    ensure_config_agent_started()
    Agent.get(__MODULE__, &Keyword.get(&1, key))
  end

  # ------- Private Functions -------------
  # ------- Private Functions -------------
  # ------- Private Functions -------------
  defp ensure_config_agent_started() do
    if GenServer.whereis(__MODULE__) == nil do
      Agent.start_link(fn -> @defaults end, name: __MODULE__, timeout: 1000)
      # Ensure agent started
      :ok = Agent.get(__MODULE__, fn _ -> :ok end)
    end
  end

  defp grid(grid_points, grid_width, grid_height) do
    grid_points
    |> eliminate_duplicate_points()
    |> eliminate_points_out_of_grid(grid_height, grid_width)
    |> group_by_y_coordinates()
    |> add_missing_rows(grid_height)
    |> fill_rows_with_missing_points(grid_width)
    |> sort_by_x_coordinates()
    |> flatten_to_grid()
    |> map_to_value()
  end

  defp eliminate_duplicate_points(grid_points) do
    grid_points
    |> Enum.uniq_by(&Map.get(&1, :point))
  end

  defp eliminate_points_out_of_grid(grid_points, grid_height, grid_width) do
    grid_points
    |> Enum.reject(fn grid_pt -> get_coordinate(grid_pt, :x) >= grid_width end)
    |> Enum.reject(fn grid_pt -> get_coordinate(grid_pt, :x) < 0 end)
    |> Enum.reject(fn grid_pt -> get_coordinate(grid_pt, :y) >= grid_height end)
    |> Enum.reject(fn grid_pt -> get_coordinate(grid_pt, :y) < 0 end)
  end

  defp group_by_y_coordinates(grid_points) do
    Enum.group_by(grid_points, &get_coordinate(&1, :y))
  end

  defp add_missing_rows(grid_points_grouped_by_rows, grid_height) do
    existing_rows = grid_points_grouped_by_rows |> Map.keys()
    missing_rows = Enum.to_list(0..(grid_height - 1)) -- existing_rows

    missing_rows
    |> Map.new(fn row_number ->
      {row_number, []}
    end)
    |> Enum.into(grid_points_grouped_by_rows)
  end

  defp fill_rows_with_missing_points(grid_points_grouped_by_rows, grid_width) do
    grid_points_grouped_by_rows
    |> Enum.map(&fill_row(&1, grid_width))
    |> Map.new()
  end

  defp fill_row({row_y_coordinate, row}, grid_width) do
    existing_x_coordinates_in_row = Enum.map(row, &get_coordinate(&1, :x))

    default_value = get_config(:default_value)

    missing_x_coordinates_in_row =
      Enum.to_list(0..(grid_width - 1)) -- existing_x_coordinates_in_row

    row_filled_with_missing_points =
      missing_x_coordinates_in_row
      |> Enum.map(fn x ->
        %GridPoint{point: {x, row_y_coordinate}, value: default_value}
      end)
      |> Kernel.++(row)

    {row_y_coordinate, row_filled_with_missing_points}
  end

  defp sort_by_x_coordinates(grid_points_grouped_by_rows) do
    grid_points_grouped_by_rows
    |> Enum.map(fn {row_y_coordinate, row} ->
      sorted_row =
        row
        |> Enum.sort(fn %GridPoint{point: {x1, _}}, %GridPoint{point: {x2, _}} ->
          x2 > x1
        end)

      {row_y_coordinate, sorted_row}
    end)
  end

  defp flatten_to_grid(grid_points_grouped_by_rows_with_added_missing_points) do
    grid_points_grouped_by_rows_with_added_missing_points
    |> Enum.sort(fn {row_y_coordinate_1, _row_1}, {row_y_coordinate_2, _row_2} ->
      row_y_coordinate_1 < row_y_coordinate_2
    end)
    |> Enum.map(fn {_row_y_coordinate, row} -> row end)
  end

  defp map_to_value(grid_points_shaped_in_grid) do
    grid_points_shaped_in_grid
    |> Enum.map(fn row_of_grid_points ->
      Enum.map(row_of_grid_points, &Map.get(&1, :value))
    end)
  end

  defp get_coordinate(%GridPoint{point: {x, _y}}, :x), do: x
  defp get_coordinate(%GridPoint{point: {_x, y}}, :y), do: y

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
end
