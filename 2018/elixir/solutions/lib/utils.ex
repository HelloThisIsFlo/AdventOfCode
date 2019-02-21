defmodule Solution.Utils do
  require Logger

  def log_and_passthrough(thing_to_passthrough, log_message) do
    Logger.info(log_message)
    thing_to_passthrough
  end
end
