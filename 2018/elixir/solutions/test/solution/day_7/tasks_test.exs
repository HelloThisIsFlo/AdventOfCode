defmodule Solution.Day7.TasksTest do
  use ExUnit.Case
  alias Solution.Day7.Tasks

  def assert_equal_any_order(list1, list2), do: assert(Enum.sort(list1) == Enum.sort(list2))

  setup context do
    Tasks.start_link(context[:tasks_with_prerequisites])
    :ok
  end

  describe "Generate tasks available for pickup" do
    @tag tasks_with_prerequisites: %{}
    test "No tasks => No tasks available" do
      assert Tasks.available_for_pickup() == []
    end

    @tag tasks_with_prerequisites: %{"A" => [], "B" => ["A", "D"], "D" => ["C"], "C" => []}
    test "Multiple tasks some with prerequisites => All tasks without prerequisites" do
      assert_equal_any_order(Tasks.available_for_pickup(), ["C", "A"])
    end
  end

  describe "All complete?" do
    @tag tasks_with_prerequisites: %{}
    test "No tasks left => Complete" do
      assert Tasks.all_complete?()
    end

    @tag tasks_with_prerequisites: %{"A" => []}
    test "Some tasks left => Not Complete" do
      refute Tasks.all_complete?()
    end

    @tag tasks_with_prerequisites: %{"C" => []}
    test "When last task remaining is completed, all tasks are completed" do
      refute Tasks.all_complete?()

      Tasks.complete_task("C")
      assert Tasks.all_complete?()
    end

    @tag tasks_with_prerequisites: %{"C" => ["A"], "A" => [], "B" => ["A"]}
    test "When all tasks are completed, all tasks are completed" do
      refute Tasks.all_complete?()

      Tasks.complete_task("A")
      refute Tasks.all_complete?()

      Tasks.complete_task("C")
      refute Tasks.all_complete?()

      Tasks.complete_task("B")
      assert Tasks.all_complete?()
    end

  end

  describe "Complete task:" do
    @tag tasks_with_prerequisites: %{"A" => ["B"], "B" => []}
    test "Task isn't completable => Raise error" do
      assert_raise RuntimeError, ~r/Can not complete task 'A'/, fn ->
        Tasks.complete_task("A")
      end
    end

    @tag tasks_with_prerequisites: %{"A" => ["C"], "C" => []}
    test "Unlock tasks depending on the completed task" do
      refute Enum.member?(Tasks.available_for_pickup(), "A")
      Tasks.complete_task("C")
      assert Enum.member?(Tasks.available_for_pickup(), "A")
    end

    @tag tasks_with_prerequisites: %{"A" => ["C", "D"], "C" => [], "D" => []}
    test "Task isn't in the list of available for pickup anymore" do
      assert_equal_any_order Tasks.available_for_pickup(), ["C", "D"]
      Tasks.complete_task("C")
      assert_equal_any_order Tasks.available_for_pickup(), ["D"]
    end


  end

  describe "Generate list of steps" do
    @tag tasks_with_prerequisites: %{"B" => [], "C" => [], "E" => []}
    test "Is list of completed tasks in order" do
      Tasks.complete_task("C")
      Tasks.complete_task("B")
      Tasks.complete_task("E")
      assert Tasks.generate_steps() == ["C", "B", "E"]
    end
  end
end
