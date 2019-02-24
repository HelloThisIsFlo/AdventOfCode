defmodule Solution.Day6 do
  require Logger
  alias __MODULE__.Board
  alias __MODULE__.ClosestPointsArea

  @moduledoc """
  --- Part One ---
  The device on your wrist beeps several times, and once again you feel like
  you're falling.

  "Situation critical," the device announces. "Destination indeterminate.
  Chronal interference detected. Please specify new target coordinates."

  The device then produces a list of coordinates (your puzzle input). Are they
  places it thinks are safe or dangerous? It recommends you check manual
  page 729. The Elves did not give you a manual.

  If they're dangerous, maybe you can minimize the danger by finding the
  coordinate that gives the largest distance from the other points.

  Using only the Manhattan distance, determine the area around each coordinate
  by counting the number of integer X,Y locations that are closest to that
  coordinate (and aren't tied in distance to any other coordinate).

  Your goal is to find the size of the largest area that isn't infinite. For
  example, consider the following list of coordinates:

  1, 1
  1, 6
  8, 3
  3, 4
  5, 5
  8, 9
  If we name these coordinates A through F, we can draw them on a grid, putting
  0,0 at the top left:

  ..........
  .A........
  ..........
  ........C.
  ...D......
  .....E....
  .B........
  ..........
  ..........
  ........F.
  This view is partial - the actual grid extends infinitely in all directions.
  Using the Manhattan distance, each location's closest coordinate can be
  determined, shown here in lowercase:

  aaaaa.cccc
  aAaaa.cccc
  aaaddecccc
  aadddeccCc
  ..dDdeeccc
  bb.deEeecc
  bBb.eeee..
  bbb.eeefff
  bbb.eeffff
  bbb.ffffFf
  Locations shown as . are equally far from two or more coordinates, and so
  they don't count as being closest to any.

  In this example, the areas of coordinates A, B, C, and F are infinite -
  while not shown here, their areas extend forever outside the visible
  grid. However, the areas of coordinates D and E are finite: D is closest
  to 9 locations, and E is closest to 17 (both including the coordinate's
  location itself). Therefore, in this example, the size of the largest
  area is 17.

  What is the size of the largest area that isn't infinite?
  """

  @behaviour Solution
  alias Solution.Day6.ClosestPointsArea

  @doc """
  Solves: "What is the size of the largest area that isn't infinite?"

  Basic idea:
  - Parse points
  - Build a board from points
  - Grow the board
  - Keep growing until X iterations after the last finite area stopped growing
  - Get finite areas
  - Calculate finite areas' sizes
  - Find largest
  """
  def solve_part_1(input_as_string) do
    input_as_string
    |> parse_list_of_origin_points()
    |> build_board()
    |> find_finite_areas()
    |> Enum.map(&ClosestPointsArea.size/1)
    |> Enum.max()
    |> Integer.to_string()
  end

  defp parse_list_of_origin_points(input_as_string) do
    input_as_string
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn coordinate_as_string ->
      ~r/(\d+), (\d+)/
      |> Regex.run(coordinate_as_string, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)
      |> to_point()
    end)
  end

  defp build_board(points_of_origin) do
    points_of_origin
    |> Board.from_origin_points()
  end

  defp find_finite_areas(board) do
    limit = 100
    do_find_finite_areas(board, [], 0, limit)
  end

  defp do_find_finite_areas(_, finite_areas, iterations_since_last_finite_area_discovered, limit)
       when iterations_since_last_finite_area_discovered >= limit,
       do: finite_areas

  defp do_find_finite_areas(
         board,
         finite_areas,
         iterations_since_last_finite_area_discovered,
         limit
       ) do
    board = Board.grow(board)

    new_finite_areas =
      board.areas
      |> Enum.filter(&ClosestPointsArea.fully_grown?/1)

    if length(new_finite_areas) > length(finite_areas) do
      do_find_finite_areas(board, new_finite_areas, 0, limit)
    else
      do_find_finite_areas(
        board,
        new_finite_areas,
        iterations_since_last_finite_area_discovered + 1,
        limit
      )
    end
  end

  defp to_point([x, y]) do
    {x, y}
  end

  @doc """
  --- Part Two ---
  On the other hand, if the coordinates are safe, maybe the best you can do is try
  to find a region near as many coordinates as possible.

  For example, suppose you want the sum of the Manhattan distance to all of the
  coordinates to be less than 32. For each location, add up the distances to all
  of the given coordinates; if the total of those distances is less than 32, that
  location is within the desired region. Using the same coordinates as above,
  the resulting region looks like this:

  ..........
  .A........
  ..........
  ...###..C.
  ..#D###...
  ..###E#...
  .B.###....
  ..........
  ..........
  ........F.
  In particular, consider the highlighted location 4,3 located at the top middle of
  the region. Its calculation is as follows, where abs() is the absolute value function:

  Distance to coordinate A: abs(4-1) + abs(3-1) =  5
  Distance to coordinate B: abs(4-1) + abs(3-6) =  6
  Distance to coordinate C: abs(4-8) + abs(3-3) =  4
  Distance to coordinate D: abs(4-3) + abs(3-4) =  2
  Distance to coordinate E: abs(4-5) + abs(3-5) =  3
  Distance to coordinate F: abs(4-8) + abs(3-9) = 10
  Total distance: 5 + 6 + 4 + 2 + 3 + 10 = 30
  Because the total distance to all coordinates (30) is less than 32, the location is
  within the region.

  This region, which also includes coordinates D and E, has a total size of 16.

  Your actual region will need to be much larger than this example, though, instead
  including all locations with a total distance of less than 10000.

  What is the size of the region containing all locations which have a total distance
  to all given coordinates of less than 10000?
  Solves: ""
  """
  def solve_part_2(input_as_string, limit \\ 10_000) do
    origin_points =
      input_as_string
      |> parse_list_of_origin_points()

    origin_points
    |> find_point_in_region(limit)
    |> IO.inspect(label: "Found point in region")
    |> to_region()
    |> grow_until_stable(origin_points, limit)
    |> Kernel.length()
    |> Integer.to_string()
  end

  defp to_region(origin_point), do: [origin_point]

  defp find_point_in_region(origin_points, limit) do
    origin_points_max_x = origin_points |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    origin_points_min_x = origin_points |> Enum.map(fn {x, _} -> x end) |> Enum.min()
    origin_points_max_y = origin_points |> Enum.map(fn {y, _} -> y end) |> Enum.max()
    origin_points_min_y = origin_points |> Enum.map(fn {y, _} -> y end) |> Enum.min()

    rand_point = {
      Enum.random(origin_points_min_x..origin_points_max_x),
      Enum.random(origin_points_min_y..origin_points_max_y)
    }

    if in_region?(rand_point, origin_points, limit) do
      rand_point
    else
      find_point_in_region(origin_points, limit)
    end
  end

  defp sum_of_manhattan_dist_to_all_origin_points(point, origin_points) do
    origin_points
    |> Enum.map(&manhattan_distance(&1, point))
    |> Enum.sum()
  end

  defp manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x2 - x1) + abs(y2 - y1)
  end

  defp grow_until_stable(region_near_as_many_coordinates_as_possible, origin_points, limit) do
    new_region = grow(region_near_as_many_coordinates_as_possible, origin_points, limit)

    if region_near_as_many_coordinates_as_possible == new_region do
      region_near_as_many_coordinates_as_possible
    else
      grow_until_stable(new_region, origin_points, limit)
    end
  end

  defp grow(region_near_as_many_coordinates_as_possible, origin_points, limit) do
    next_grow_stage =
      region_near_as_many_coordinates_as_possible
      |> Enum.flat_map(fn {x, y} ->
        [
          {x + 1, y},
          {x - 1, y},
          {x, y + 1},
          {x, y - 1}
        ]
      end)
      |> Enum.uniq()
      |> Enum.filter(&in_region?(&1, origin_points, limit))

    next_grow_stage
    |> Enum.into(region_near_as_many_coordinates_as_possible)
    |> Enum.uniq()

    # |> IO.inspect()
    # region_near_as_many_coordinates_as_possible ++ next_grow_stage
    # region_near_as_many_coordinates_as_possible
    # |> Enum.flat_map(fn {x, y} ->
    #   [
    #     {x, y},
    #     {x + 1, y},
    #     {x - 1, y},
    #     {x, y + 1},
    #     {x, y - 1}
    #   ]
    #   |> Enum.filter(&in_region?(&1, origin_points, limit))
    # end)
    # |> Enum.uniq()
  end

  defp in_region?(point, origin_points, limit) do
    sum_of_manhattan_dist_to_all_origin_points(point, origin_points) < limit
  end
end
