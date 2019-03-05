defmodule Solution.Day7.AvailableTasksQueueTest do
  use ExUnit.Case
  alias Solution.Day7.AvailableTasksQueue

  setup do
    AvailableTasksQueue.start_link(:no_args)
    :ok
  end

  test "No tasks to pickup" do
    assert AvailableTasksQueue.pop_next_task_to_pickup() == :no_available_tasks
  end

  describe "Single task available" do
    setup do
      AvailableTasksQueue.add_tasks(["A"])
    end

    test "Next task is the one available" do
      assert AvailableTasksQueue.pop_next_task_to_pickup() == "A"
    end

    test "Only one task is available" do
      _first_call_to_pop = AvailableTasksQueue.pop_next_task_to_pickup()
      second_call_to_pop = AvailableTasksQueue.pop_next_task_to_pickup()
      assert second_call_to_pop == :no_available_tasks
    end
  end

  describe "Multiple tasks available" do
    setup do
      AvailableTasksQueue.add_tasks(["C", "A"])
      AvailableTasksQueue.add_tasks(["B"])
    end

    test "Tasks are popped in alphabetical order" do
      assert AvailableTasksQueue.pop_next_task_to_pickup() == "A"
      assert AvailableTasksQueue.pop_next_task_to_pickup() == "B"
      assert AvailableTasksQueue.pop_next_task_to_pickup() == "C"
      assert AvailableTasksQueue.pop_next_task_to_pickup() == :no_available_tasks
    end

    test "Duplicates are ignored" do
      AvailableTasksQueue.add_tasks(["B", "A"])

      assert AvailableTasksQueue.pop_next_task_to_pickup() == "A"
      assert AvailableTasksQueue.pop_next_task_to_pickup() == "B"
      assert AvailableTasksQueue.pop_next_task_to_pickup() == "C"
      assert AvailableTasksQueue.pop_next_task_to_pickup() == :no_available_tasks
    end
  end
end
