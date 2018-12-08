defmodule Solution.Day6.ClosestPointsArea do
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

  @spec from_origin([any()]) :: __MODULE__.t
  def from_origin(origin) do
    %__MODULE__{
      grow_stages: [[origin]]
    }
  end

  @spec from_grid([[String.t]]) :: __MODULE__.t
  def from_grid(grid) do
    %__MODULE__{
      grow_stages: to_grow_stages(grid)
    }
  end

  def all_points(%__MODULE__{grow_stages: grow_stages}) do
    grow_stages
    |> List.flatten()
    |> MapSet.new()
  end

  def next_candidate_area(%__MODULE__{grow_stages: grow_stages, fully_grown?: true}),
    do: List.last(grow_stages)

  def next_candidate_area(%__MODULE__{grow_stages: grow_stages}),
    do: do_next_candidate_area(Enum.reverse(grow_stages))

  def current_grow_stage(%__MODULE__{grow_stages: []}), do: 0

  def current_grow_stage(%__MODULE__{grow_stages: grow_stages}),
    do: length(grow_stages) - 1

  # ------- Private Functions -------------
  # ------- Private Functions -------------
  # ------- Private Functions -------------

  defp to_grow_stages(grid) do
    for y <- 0..(length(grid) - 1) do
      for x <- 0..(length(get_line(grid, y)) - 1) do
        case get_point(grid, x, y) do
          " " ->
            nil

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
