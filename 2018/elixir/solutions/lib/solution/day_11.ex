defmodule Solution.Day11 do
  alias Solution.Day11.Grid
  require Logger

  defmodule SumCell do
    @moduledoc """
    Cell containing information on its associated 3x3 grid.
    The associated 3x3 grid is the one for which the cell is the top-left corner
    """
    defstruct coordinates: {nil, nil},
              sum: nil
  end

  @grid_size 300

  def solve_part_1(input_as_string) do
    input_as_string
    |> parse_serial_number()
    |> build_grid(@grid_size)
    |> to_sum_cells(3)
    |> Enum.max_by(fn %{sum: sum} -> sum end)
    |> Map.get(:coordinates)
    |> format()
  end

  defp parse_serial_number(input_as_string) do
    input_as_string
    |> String.split("\n")
    |> List.first()
    |> String.to_integer()
  end

  def build_grid(serial_number, size) do
    for y <- 1..size do
      for x <- 1..size do
        fuel_cell_power({x, y}, serial_number)
      end
    end
    |> Grid.new()
  end

  def fuel_cell_power({x, y}, serial_number) do
    rack_id = x + 10

    y
    |> Kernel.*(rack_id)
    |> Kernel.+(serial_number)
    |> Kernel.*(rack_id)
    |> extract_hundreds_digit()
    |> Kernel.-(5)
  end

  defp extract_hundreds_digit(number),
    do: div(number, 100) - div(number, 1000) * 10

  defp to_sum_cells(grid_at_origin, region_size) do
    do_to_sum_cells({0, 0}, grid_at_origin, [], region_size)
  end

  defp do_to_sum_cells({x, y}, grid_at_x_y, sum_cells, region_size) do
    sum_cells = [
      %SumCell{
        coordinates: {x + 1, y + 1},
        sum: sum_in_region(grid_at_x_y, region_size)
      }
      | sum_cells
    ]

    cond do
      x + 1 >= @grid_size - region_size and y + 1 >= @grid_size - region_size ->
        sum_cells

      x + 1 >= @grid_size - region_size ->
        grid_at_0_yplus1 =
          grid_at_x_y
          |> Grid.move(:left, x)
          |> Grid.move(:down)

        do_to_sum_cells({0, y + 1}, grid_at_0_yplus1, sum_cells, region_size)

      true ->
        grid_at_xplus1_y =
          grid_at_x_y
          |> Grid.move(:right)

        do_to_sum_cells({x + 1, y}, grid_at_xplus1_y, sum_cells, region_size)
    end
  end

  defp sum_in_region(grid_at_x_y, region_size) do
    do_sum_in_region({0, 0}, 0, grid_at_x_y, region_size)
  end

  defp do_sum_in_region({i, j}, sum, grid_at_xplusi_yplusj, region_size) do
    sum = sum + Grid.current(grid_at_xplusi_yplusj)

    cond do
      i + 1 >= region_size and j + 1 >= region_size ->
        sum

      i + 1 >= region_size ->
        grid_at_xplus0_yplusjplus1 =
          grid_at_xplusi_yplusj
          |> Grid.move(:left, i)
          |> Grid.move(:down)

        do_sum_in_region({0, j + 1}, sum, grid_at_xplus0_yplusjplus1, region_size)

      true ->
        grid_at_xplusiplus1_yplusj =
          grid_at_xplusi_yplusj
          |> Grid.move(:right)

        do_sum_in_region({i + 1, j}, sum, grid_at_xplusiplus1_yplusj, region_size)
    end
  end

  defp format({x, y}) do
    "#{x},#{y}"
  end

  def solve_part_2(_input_as_string) do
  end
end
