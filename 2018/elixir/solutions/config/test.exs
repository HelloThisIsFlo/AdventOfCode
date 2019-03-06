use Mix.Config

config :solutions,
  tasks_module: TasksMock,
  diagram_builder_module: DBMock

# Config for sandbox
config :solutions,
  formatter_module: FormatterMock
