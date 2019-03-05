defmodule Solution.Day7.TasksTest do
  use ExUnit.Case
  alias Solution.Day7.Tasks

  def assert_equal_any_order(list1, list2), do: assert(Enum.sort(list1) == Enum.sort(list2))

  setup context do
    Tasks.start_link(context[:tasks_with_prerequisites])
    :ok
  end

  describe "Pop next task to pickup =>" do
    @tag tasks_with_prerequisites: %{}
    test "No tasks => No more task to pickup" do
      assert Tasks.pop_next_task_to_pickup() == :no_more_tasks
    end

    @tag tasks_with_prerequisites: %{"A" => ["C"]}
    test "Some tasks, all with prerequisite => Raise error" do
      assert_raise RuntimeError, ~r/Deadlock/, fn ->
        Tasks.pop_next_task_to_pickup()
      end
    end

    @tag tasks_with_prerequisites: %{"C" => [], "A" => []}
    test "Multiple available tasks => Return in alphabetical order" do
      assert Tasks.pop_next_task_to_pickup() == "A"
      assert Tasks.pop_next_task_to_pickup() == "C"
      assert Tasks.pop_next_task_to_pickup() == :no_more_tasks
    end

    @tag tasks_with_prerequisites: %{"C" => [], "B" => ["C"]}
    test "Multiple available tasks some with prerequisites => Return only those w/o prerequisites" do
      assert Tasks.pop_next_task_to_pickup() == "C"
      assert Tasks.pop_next_task_to_pickup() == :no_more_tasks
    end

    @tag tasks_with_prerequisites: %{"C" => [], "B" => ["C"]}
    test "Complete task => Unlocks depending tasks" do
      assert Tasks.pop_next_task_to_pickup() == "C"
      assert Tasks.pop_next_task_to_pickup() == :no_more_tasks
      Tasks.complete_task("C")
      assert Tasks.pop_next_task_to_pickup() == "B"
      assert Tasks.pop_next_task_to_pickup() == :no_more_tasks
    end

    @tag tasks_with_prerequisites: %{"C" => []}
    test "Completed task can not be picked up" do
      Tasks.complete_task("C")
      assert Tasks.pop_next_task_to_pickup() == :no_more_tasks
    end
  end

  describe "All complete? =>" do
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

  describe "Complete task: =>" do
    @tag tasks_with_prerequisites: %{"A" => ["B"], "B" => []}
    test "Task isn't completable => Raise error" do
      assert_raise RuntimeError, ~r/Can not complete task 'A'/, fn ->
        Tasks.complete_task("A")
      end
    end
  end

  describe "Generate list of steps =>" do
    @tag tasks_with_prerequisites: %{"B" => [], "C" => [], "E" => []}
    test "Is list of completed tasks in order" do
      Tasks.complete_task("C")
      Tasks.complete_task("B")
      Tasks.complete_task("E")
      assert Tasks.generate_steps() == ["C", "B", "E"]
    end
  end

  describe "Duration is position in alphabet + 60 =>" do
    @tag tasks_with_prerequisites: %{}
    test "'Q' - letter 17" do
      assert Tasks.duration("Q") == 17 + 60
    end

    @tag tasks_with_prerequisites: %{}
    test "'A' - letter 1" do
      assert Tasks.duration("A") == 1 + 60
    end
  end
end
