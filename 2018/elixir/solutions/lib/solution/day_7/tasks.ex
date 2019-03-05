defmodule Solution.Day7.Tasks do
  use GenServer

  @behaviour Solution.Day7.Behaviours.Tasks

  def start_link(tasks_with_prerequisites) when is_map(tasks_with_prerequisites) do
    GenServer.start_link(__MODULE__, tasks_with_prerequisites, name: __MODULE__)
  end

  @impl true
  def available_for_pickup() do
    GenServer.call(__MODULE__, :available_for_pickup)
  end

  @impl true
  def all_complete?() do
    GenServer.call(__MODULE__, :all_complete?)
  end

  @impl true
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

  @impl true
  def generate_steps() do
    GenServer.call(__MODULE__, :generate_steps)
  end

  @impl true
  def duration(task) do
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
        :all_complete?,
        _from,
        %{tasks_with_prerequisites: tasks_with_prerequisites} = state
      ) do
    all_complete? = Enum.empty?(tasks_with_prerequisites)
    {:reply, all_complete?, state}
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
