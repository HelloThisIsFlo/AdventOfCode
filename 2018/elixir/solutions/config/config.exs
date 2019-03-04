use Mix.Config

# Config for sandbox
config :solutions,
  formatter_module: RealFormatter

import_config "#{Mix.env()}.exs"
