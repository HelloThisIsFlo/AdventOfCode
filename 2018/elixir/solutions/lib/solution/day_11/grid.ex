defmodule Solution.Day11.Grid do
  # TODO: Implement with zipper
  defstruct current: {0, 0},
            cells: [],
            size: 0

  def new(grid_as_list_of_list) do
    ensure_square(grid_as_list_of_list)
    size = length(grid_as_list_of_list)

    tmp =
      grid_as_list_of_list
      |> Enum.map(&Enum.with_index/1)
      |> Enum.with_index()
      |> Enum.map(fn {row, row_index} ->
        row
        |> Enum.map(fn {val, col_index} ->
          %{coordinates: {col_index, row_index}, val: val}
        end)
      end)
      |> List.flatten()
      |> Map.new(fn %{coordinates: {x, y}, val: val} ->
        {{x, y}, val}
      end)

    %__MODULE__{
      # cells: grid_as_list_of_list,
      cells: tmp,
      size: size
    }
  end

  def current(%{cells: cells, current: {x, y}}) do
    Map.get(cells, {x, y})
  end

  def move(grid, direction, offset \\ 1)
  def move(grid, _direction, 0), do: grid

  def move(grid, direction, offset) do
    grid
    |> do_move(direction)
    |> move(direction, offset - 1)
  end

  def do_move(%{current: {x, y}} = grid, :right),
    do: %{grid | current: {x + 1, y}} |> ensure_valid()

  def do_move(%{current: {x, y}} = grid, :left),
    do: %{grid | current: {x - 1, y}} |> ensure_valid()

  def do_move(%{current: {x, y}} = grid, :down),
    do: %{grid | current: {x, y + 1}} |> ensure_valid()

  def do_move(%{current: {x, y}} = grid, :up), do: %{grid | current: {x, y - 1}} |> ensure_valid()

  ######################################################
  ## Private functions #################################
  ######################################################
  defp ensure_square(grid_as_list_of_list) do
    height = length(grid_as_list_of_list)
    width = length(List.first(grid_as_list_of_list))

    all_rows_have_correct_width? =
      Enum.all?(grid_as_list_of_list, fn row -> length(row) == width end)

    if height != width or not all_rows_have_correct_width? do
      raise "Grid is not square"
    end
  end

  defp ensure_valid(%{current: {x, y}, size: s})
       when x < 0 or y < 0 or x >= s or y >= s,
       do: raise("Out of bounds")

  defp ensure_valid(grid), do: grid
end
