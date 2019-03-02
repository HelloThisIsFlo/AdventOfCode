defmodule Solution.Day7 do
  require Logger

  @moduledoc """
  Solution to: https://adventofcode.com/2018/day/7
  """

  @behaviour Solution

  @type task :: String.t()
  @type prerequisite :: task()
  @type condition :: {task(), prerequisite()}

  @doc """
  """
  def solve_part_1(input_as_string) do
    conditions =
      input_as_string
      |> parse_conditions()

    all_tasks =
      conditions
      |> Enum.flat_map(fn {task, prerequisite} -> [task, prerequisite] end)
      |> MapSet.new()
      |> MapSet.to_list()

    tasks_with_prerequisites =
      conditions
      |> Enum.group_by(
        fn {task, _prerequisite} -> task end,
        fn {_task, prerequisite} -> prerequisite end
      )

    all_tasks_with_prerequisites_sorted_alphabetically =
      all_tasks
      |> Enum.reduce(tasks_with_prerequisites, fn task, all_tasks_with_prerequisites ->
        Map.put_new(all_tasks_with_prerequisites, task, [])
      end)
      |> Enum.sort_by(fn {task, _list_of_prerequisites} -> task end)

    all_tasks_with_prerequisites_sorted_alphabetically
    |> build_list_of_steps()
    |> Enum.join()
  end

  defp build_list_of_steps(all_tasks_with_prerequisites_sorted_alphabetically),
    do: do_build_list_of_steps([], nil, all_tasks_with_prerequisites_sorted_alphabetically)
  defp do_build_list_of_steps(steps_in_reverse_order, previous_step, tasks_with_prerequisites)
  defp do_build_list_of_steps(steps_in_reverse_order, previous_step, [{previous_step, []}]),
    do: Enum.reverse(steps_in_reverse_order)
  defp do_build_list_of_steps([], nil, tasks_with_prerequisites) do
    first_task = find_next_task(tasks_with_prerequisites)
    do_build_list_of_steps([first_task], first_task, tasks_with_prerequisites)
  end
  defp do_build_list_of_steps(steps_in_reverse_order, previous_step, tasks_with_prerequisites) do
    tasks_with_prerequisites_after_previous_step =
      tasks_with_prerequisites
      |> Enum.reject(fn {task, _} -> task == previous_step end)
      |> Enum.map(fn {task, list_of_prerequisites} ->
        {task, Enum.reject(list_of_prerequisites, &(&1 == previous_step))}
      end)

    next_task = find_next_task(tasks_with_prerequisites_after_previous_step)

    do_build_list_of_steps(
      [next_task | steps_in_reverse_order],
      next_task,
      tasks_with_prerequisites_after_previous_step
    )
  end

  defp find_next_task(list_of_prerequisites_sorted_alphabetically) do
    next_task =
      list_of_prerequisites_sorted_alphabetically
      |> Enum.find_value(:no_next_task, fn {task, list_of_prerequisites} ->
        if Enum.empty?(list_of_prerequisites) do
          task
        else
          false
        end
      end)
      |> ensure_no_deadlock()

    Logger.info(
      "Next task: '#{next_task}' | Given tasks with prerequisites: #{
        inspect(list_of_prerequisites_sorted_alphabetically)
      }"
    )

    next_task
  end

  defp ensure_no_deadlock(:no_next_task), do: raise("Dead lock! Couldn't find a next task!")
  defp ensure_no_deadlock(next_task), do: next_task

  @spec parse_conditions(String.t()) :: [condition()]
  defp parse_conditions(input_as_string) do
    input_as_string
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn condition_as_string ->
      [prerequisite, task] =
        Regex.run(
          ~r/Step ([A-Z]) must be finished before step ([A-Z]) can begin./,
          condition_as_string,
          capture: :all_but_first
        )

      {task, prerequisite}
    end)
  end

  @spec build_list_of_prerequisites([condition()]) :: %{required(task()) => [prerequisite()]}
  defp build_list_of_prerequisites(conditions) do
    conditions
  end

  @doc """
  """
  def solve_part_2(input_as_string) do
    input_as_string
    "skip"
  end
end
