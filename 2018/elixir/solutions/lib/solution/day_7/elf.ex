defmodule Solution.Day7.Elf do
  use GenServer
  alias Solution.Day7.Behaviours.Elf

  @behaviour Elf

  @tasks Application.fetch_env!(:solutions, :tasks_module)
  @diagram_builder Application.fetch_env!(:solutions, :diagram_builder_module)

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(elf_name) do
    GenServer.start_link(__MODULE__, elf_name)
  end

  @impl Elf
  def pick_up_new_work(elf_pid, callback_pid) do
    GenServer.cast(elf_pid, {:pick_up_new_work, callback_pid})
  end

  @impl Elf
  def do_work(elf_pid, callback_pid) do
    GenServer.cast(elf_pid, {:do_work, callback_pid})
  end

  ## GenServer callbacks ###################################
  @impl GenServer
  def init(elf_name) do
    {:ok, %{current_task: :no_current_task, elf_name: elf_name}}
  end

  @impl GenServer
  def handle_cast({:pick_up_new_work, callback_pid}, %{current_task: current_task} = state) do
    new_current_task = do_pick_up_new_work(current_task)
    # IO.inspect(new_current_task, label: "Pick up new work => New current task:")
    send(callback_pid, :done)
    {:noreply, %{state | current_task: new_current_task}}
  end

  @impl GenServer
  def handle_cast({:do_work, callback_pid}, state) do
    @diagram_builder.notify_current_task(state.elf_name, task_name(state.current_task))
    new_current_task = do_do_work(state.current_task)
    # IO.inspect(new_current_task, label: "Do work #{inspect(self())}  => New current task:")
    send(callback_pid, :done)
    {:noreply, %{state | current_task: new_current_task}}
  end

  defp do_pick_up_new_work(current_task)

  defp do_pick_up_new_work(:no_current_task) do
    new_current_task =
      case @tasks.pop_next_task_to_pickup() do
        :no_more_tasks -> :no_current_task
        task -> %{task: task, complete: 0, duration: @tasks.duration(task)}
      end

    new_current_task
  end

  defp do_pick_up_new_work(%{duration: duration, complete: complete} = current_task)
       when complete < duration do
    current_task
  end

  defp do_pick_up_new_work(%{duration: duration, complete: complete})
       when complete >= duration do
    raise "Invalid state: Current task should never be completed"
  end

  defp do_do_work(:no_current_task), do: :no_current_task

  defp do_do_work(%{task: task, duration: duration, complete: complete} = current_task) do
    complete_after_work = complete + 1

    if complete_after_work == duration do
      @tasks.complete_task(task)
      :no_current_task
    else
      %{current_task | complete: complete_after_work}
    end
  end

  defp task_name(%{task: task}), do: task
  defp task_name(:no_current_task), do: :no_current_task
end
