defmodule Solution.Day6 do
  require Logger

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
  alias __MODULE__.ClosestPointsArea

  @doc """
  Solves: "What is the size of the largest area that isn't infinite?"
  """
  def solve_part_1(_input_as_string) do
    ""
  end

  defmodule ClosestPointsArea do
    @type x() :: integer()
    @type y() :: integer()
    @type point() :: {x(), y()}

    @type t :: %{
            fully_grown?: boolean(),
            grow_stages: [[point()]]
          }
    defstruct fully_grown?: false,
              grow_stages: []

    defmodule InvalidArea do
      defexception [:message]

      @impl true
      def exception(reason) do
        %InvalidArea{message: "Invalid Area! => " <> reason}
      end
    end

    def from_grid(grid) do
      %ClosestPointsArea{
        grow_stages: to_grow_stages(grid)
      }
    end

    def all_points(%ClosestPointsArea{grow_stages: grow_stages}) do
      grow_stages
      |> List.flatten()
      |> MapSet.new()
    end

    def next_candidate_area(%ClosestPointsArea{grow_stages: grow_stages, fully_grown?: true}),
      do: List.last(grow_stages)
    def next_candidate_area(%ClosestPointsArea{grow_stages: grow_stages}),
      do: do_next_candidate_area(Enum.reverse(grow_stages))

    def current_grow_stage(%ClosestPointsArea{grow_stages: []}), do: 0
    def current_grow_stage(%ClosestPointsArea{grow_stages: grow_stages}),
      do: length(grow_stages) - 1

    # ------- Private Functions -------------
    # ------- Private Functions -------------
    # ------- Private Functions -------------

    defp to_grow_stages(grid) do
      for y <- 0..(length(grid) - 1) do
        for x <- 0..(length(get_line(grid, y)) - 1) do
          case get_point(grid, x, y) do
            " " -> nil
            stage_as_str ->
              point = {x, y}
              stage = String.to_integer(stage_as_str)
              {stage, point}
          end
        end
      end
      |> List.flatten()
      |> Enum.reject(&(&1 == nil))
      |> Enum.sort(fn {stage1, _}, {stage2, _} -> stage1 <= stage2 end)
      |> Enum.chunk_by(fn {stage, _} -> stage end)
      |> Enum.map(fn stage_points ->
        stage_points
        |> Enum.map(fn {_stage, point} -> point end)
      end)
    end

    defp get_line(grid, y) do
      grid
      |> Enum.at(y)
    end

    defp get_point(grid, x, y) do
      grid
      |> get_line(y)
      |> Enum.at(x)
    end

    defp do_next_candidate_area(grow_stages_in_reverse_order)
    defp do_next_candidate_area([]),
      do: raise(InvalidArea, "No grow stages")
    defp do_next_candidate_area([only_stage]) when length(only_stage) > 1,
      do: raise(InvalidArea, "First stage should only contain origin")
    defp do_next_candidate_area([[origin]]),
      do: grow_in_all_4_directions(origin)
    defp do_next_candidate_area([last_stage | [second_last_stage | _]]) do
      last_stage
      |> Enum.flat_map(&grow_in_all_4_directions/1)
      |> Enum.uniq()
      |> Kernel.--(second_last_stage)
    end

    defp grow_in_all_4_directions({x, y}) do
      [
        {x + 1, y},
        {x - 1, y},
        {x, y + 1},
        {x, y - 1}
      ]
    end
  end

  @doc """
  Solves: ""
  """
  def solve_part_2(_input_as_string) do
    ""
  end
end
