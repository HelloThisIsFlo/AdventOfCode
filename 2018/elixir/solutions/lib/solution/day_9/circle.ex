defmodule Solution.Day9.Circle do
  defmodule Behavior do
    @type direction :: :clockwise | :anticlockwise

    @callback new() :: Circle.t()
    @callback new([any()]) :: Circle.t()
    @callback insert_after_current(Circle.t(), any()) :: Circle.t()
    @callback delete_current(Circle.t()) :: Circle.t()
    @callback rotate(Circle.t(), pos_integer(), direction()) :: Circle.t()
    @callback current(Circle.t()) :: any()
    @callback to_list(Circle.t()) :: [any()]
  end

  @behaviour Behavior

  defstruct current_and_before: [],
            after_current: []

  @impl true
  def new() do
    %__MODULE__{}
  end

  @impl true
  def new(list) do
    [current | after_current] = list

    %__MODULE__{
      current_and_before: [current],
      after_current: after_current
    }
  end

  @impl true
  def insert_after_current(circle, element),
    do: %{circle | current_and_before: [element | circle.current_and_before]}

  @impl true
  def delete_current(%{current_and_before: []} = circle), do: circle
  def delete_current(%{after_current: []} = circle),
    do: %{
      circle
      | current_and_before: List.delete_at(circle.current_and_before, 0),
        after_current: []
    }
  def delete_current(%{after_current: [first | rest]} = circle),
    do: %{
      circle
      | current_and_before: [first | List.delete_at(circle.current_and_before, 0)],
        after_current: rest
    }

  @impl true
  def rotate(circle, offset, direction)
  def rotate(_, offset, _) when offset < 0, do: raise("Offset can not be < 0 !")
  def rotate(circle, 0, _), do: circle
  def rotate(%{current_and_before: []} = circle, _, _), do: circle
  def rotate(%{current_and_before: [_c], after_current: []} = circle, _, _), do: circle

  def rotate(circle, offset, :clockwise) do
    circle =
      case circle.after_current do
        [first_after_current | rest_after_current] ->
          %{
            circle
            | current_and_before: [first_after_current | circle.current_and_before],
              after_current: rest_after_current
          }

        [] ->
          all_elements_starting_with_current_in_reverse_order = circle.current_and_before

          [first | rest] =
            all_elements_starting_with_current_in_reverse_order
            |> Enum.reverse()

          %{
            circle
            | current_and_before: [first],
              after_current: rest
          }
      end

    rotate(circle, offset - 1, :clockwise)
  end

  def rotate(circle, offset, :anticlockwise) do
    circle =
      case circle.current_and_before do
        [current] ->
          %{
            circle
            | current_and_before: Enum.reverse([current | circle.after_current]),
              after_current: []
          }

        [current | before_current] ->
          %{
            circle
            | current_and_before: before_current,
              after_current: [current | circle.after_current]
          }
      end

    rotate(circle, offset - 1, :anticlockwise)
  end

  @impl true
  def current(circle)
  def current(%{current_and_before: [current | _]}), do: current
  def current(%{current_and_before: []}), do: nil

  @impl true
  def to_list(%{current_and_before: []}), do: []
  def to_list(circle),
    do: Enum.reverse(circle.current_and_before) ++ circle.after_current

end
