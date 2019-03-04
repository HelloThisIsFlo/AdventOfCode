defmodule Solution.Day7.T do
  @type task :: String.t()
end

defmodule Solution.Day7.Behaviours do
  alias Solution.Day7.T

  defmodule Tasks do
    @callback available_for_pickup() :: [T.task()]
    @callback all_complete?() :: boolean()
    @callback complete_task(T.task()) :: :ok
    @callback generate_steps() :: [T.task()]
  end

  defmodule AvailableTasksQueue do
    @callback add_tasks([T.task()]) :: :ok
    @callback pop_next_task_to_pickup() :: T.task()
  end

  defmodule Elf do
    @type callback_pid :: pid()
    @callback pick_up_new_work(callback_pid()) :: :ok
    @callback do_work(callback_pid()) :: :ok
  end
end
