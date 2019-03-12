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

  defstruct elements: []

  @impl true
  def new() do
    %__MODULE__{}
  end

  @impl true
  def new(list) do
    %__MODULE__{
      elements: list
    }
  end

  @impl true
  def insert_after_current(circle, element) do
    %{circle | elements: List.insert_at(circle.elements, 1, element)}
    |> rotate(1, :clockwise)
  end

  @impl true
  def delete_current(circle) do
    %{circle | elements: List.delete_at(circle.elements, 0)}
  end

  @impl true
  def rotate(circle, offset, direction) do
    do_rotate(circle, offset, direction)
  end

  def do_rotate(%{elements: []} = circle, _, _), do: circle
  def do_rotate(circle, 0, _), do: circle
  def do_rotate(_, offset, _) when offset < 0, do: raise("Offset can not be < 0 !")

  def do_rotate(circle, offset, direction) do
    elements =
      case direction do
        :clockwise ->
          {first, elements} = List.pop_at(circle.elements, 0)
          elements ++ [first]

        :anticlockwise ->
          {last, elements} = List.pop_at(circle.elements, -1)
          [last | elements]
      end

    do_rotate(%{circle | elements: elements}, offset - 1, direction)
  end

  @impl true
  def current(circle) do
    List.first(circle.elements)
  end

  @impl true
  def to_list(circle) do
    circle.elements
  end
end
