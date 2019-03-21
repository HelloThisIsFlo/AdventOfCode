defmodule Solution.Day11 do
  require Logger

  defmodule SumCell do
    @moduledoc """
    Cell containing information on its associated 3x3 grid.
    The associated 3x3 grid is the one for which the cell is the top-left corner
    """
    defstruct coordinates: {nil, nil},
              total_sum: nil,
              sum_on_columns: []
  end

  @grid_size 300

  def solve_part_1(input_as_string) do
    input_as_string
    |> parse_serial_number()
    |> build_grid(@grid_size)
    |> map_to_sum_of_power_in_corresponding_3_by_3_region_with_coordinates()
    |> find_coordinates_of_max()
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

  defp map_to_sum_of_power_in_corresponding_3_by_3_region_with_coordinates(grid) do
    size = length(grid)

    for y <- 1..(size - 2) do
      for x <- 1..(size - 2) do
        sum = sum_of_power_in_corresponding_3_by_3_region({x, y}, grid)
        %SumCell{coordinates: {x, y}, total_sum: sum}
      end
    end
  end

  defp sum_of_power_in_corresponding_3_by_3_region({x, y}, grid) do
    [
      {x, y},
      {x, y + 1},
      {x, y + 2},
      {x + 1, y},
      {x + 1, y + 1},
      {x + 1, y + 2},
      {x + 2, y},
      {x + 2, y + 1},
      {x + 2, y + 2}
    ]
    |> Enum.map(fn {x, y} -> get(grid, {x, y}) end)
    |> Enum.sum()
  end

  defp get(grid, {x, y}) do
    grid
    |> Enum.at(y - 1)
    |> Enum.at(x - 1)
  end

  defp find_coordinates_of_max(sum_of_power_grid) do
    %{coordinates: coordinates} =
      sum_of_power_grid
      |> Enum.map(&Enum.max_by(&1, fn %{total_sum: sum} -> sum end))
      |> Enum.max_by(fn %{total_sum: sum} -> sum end)

    coordinates
  end

  defp format({x, y}) do
    "#{x},#{y}"
  end

  def solve_part_2(input_as_string) do
  end
end
