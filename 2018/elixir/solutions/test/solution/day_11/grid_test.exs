defmodule Solution.Day11.GridTest do
  use ExUnit.Case
  alias Solution.Day11.Grid

  setup context do
    grid =
      Grid.new([
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8]
      ])

    Map.put(context, :grid, grid)
  end

  test "Grid not square => Raise error" do
    assert_raise RuntimeError, ~r/Grid is not square/, fn ->
      Grid.new([
        [0, 1, 2],
        [3, 4, 5]
      ])
    end

    assert_raise RuntimeError, ~r/Grid is not square/, fn ->
      Grid.new([
        [0, 1, 2],
        [3, 5],
        [6, 7, 8]
      ])
    end
  end

  test "Initially at origin", %{grid: grid} do
    assert 0 ==
             grid
             |> Grid.current()
  end

  describe "Simple Moves" do
    test "Move right", %{grid: grid} do
      assert 1 ==
               grid
               |> Grid.move(:right)
               |> Grid.current()

      assert 2 ==
               grid
               |> Grid.move(:right)
               |> Grid.move(:right)
               |> Grid.current()
    end

    test "Move left", %{grid: grid} do
      assert 0 ==
               grid
               |> Grid.move(:right)
               |> Grid.move(:left)
               |> Grid.current()

      assert 1 ==
               grid
               |> Grid.move(:right)
               |> Grid.move(:right)
               |> Grid.move(:left)
               |> Grid.current()
    end

    test "Move down", %{grid: grid} do
      assert 3 ==
               grid
               |> Grid.move(:down)
               |> Grid.current()
    end

    test "Move up", %{grid: grid} do
      assert 3 ==
               grid
               |> Grid.move(:down)
               |> Grid.move(:down)
               |> Grid.move(:up)
               |> Grid.current()
    end
  end

  describe "Mulitiple Moves" do
    test "Move 2 times right", %{grid: grid} do
      assert 2 ==
               grid
               |> Grid.move(:right, 2)
               |> Grid.current()
    end

    test "Complex move", %{grid: grid} do
      assert 4 ==
               grid
               |> Grid.move(:right, 2)
               |> Grid.move(:down, 2)
               |> Grid.move(:left, 2)
               |> Grid.move(:up)
               |> Grid.move(:right)
               |> Grid.current()
    end
  end

  describe "Out of bounds =>" do
    test "Left", %{grid: grid} do
      assert_raise RuntimeError, ~r/Out of bounds/, fn ->
        grid
        |> Grid.move(:left)
      end
    end

    test "Right", %{grid: grid} do
      assert_raise RuntimeError, ~r/Out of bounds/, fn ->
        grid
        |> Grid.move(:right)
        |> Grid.move(:right)
        |> Grid.move(:right)
      end
    end

    test "Up", %{grid: grid} do
      assert_raise RuntimeError, ~r/Out of bounds/, fn ->
        grid
        |> Grid.move(:up)
      end
    end

    test "Down", %{grid: grid} do
      assert_raise RuntimeError, ~r/Out of bounds/, fn ->
        grid
        |> Grid.move(:down)
        |> Grid.move(:down)
        |> Grid.move(:down)
      end
    end
  end
end
