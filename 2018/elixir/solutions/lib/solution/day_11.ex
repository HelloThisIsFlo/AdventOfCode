defmodule Solution.Day11 do
  require Logger

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

    # for y <- 1..(size - 2) do
    #   for x <- 1..(size - 2) do
    #     sum = sum_of_power_in_corresponding_3_by_3_region({x, y}, grid)
    #     {{x, y}, sum}
    #   end
    # end
    to_sum_grid(grid)
  end

  defp to_sum_grid(grid) do
    size = length(grid)

    do_to_sum_grid({1, 1}, [], grid)
  end

  defmodule SumCell do
    @moduledoc """
    Cell containing information on its associated 3x3 grid.
    The associated 3x3 grid is the one for which the cell is the top-left corner
    """
    defstruct coordinates: {nil, nil},
              total_sum: nil,
              sum_on_columns: []
  end

  # Reached the end of the grid
  # - grid is complete
  # => Return grid
  defp do_to_sum_grid({i, j}, sum_grid, power_grid)
       when i >= length(power_grid) - 2 and j >= length(power_grid) - 2,
       do: sum_grid

  # Reached the end of the row
  # - current row is complete
  # => Build next row
  defp do_to_sum_grid({i, j}, sum_grid, power_grid)
       when i >= length(power_grid) - 2,
       do: do_to_sum_grid({1, j + 1}, sum_grid, power_grid)

  # Very first cell
  # => Build cell and add in new sum_grid
  defp do_to_sum_grid({1, 1}, [] = _sum_grid, power_grid) do
    sum_on_column_at_1_1 = sum_on_column_3_by_3_region({1, 1}, power_grid)

    cell_at_1_1 = %SumCell{
      coordinates: {1, 1},
      total_sum: sum_on_column_at_1_1 |> Enum.sum(),
      sum_on_columns: sum_on_column_at_1_1
    }

    do_to_sum_grid({1 + 1, 1}, [[cell_at_1_1]], power_grid)
  end

  # Cell in first row, not very first cell
  #  - previous cells in row are complete
  # => Build cell
  #    - add in first row
  #    - move to next cell
  defp do_to_sum_grid({i, 1}, sum_grid, power_grid) do
    previous_cell = get(sum_grid, {i - 1, 1})

    third_column_sum =
      [
        {i + 2, 1},
        {i + 2, 1 + 1},
        {i + 2, 1 + 2}
      ]
      |> Enum.map(fn {x, y} -> get(power_grid, {x, y}) end)
      |> Enum.sum()

    first_two_column_sum = Enum.slice(previous_cell.sum_on_columns, 1..2)

    sum_on_column_at_i_1 = first_two_column_sum ++ [third_column_sum]

    cell_at_i_1 = %SumCell{
      coordinates: {i, 1},
      total_sum: sum_on_column_at_i_1 |> Enum.sum(),
      sum_on_columns: sum_on_column_at_i_1
    }

    sum_grid =
      List.update_at(sum_grid, 0, fn first_row ->
        first_row ++ [cell_at_i_1]
      end)

    do_to_sum_grid({i + 1, 1}, sum_grid, power_grid)
  end

  # First cell of current row
  # - previous row is complete
  #
  # => Build cell
  #  - add in a new row in current sum_grid
  #  - move to next cell
  defp do_to_sum_grid({1, j}, sum_grid, power_grid) do
    # Remember: Previous row is complete at this point (for later)
    sum_on_column_at_1_j = sum_on_column_3_by_3_region({1, j}, power_grid)

    cell_at_1_j = %SumCell{
      coordinates: {1, j},
      total_sum: sum_on_column_at_1_j |> Enum.sum(),
      sum_on_columns: sum_on_column_at_1_j
    }

    sum_grid = sum_grid ++ [[cell_at_1_j]]
    do_to_sum_grid({1 + 1, j}, sum_grid, power_grid)
  end

  # Not first cell of current row, not first row
  # - previous row complete
  # - previous cell in current row complete
  # => Build cell and add in current row
  defp do_to_sum_grid({i, j}, sum_grid, power_grid) do
    previous_cell = get(sum_grid, {i - 1, j})

    third_column_sum =
      [
        {i + 2, j},
        {i + 2, j + 1},
        {i + 2, j + 2}
      ]
      |> Enum.map(fn {x, y} -> get(power_grid, {x, y}) end)
      |> Enum.sum()

    first_two_column_sum = Enum.slice(previous_cell.sum_on_columns, 1..2)

    sum_on_column_at_i_j = first_two_column_sum ++ [third_column_sum]

    cell_at_i_j = %SumCell{
      coordinates: {i, j},
      total_sum: sum_on_column_at_i_j |> Enum.sum(),
      sum_on_columns: sum_on_column_at_i_j
    }

    sum_grid =
      List.update_at(sum_grid, j - 1, fn current_row ->
        current_row ++ [cell_at_i_j]
      end)

    do_to_sum_grid({i + 1, j}, sum_grid, power_grid)
  end

  defp sum_on_column_3_by_3_region({x, y}, grid) do
    c1 =
      [
        {x, y},
        {x, y + 1},
        {x, y + 2}
      ]
      |> Enum.map(fn {x, y} -> get(grid, {x, y}) end)
      |> Enum.sum()

    c2 =
      [
        {x + 1, y},
        {x + 1, y + 1},
        {x + 1, y + 2}
      ]
      |> Enum.map(fn {x, y} -> get(grid, {x, y}) end)
      |> Enum.sum()

    c3 =
      [
        {x + 2, y},
        {x + 2, y + 1},
        {x + 2, y + 2}
      ]
      |> Enum.map(fn {x, y} -> get(grid, {x, y}) end)
      |> Enum.sum()

    [c1, c2, c3]
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
