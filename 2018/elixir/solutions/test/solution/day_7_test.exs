defmodule Solution.Day7Test do
  use ExUnit.Case, async: false
  alias Solution.Day7

  # @moduletag capture_log: false

  describe "Part 1" do
    test "Example from Problem Statement" do
      assert "CABDFE" ==
               Day7.solve_part_1("""
               Step C must be finished before step A can begin.
               Step C must be finished before step F can begin.
               Step A must be finished before step B can begin.
               Step A must be finished before step D can begin.
               Step B must be finished before step E can begin.
               Step D must be finished before step E can begin.
               Step F must be finished before step E can begin.
               """)
    end
  end

  describe "Test solve with elves" do
    # @tag :skip
    test "One task, one elf, duration is 1" do
      {:ok, elf_pid} = Solution.Day7.Elf.start_link(:no_args)

      TasksMock
      |> Mox.allow(self(), elf_pid)
      |> Mox.stub_with(Solution.Day7.Tasks)
      |> Mox.stub(:duration, fn _task -> 1 end)

      assert Day7.solve_with_elves(%{"A" => []}, [elf_pid]) == ["A"]
    end

    test "One task, one elf, duration > 1" do
      {:ok, elf_pid} = Solution.Day7.Elf.start_link(:no_args)

      TasksMock
      |> Mox.allow(self(), elf_pid)
      |> Mox.stub_with(Solution.Day7.Tasks)
      |> Mox.stub(:duration, fn _task -> 3 end)

      assert Day7.solve_with_elves(%{"A" => []}, [elf_pid]) == ["A"]
    end

    test "Example from part 1, 1 elf, duration is 1" do
      {:ok, elf_pid} = Solution.Day7.Elf.start_link(:no_args)

      TasksMock
      |> Mox.allow(self(), elf_pid)
      |> Mox.stub_with(Solution.Day7.Tasks)
      |> Mox.stub(:duration, fn _task -> 1 end)

      conditions_from_part_1_example = %{
        "A" => ["C"],
        "B" => ["A"],
        "C" => [],
        "D" => ["A"],
        "E" => ["B", "D", "F"],
        "F" => ["C"]
      }

      assert Day7.solve_with_elves(conditions_from_part_1_example, [elf_pid]) ==
               ["C", "A", "B", "D", "F", "E"]
    end

    @tag :skip
    test "Example from part 1, 1 elf, duration > 1" do
      {:ok, elf_pid} = Solution.Day7.Elf.start_link(:no_args)

      TasksMock
      |> Mox.allow(self(), elf_pid)
      |> Mox.stub_with(Solution.Day7.Tasks)
      |> Mox.stub(:duration, fn _task -> 3 end)

      conditions_from_part_1_example = %{
        "A" => ["C"],
        "B" => ["A"],
        "C" => [],
        "D" => ["A"],
        "E" => ["B", "D", "F"],
        "F" => ["C"]
      }

      assert Day7.solve_with_elves(conditions_from_part_1_example, [elf_pid]) ==
               ["C", "A", "B", "D", "F", "E"]
    end
  end

  describe "Part 2" do
    @tag :skip
    test "Example from Problem Statement" do
      assert "??" ==
               Day7.solve_part_2("""
               """)
    end
  end
end
