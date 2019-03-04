defmodule Sandbox do
  @formatter Application.fetch_env!(:solutions, :formatter_module)

  def hello(name) do
    @formatter.format_hello(name)
  end
end

defmodule Formatter do
  @callback format_hello(String.t()) :: String.t()
end

defmodule RealFormatter do
  @behaviour Formatter

  @impl Formatter
  def format_hello(name) do
    "Hello #{name}"
  end
end
