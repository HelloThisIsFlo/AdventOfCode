defmodule RunSolutions do
  use ExUnit.Case

  setup_all do
    IO.puts("")
    IO.puts("Solutions to Advent of Code 2018")
    IO.puts("--------------------------------")
  end

  def solve_and_print_solution(day_module) do
    module_as_string =
      day_module
      |> Atom.to_string()
      |> String.capitalize()

    day_module_full_name = String.to_existing_atom("Elixir.Solution." <> module_as_string)

    IO.puts("")
    IO.puts("#{module_as_string}.1: " <> apply(day_module_full_name, :solve_part_1, []))
    IO.puts("#{module_as_string}.2: " <> apply(day_module_full_name, :solve_part_2, []))
  end

  @tag :skip
  test "Solve All" do
    [
      :day1,
      :day2,
    ] |> Enum.each(&solve_and_print_solution/1)
  end
end
