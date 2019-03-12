defmodule Solution.Day9.CircleTest do
  use ExUnit.Case
  alias Solution.Day9.Circle

  describe "New Circle =>" do
    test "Empty" do
      circle = Circle.new()
      assert Circle.to_list(circle) == []
      assert Circle.current(circle) == nil
    end

    test "From list" do
      list = [1, 2, 3, 4]
      circle = Circle.new(list)
      assert Circle.to_list(circle) == list
      assert Circle.current(circle) == 1
    end
  end

  describe "Rotate current =>" do
    setup context do
      circle = Circle.new([1, 2, 3, 4])

      Map.put(context, :circle, circle)
    end

    test "By default current is first element", %{circle: circle} do
      assert Circle.current(circle) == 1
    end

    test "Negative offset => raise error", %{circle: circle} do
      assert_raise RuntimeError, fn ->
        Circle.rotate(circle, -3, :clockwise)
      end

      assert_raise RuntimeError, fn ->
        Circle.rotate(circle, -3, :anticlockwise)
      end
    end

    test "0 offset", %{circle: circle} do
      assert Circle.rotate(circle, 0, :clockwise) == circle
      assert Circle.rotate(circle, 0, :anticlockwise) == circle
    end

    test "1 Clockwise", %{circle: circle} do
      rotated_circle = Circle.rotate(circle, 1, :clockwise)
      assert Circle.current(rotated_circle) == 2
      assert Circle.to_list(rotated_circle) == [2, 3, 4, 1]
    end

    test "3 Clockwise", %{circle: circle} do
      rotated_circle = Circle.rotate(circle, 3, :clockwise)
      assert Circle.current(rotated_circle) == 4
      assert Circle.to_list(rotated_circle) == [4, 1, 2, 3]
    end

    test "1 Anti-Clockwise", %{circle: circle} do
      rotated_circle = Circle.rotate(circle, 1, :anticlockwise)
      assert Circle.current(rotated_circle) == 4
      assert Circle.to_list(rotated_circle) == [4, 1, 2, 3]
    end

    test "2 Anti-Clockwise", %{circle: circle} do
      rotated_circle = Circle.rotate(circle, 2, :anticlockwise)
      assert Circle.current(rotated_circle) == 3
      assert Circle.to_list(rotated_circle) == [3, 4, 1, 2]
    end

    test "Empty" do
      empty_circle = Circle.new()
      assert Circle.rotate(empty_circle, 123, :clockwise) == empty_circle
      assert Circle.rotate(empty_circle, 456, :anticlockwise) == empty_circle
    end
  end

  describe "Insert element after current =>" do
    test "Empty Circle" do
      circle = Circle.new()
      circle = Circle.insert_after_current(circle, 44)
      assert Circle.to_list(circle) == [44]
    end

    test "Not empty Circle => Insert after current and shift current to newly inserted" do
      circle = Circle.new([1, 2, 3])
      assert Circle.current(circle) == 1

      circle = Circle.insert_after_current(circle, 44)

      assert Circle.to_list(circle) == [44, 2, 3, 1]
      assert Circle.current(circle) == 44
    end

    test "Multiple insertions" do
      circle = Circle.new([1, 2, 3])
      assert Circle.current(circle) == 1

      circle =
        circle
        |> Circle.insert_after_current(44)
        |> Circle.insert_after_current(55)
        |> Circle.insert_after_current(66)
        |> Circle.insert_after_current(77)

      assert Circle.to_list(circle) == [77, 2, 3, 1, 44, 55, 66]
      assert Circle.current(circle) == 77
    end
  end

  describe "Delete current =>" do
    test "Empty Circle" do
      circle = Circle.new()
      assert Circle.delete_current(circle) == circle
    end

    test "Not empty Circle => Delete and shift current to next clockwise" do
      circle = Circle.new([1, 2, 3, 4])
      assert Circle.current(circle) == 1

      circle = Circle.delete_current(circle)

      assert Circle.to_list(circle) == [2, 3, 4]
      assert Circle.current(circle) == 2
    end

    test "Multiple deletion" do
      circle = Circle.new([1, 2, 3, 4, 5, 6])

      circle =
        circle
        |> Circle.delete_current()
        |> Circle.delete_current()
        |> Circle.delete_current()

      assert Circle.to_list(circle) == [4, 5, 6]
      assert Circle.current(circle) == 4
    end
  end
end
