defmodule Solution.Day7.ElfTest do
  use ExUnit.Case
  alias Solution.Day7.Elf

  @elf_name "Frank"

  setup do
    Elf.start_link(:no_args)
    :ok
  end

  describe "Pick up new work => Current task already complete (invalid state) =>" do
    test "Raise error" do
      assert_raise RuntimeError, fn ->
        callback_pid = self()
        already_completed_task = %{task: "A", duration: 61, complete: 61}
        state = %{current_task: already_completed_task}

        Elf.handle_cast({:pick_up_new_work, callback_pid}, state)
      end
    end
  end

  describe "Pick up new work => Current task not complete =>" do
    setup context do
      callback_pid = self()
      not_completed_task = %{task: "A", duration: 61, complete: 30}
      state = %{current_task: not_completed_task}

      {:noreply, resulting_state} = Elf.handle_cast({:pick_up_new_work, callback_pid}, state)
      new_current_task = resulting_state[:current_task]

      context
      |> Map.put(:previous_current_task, not_completed_task)
      |> Map.put(:new_current_task, new_current_task)
    end

    test "Send :done" do
      assert_receive :done
    end

    test "Didn't pick new task or progress completion", %{
      new_current_task: new,
      previous_current_task: previous
    } do
      assert new == previous
    end
  end

  describe "Pick up new work => No current task =>" do
    setup context do
      fake_duration = 12345

      TasksMock
      |> Mox.expect(:duration, 1, fn _task -> fake_duration end)
      |> Mox.expect(:pop_next_task_to_pickup, fn -> context[:next_task_to_pickup] end)

      callback_pid = self()
      state = %{current_task: :no_current_task}
      {:noreply, resulting_state} = Elf.handle_cast({:pick_up_new_work, callback_pid}, state)

      new_current_task = resulting_state[:current_task]

      context
      |> Map.put(:new_current_task, new_current_task)
      |> Map.put(:fake_duration, fake_duration)
    end

    @tag next_task_to_pickup: "A"
    test "Pick up available task", %{new_current_task: new_current_task} do
      assert new_current_task[:task] == "A"
    end

    @tag next_task_to_pickup: "A"
    test "Reset completion to 0", %{new_current_task: new_current_task} do
      assert new_current_task[:complete] == 0
    end

    @tag next_task_to_pickup: "A"
    test "Send :done" do
      assert_receive :done
    end

    @tag next_task_to_pickup: "A"
    test "Duration is given by Task module", %{
      new_current_task: new_current_task,
      fake_duration: fake_duration
    } do
      assert new_current_task[:duration] == fake_duration
      Mox.verify!(TasksMock)
    end

    @tag next_task_to_pickup: :no_more_tasks
    test "No available tasks => Do not pick task", %{new_current_task: new_current_task} do
      assert new_current_task == :no_current_task
    end

    @tag next_task_to_pickup: :no_more_tasks
    test "No available tasks => Send :done" do
      assert_receive :done
    end
  end

  describe "Do work =>" do
    setup context do
      Mox.expect(TasksMock, :complete_task, 1, fn _task -> :ok end)

      Mox.stub(DBMock, :notify_current_task, fn elf_name, current_task ->
        send(self(), {:notify_current_task_called, elf_name, current_task})
      end)

      callback_pid = self()
      state = %{current_task: context[:current_task_before_work], elf_name: @elf_name}
      {:noreply, new_state} = Elf.handle_cast({:do_work, callback_pid}, state)

      context
      |> Map.put(:current_task_after_work, new_state[:current_task])
    end

    @tag current_task_before_work: %{task: "B", complete: 61, duration: 62}
    test "Current complete after work => Complete task" do
      # See setup - Expectation set with tags
      Mox.verify!(TasksMock)
    end

    @tag current_task_before_work: %{task: "B", complete: 61, duration: 62}
    test "Current complete after work => No more current task", %{
      current_task_after_work: current_task_after_work
    } do
      assert current_task_after_work == :no_current_task
    end

    @tag current_task_before_work: %{task: "B", complete: 61, duration: 62}
    test "Current complete after work => Send :done & notify Diagram Builder" do
      assert_receive :done
      assert_receive {:notify_current_task_called, @elf_name, "B"}
    end

    @tag current_task_before_work: %{task: "B", complete: 40, duration: 62}
    test "Current not complete after work => Move progress", %{
      current_task_before_work: current_task_before_work,
      current_task_after_work: current_task_after_work
    } do
      assert current_task_after_work[:complete] == current_task_before_work[:complete] + 1
    end

    @tag current_task_before_work: %{task: "B", complete: 40, duration: 62}
    test "Current not complete after work => Send :done & notify Diagram Builder" do
      assert_receive :done
      assert_receive {:notify_current_task_called, @elf_name, "B"}
    end

    @tag current_task_before_work: :no_current_task
    test "No current task => Send :done & notify Diagram Builder" do
      assert_receive :done
      assert_receive {:notify_current_task_called, @elf_name, :no_current_task}
    end
  end
end
