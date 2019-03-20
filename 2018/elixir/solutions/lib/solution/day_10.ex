defmodule Solution.Day10 do
  require Logger
  alias Solution.Day6.GridString.GridPoint
  alias Solution.Day6.GridString

  @type y :: integer()
  @type x :: integer()
  @type coordinates :: {x(), y()}
  @type speed :: {x(), y()}
  @type point :: {coordinates(), speed()}

  @edge_length 5
  @min_num_of_edges 8

  def solve_part_1(input_as_string) do
    GridString.configure(
      default_value: ".",
      start: "",
      separator: "",
      end: "",
      padding: ""
    )

    input_as_string
    |> parse_points()
    |> forward_until_edges_found()
    |> to_grid_string()
    |> String.Chars.to_string()
  end

  def solve_part_2(input_as_string) do
    input_as_string
    |> parse_points()
    |> find_time_to_alignment()
    |> Integer.to_string()
  end

  defp parse_points(input_as_string) do
    input_as_string
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn line ->
      ~r/position=<(?<px>[- ]*\d+), (?<py>[- ]*\d+)> velocity=<(?<vx>[- ]*\d+), (?<vy>[- ]*\d+)/
      |> Regex.named_captures(line)
      |> Map.new(fn {key, val} ->
        val_parsed_to_int = val |> String.trim() |> String.to_integer()
        {key, val_parsed_to_int}
      end)
      |> to_point()
    end)
  end

  @spec to_point(map()) :: point()
  defp to_point(%{"px" => px, "py" => py, "vx" => vx, "vy" => vy}) do
    {{px, py}, {vx, vy}}
  end

  defp forward_until_edges_found(points) do
    {points, _last_iteration} = do_forward_until_edges_found(points, 1)
    points
  end

  defp do_forward_until_edges_found(points, iteration) do
    points = forward_1_second(points)

    if form_vertical_edges?(points) do
      {points, iteration}
    else
      do_forward_until_edges_found(points, iteration + 1)
    end
  end

  @spec forward_1_second([point()]) :: [point()]
  defp forward_1_second(points) do
    points
    |> Enum.map(fn {{x, y}, {vx, vy} = v} ->
      {{x + vx, y + vy}, v}
    end)
  end

  defp form_vertical_edges?(points) do
    all_coordinates =
      points
      |> Enum.map(fn {coordinates, _velocity} -> coordinates end)
      |> MapSet.new()

    num_of_vertical_edges =
      points
      |> Enum.filter(&is_vertical_edge_start?(all_coordinates, &1))
      |> Enum.map(fn _ -> 1 end)
      |> Enum.sum()

    num_of_vertical_edges >= @min_num_of_edges
  end

  defp is_vertical_edge_start?(all_coordinates, {{x, y}, _velocity}) do
    1..(@edge_length - 1)
    |> Enum.map(fn i ->
      {x, y - i}
    end)
    |> Enum.all?(&Enum.member?(all_coordinates, &1))
  end

  defp to_grid_string(points) do
    points
    |> Enum.map(fn {{x, y}, _velocity} ->
      %GridPoint{point: {x, y}, value: "#"}
    end)
    |> translate_top_left_to_origin()
    |> GridString.from_grid_points()
  end

  defp translate_top_left_to_origin(grid_points) do
    top_left_x = grid_points |> Enum.map(fn %{point: {x, _}} -> x end) |> Enum.min()
    top_left_y = grid_points |> Enum.map(fn %{point: {_, y}} -> y end) |> Enum.min()

    grid_points
    |> Enum.map(fn %{point: {x, y}} = grid_point ->
      %{grid_point | point: {x - top_left_x, y - top_left_y}}
    end)
  end

  defp find_time_to_alignment(points) do
    {_points, last_iteration} = do_forward_until_edges_found(points, 1)
    last_iteration
  end
end
