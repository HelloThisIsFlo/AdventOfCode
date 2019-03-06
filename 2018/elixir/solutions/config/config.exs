use Mix.Config

config :solutions,
  tasks_module: Solution.Day7.Tasks,
  diagram_builder_module: Solution.Day7.DiagramBuilder

# Config for sandbox
config :solutions,
  formatter_module: RealFormatter

import_config "#{Mix.env()}.exs"
