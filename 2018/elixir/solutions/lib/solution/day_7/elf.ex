defmodule Solution.Day7.Elf do
  use GenServer
  alias Solution.Day7.AvailableTasksQueue
  alias Solution.Day7.Behaviours.Elf

  @behaviour Elf

  @tasks Application.fetch_env!(:solutions, :tasks_module)

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args, name: __MODULE__)
  end

  @impl Elf
  @spec pick_up_new_work(any()) :: :ok
  def pick_up_new_work(callback_pid) do
    GenServer.cast(__MODULE__, {:pick_up_new_work, callback_pid})
  end

  @impl Elf
  def do_work(_callback_pid) do
    :ok
  end

  ## GenServer callbacks ###################################
  @impl GenServer
  def init(:no_args) do
    {:ok, []}
  end

  @impl GenServer
  def handle_cast({:pick_up_new_work, callback_pid}, %{current_task: current_task}) do
    new_current_task = do_pick_up_new_work(current_task)
    send(callback_pid, :done)
    {:noreply, %{current_task: new_current_task}}
  end

  @impl GenServer
  def handle_cast({:do_work, callback_pid}, %{current_task: current_task}) do
    new_current_task = do_do_work(current_task)
    send(callback_pid, :done)
    {:noreply, %{current_task: new_current_task}}
  end

  defp do_pick_up_new_work(current_task)

  defp do_pick_up_new_work(:no_current_task) do
    new_current_task =
      case AvailableTasksQueue.pop_next_task_to_pickup() do
        :no_available_tasks -> :no_current_task
        task -> %{task: task, complete: 0, duration: duration(task)}
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

  defp duration(task) do
    60 + position_in_alphabet(task)
  end

  defp position_in_alphabet(letter) do
    ?A..?Z
    |> Enum.to_list()
    |> List.to_string()
    |> String.split("", trim: true)
    |> Enum.find_index(&(&1 == String.upcase(letter)))
    |> Kernel.+(1)
  end
end
