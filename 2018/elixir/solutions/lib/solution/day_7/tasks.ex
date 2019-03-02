defmodule Solution.Day7.Tasks do
  use GenServer

  def start_link(tasks_with_prerequisites) when is_map(tasks_with_prerequisites) do
    GenServer.start_link(__MODULE__, tasks_with_prerequisites, name: __MODULE__)
  end

  def available_for_pickup() do
    GenServer.call(__MODULE__, :available_for_pickup)
  end

  def complete?() do
    GenServer.call(__MODULE__, :complete?)
  end

  def complete_task(task) do
    ensure_completable(task)
    GenServer.cast(__MODULE__, {:complete_task, task})
  end

  defp ensure_completable(task) do
    available_for_pickup = GenServer.call(__MODULE__, :available_for_pickup)

    if not Enum.member?(available_for_pickup, task) do
      raise "Can not complete task '#{task}'"
    end
  end

  def generate_steps() do
    GenServer.call(__MODULE__, :generate_steps)
  end

  ## GenServer Callbacks ########################################################
  @impl true
  def init(tasks_with_prerequisites) do
    {:ok, %{tasks_with_prerequisites: tasks_with_prerequisites, completed_tasks: []}}
  end

  @impl true
  def handle_call(
        :available_for_pickup,
        _from,
        %{tasks_with_prerequisites: tasks_with_prerequisites} = state
      ) do
    available_for_pickup =
      tasks_with_prerequisites
      |> Enum.filter(fn {_task, prerequisites} -> prerequisites == [] end)
      |> Enum.map(fn {task, []} -> task end)

    {:reply, available_for_pickup, state}
  end

  @impl true
  def handle_call(:generate_steps, _from, %{completed_tasks: completed_tasks} = state) do
    {:reply, Enum.reverse(completed_tasks), state}
  end

  @impl true
  def handle_call(
        :complete?,
        _from,
        %{tasks_with_prerequisites: tasks_with_prerequisites} = state
      ) do
    complete? = Enum.empty?(tasks_with_prerequisites)
    {:reply, complete?, state}
  end

  @impl true
  def handle_cast(
        {:complete_task, completed_task},
        %{
          completed_tasks: completed_tasks,
          tasks_with_prerequisites: tasks_with_prerequisites
        } = state
      ) do
    {:noreply,
     %{
       state
       | completed_tasks: [completed_task | completed_tasks],
         tasks_with_prerequisites:
           tasks_with_prerequisites
           |> Enum.map(&remove_completed_task_from_prerequisites(&1, completed_task))
           |> Enum.reject(&task_is_the_one_completed(&1, completed_task))
     }}
  end

  defp remove_completed_task_from_prerequisites({task, prerequisites}, completed_task) do
    {task, Enum.reject(prerequisites, &(&1 == completed_task))}
  end

  defp task_is_the_one_completed({task, _prerequisites}, completed_task) do
    task == completed_task
  end
end
