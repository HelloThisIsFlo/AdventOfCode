defmodule Solution.Day7.AvailableTasksQueue do
  use GenServer
  alias Solution.Day7.Behaviours.AvailableTasksQueue

  @behaviour AvailableTasksQueue

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args, name: __MODULE__)
  end

  @impl AvailableTasksQueue
  def add_tasks(newly_available_tasks) do
    GenServer.cast(__MODULE__, {:add_tasks, newly_available_tasks})
  end

  @impl AvailableTasksQueue
  def pop_next_task_to_pickup() do
    GenServer.call(__MODULE__, :pop_next_task_to_pickup)
  end

  ## GenServer callbacks ###################################
  @impl GenServer
  def init(:no_args) do
    {:ok, []}
  end

  @impl GenServer
  def handle_cast({:add_tasks, newly_available_tasks}, available_tasks) do
    available_tasks =
      (available_tasks ++ newly_available_tasks)
      |> Enum.uniq()
      |> Enum.sort()

    {:noreply, available_tasks}
  end

  @impl GenServer
  def handle_call(:pop_next_task_to_pickup, _from, available_tasks) do
    next_task_to_pickup =
      case List.first(available_tasks) do
        nil -> :no_available_tasks
        task -> task
      end

    {:reply, next_task_to_pickup, List.delete(available_tasks, next_task_to_pickup)}
  end
end
