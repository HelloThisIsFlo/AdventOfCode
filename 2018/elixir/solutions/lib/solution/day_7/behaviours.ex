defmodule Solution.Day7.T do
  @type task :: String.t()
end

defmodule Solution.Day7.Behaviours do
  alias Solution.Day7.T

  defmodule Tasks do
    @callback pop_next_task_to_pickup() :: T.task()
    @callback all_complete?() :: boolean()
    @callback complete_task(T.task()) :: :ok
    @callback generate_steps() :: [T.task()]
    @callback duration(T.task()) :: non_neg_integer()
  end

  defmodule Elf do
    @type callback_pid :: pid()
    @type elf_pid :: pid()
    @callback pick_up_new_work(elf_pid(), callback_pid()) :: :ok
    @callback do_work(elf_pid(), callback_pid()) :: :ok
  end

  defmodule DiagramBuilder do
    @callback set_current_time(non_neg_integer()) :: :ok
    @callback notify_current_task(String.t, String.t | atom()) :: :ok
    @callback build_diagram() :: String.t
  end
end
