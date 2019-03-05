defmodule Solution.Day7.Tasks do
  use GenServer

  @behaviour Solution.Day7.Behaviours.Tasks

  def start_link(tasks_with_prerequisites) when is_map(tasks_with_prerequisites) do
    GenServer.start_link(__MODULE__, tasks_with_prerequisites, name: __MODULE__)
  end

  @impl true
  def pop_next_task_to_pickup() do
    case GenServer.call(__MODULE__, :pop_next_task_to_pickup) do
      :deadlock -> raise "Deadlock!"
      next_task -> next_task
    end
  end

  @impl true
  def all_complete?() do
    GenServer.call(__MODULE__, :all_complete?)
  end

  @impl true
  def complete_task(task) do
    case GenServer.call(__MODULE__, {:complete_task, task}) do
      :ok -> :ok
      :not_completable -> raise "Can not complete task '#{task}'"
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
    {:ok,
     %{
       tasks_with_prerequisites: tasks_with_prerequisites,
       picked_up_tasks: [],
       completed_tasks: []
     }}
  end

  @impl true
  def handle_call(:generate_steps, _from, %{completed_tasks: completed_tasks} = state) do
    {:reply, Enum.reverse(completed_tasks), state}
  end

  @impl true
  def handle_call(:all_complete?, _from, state) do
    {:reply, all_complete?(state), state}
  end

  @impl true
  def handle_call({:complete_task, completed_task}, _from, state) do
    if not completable?(completed_task, state) do
      {:reply, :not_completable, state}
    else
      new_state =
        state
        |> Map.put(:completed_tasks, [completed_task | state[:completed_tasks]])
        |> Map.put(
          :tasks_with_prerequisites,
          state[:tasks_with_prerequisites]
          |> Enum.map(&remove_completed_task_from_prerequisites(&1, completed_task))
          |> Enum.reject(&task_is_the_one_completed(&1, completed_task))
        )

      {:reply, :ok, new_state}
    end
  end

  def handle_call(:pop_next_task_to_pickup, _from, state) do
    already_picked_up_tasks = state[:picked_up_tasks]

    available_to_be_picked_up =
      state[:tasks_with_prerequisites]
      |> Enum.filter(fn {_task, prerequisites} -> prerequisites == [] end)
      |> Enum.map(fn {task, _prerequisites} -> task end)

    deadlock? = deadlock?(available_to_be_picked_up, state)

    next_task_to_pickup =
      available_to_be_picked_up
      |> Enum.reject(&Enum.member?(already_picked_up_tasks, &1))
      |> List.first()

    response =
      case {deadlock?, next_task_to_pickup} do
        {true, _} -> :deadlock
        {false, nil} -> :no_more_tasks
        {false, next_task} -> next_task
      end

    new_state =
      if next_task_to_pickup do
        %{state | picked_up_tasks: [next_task_to_pickup | already_picked_up_tasks]}
      else
        state
      end

    {:reply, response, new_state}
  end

  defp deadlock?(available_to_be_picked_up, state)

  defp deadlock?([], state) do
    not all_complete?(state)
  end

  defp deadlock?(_, _), do: false

  defp completable?(task, state) do
    state[:tasks_with_prerequisites]
    |> Map.new()
    |> Map.get(task) == []
  end

  defp all_complete?(state) do
    Enum.empty?(state[:tasks_with_prerequisites])
  end

  defp remove_completed_task_from_prerequisites({task, prerequisites}, completed_task) do
    {task, Enum.reject(prerequisites, &(&1 == completed_task))}
  end

  defp task_is_the_one_completed({task, _prerequisites}, completed_task) do
    task == completed_task
  end
end
