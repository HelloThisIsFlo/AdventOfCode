defmodule RunSolutions do
  use ExUnit.Case, async: false
  import Mox

  setup :set_mox_from_context

  setup_all do
    IO.puts("")
    IO.puts("Solutions to Advent of Code 2018")
    IO.puts("--------------------------------")
  end

  setup do
    Mox.stub_with(TasksMock, Solution.Day7.Tasks)
    Mox.stub_with(DBMock, Solution.Day7.DiagramBuilder)
    :ok
  end

  def read_input_for(day_module) do
    file_name =
      day_module
      |> Atom.to_string()
      |> String.downcase()
      |> Kernel.<>(".txt")

    "../../inputs/"
    |> Path.join(file_name)
    |> File.read!()
  end

  def solve_and_print_solution({day_module, skip_reason}) do
    module_as_string =
      day_module
      |> Atom.to_string()
      |> String.capitalize()

    IO.puts("")
    IO.puts("Skipping #{module_as_string}: #{skip_reason}")
  end

  def solve_and_print_solution(day_module) do
    module_as_string =
      day_module
      |> Atom.to_string()
      |> String.capitalize()

    day_module_full_name =
      "Elixir.Solution."
      |> Kernel.<>(module_as_string)
      |> String.to_existing_atom()

    input_as_string = read_input_for(day_module)

    IO.puts("")

    IO.puts(
      "#{module_as_string}.1: " <> apply(day_module_full_name, :solve_part_1, [input_as_string])
    )

    IO.puts(
      "#{module_as_string}.2: " <> apply(day_module_full_name, :solve_part_2, [input_as_string])
    )
  end

  @tag :skip
  test "Solve All" do
    [
      :day1,
      :day2,
      {:day3, "Too long"},
      :day4,
      {:day5, "Too long"},
      {:day6, "Too long"},
      :day7,
      :day8,
      {:day9, "Too long"},
      {:day10, "Too long"}
    ]
    |> Enum.each(&solve_and_print_solution/1)
  end
end
