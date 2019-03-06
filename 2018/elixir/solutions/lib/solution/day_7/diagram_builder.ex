defmodule Solution.Day7.DiagramBuilder do
  @behaviour Solution.Day7.Behaviours.DiagramBuilder

  @moduledoc """
  DEPRECATED - NOT FULLY FUNCTIONAL
  """

  defstruct current_time: 0,
            tasks_per_worker_per_time: %{}

  def start_link(_) do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  @impl true
  def set_current_time(time_in_sec) do
    Agent.update(__MODULE__, &Map.put(&1, :current_time, time_in_sec))
  end

  @impl true
  def notify_current_task(elf_name, current_task) do
    Agent.update(__MODULE__, fn state ->
      tasks_per_worker_per_time =
        state.tasks_per_worker_per_time
        |> Map.put_new_lazy(elf_name, fn -> %{} end)
        |> Map.update!(elf_name, fn elf_tasks_per_time ->
          elf_tasks_per_time
          |> Map.put(state.current_time, current_task)
        end)

      %{state | tasks_per_worker_per_time: tasks_per_worker_per_time}
    end)
  end

  @impl true
  def build_diagram() do
    tasks_per_worker_per_time = Agent.get(__MODULE__, &Map.get(&1, :tasks_per_worker_per_time))

    ""
    |> add_lines(header())
    |> add_lines(declarations(tasks_per_worker_per_time))
    |> add_lines("")
    |> add_lines(timings(tasks_per_worker_per_time))
    |> add_lines("")
    |> add_lines(footer())
  end

  defp add_lines(diagram, lines), do: diagram <> lines <> "\n"

  defp header(), do: "@startuml"
  defp footer(), do: "@enduml"

  defp declarations(tasks_per_worker_per_time) do
    tasks_per_worker_per_time
    |> Map.keys()
    |> Enum.map(fn worker ->
      "concise \"#{worker}\" as #{to_uml_name(worker)}"
    end)
    |> Enum.join("\n")
  end

  defp timings(tasks_per_worker_per_time) do
    workers =
      tasks_per_worker_per_time
      |> Map.keys()

    workers
    |> Enum.map(fn worker ->
      time_entries_for_worker =
        tasks_per_worker_per_time
        |> Map.get(worker)
        |> Enum.map(&to_task/1)
        |> IO.inspect()
        # |> Enum.chunk_by(fn {offset, task} -> task end)
        |> Enum.chunk_by(&(&1))
        # |> IO.inspect()
        |> Enum.map(fn entries_for_current_task ->
          total_offset =
            entries_for_current_task
            |> Enum.map(fn {offset, _task} -> offset end)
            |> Enum.sum()

          {_, task} =
            entries_for_current_task
            |> List.first()

          {total_offset, task}
        end)
        |> Enum.map(&to_time_entry/1)
        |> Enum.join("\n")

      "@#{to_uml_name(worker)}\n" <> time_entries_for_worker <> "\n"
    end)
    |> Enum.join("\n")

    # all_times =
  end

  defp to_uml_name(elf_name) do
    elf_name
    |> String.replace(" ", "_")
  end

  defp to_task({0, :no_current_task}), do: {0, "{hidden}"}
  defp to_task({0, task}), do: {0, "#{task}"}
  defp to_task({_time, :no_current_task}), do: {1, "{hidden}"}
  defp to_task({_time, task}), do: {1, "#{task}"}

  defp to_time_entry({0, task}), do: "0 is #{task}"
  defp to_time_entry({offset, task}), do: "+#{offset} is #{task}"
end
