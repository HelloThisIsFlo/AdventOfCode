defmodule Solution.Day7Test do
  use ExUnit.Case, async: false
  alias Solution.Day7
  alias Solution.Day7.DiagramBuilder
  alias Solution.Day7.Tasks
  import Mox

  setup :set_mox_from_context

  setup do
    Mox.stub_with(DBMock, Day7.DiagramBuilder)
    :ok
  end

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
    test "One task, one elf, duration is 1" do
      {:ok, elf_pid} = Solution.Day7.Elf.start_link(:no_args)

      TasksMock
      |> Mox.stub_with(Solution.Day7.Tasks)
      |> Mox.stub(:duration, fn _task -> 1 end)

      {steps, _} = Day7.solve_with_elves(%{"A" => []}, [elf_pid])
      assert steps == ["A"]
    end

    test "One task, one elf, duration > 1" do
      {:ok, elf_pid} = Solution.Day7.Elf.start_link(:no_args)

      TasksMock
      |> Mox.stub_with(Solution.Day7.Tasks)
      |> Mox.stub(:duration, fn _task -> 3 end)

      {steps, _} = Day7.solve_with_elves(%{"A" => []}, [elf_pid])
      assert steps == ["A"]
    end

    test "Example from part 1, 1 elf, duration is 1" do
      {:ok, elf_pid} = Solution.Day7.Elf.start_link(:no_args)

      TasksMock
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

      {steps, _} = Day7.solve_with_elves(conditions_from_part_1_example, [elf_pid])
      assert steps == ["C", "A", "B", "D", "F", "E"]
    end

    test "Example from part 1, 1 elf, duration > 3" do
      {:ok, elf_pid} = Solution.Day7.Elf.start_link(:no_args)

      TasksMock
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

      {steps, _} = Day7.solve_with_elves(conditions_from_part_1_example, [elf_pid])
      assert steps == ["C", "A", "B", "D", "F", "E"]
    end

    test "Example from part 1, 3 elf, duration 60 + position in alphabet" do
      {:ok, elf_pid_1} = Solution.Day7.Elf.start_link(:no_args)
      {:ok, elf_pid_2} = Solution.Day7.Elf.start_link(:no_args)
      {:ok, elf_pid_3} = Solution.Day7.Elf.start_link(:no_args)

      elves_pids = [elf_pid_1, elf_pid_2, elf_pid_3]

      TasksMock
      |> Mox.stub_with(Solution.Day7.Tasks)

      conditions_from_part_1_example = %{
        "A" => ["C"],
        "B" => ["A"],
        "C" => [],
        "D" => ["A"],
        "E" => ["B", "D", "F"],
        "F" => ["C"]
      }

      {steps, _} = Day7.solve_with_elves(conditions_from_part_1_example, elves_pids)
      assert steps == ["C", "A", "F", "B", "D", "E"]
    end
  end

  describe "Part 2" do
    test "Example from Problem Statement" do
      TasksMock
      |> Mox.stub_with(Tasks)
      |> Mox.stub(:duration, fn task -> Tasks.duration(task) - 60 end)

      assert "15" ==
               Day7.solve_part_2(
                 """
                 Step C must be finished before step A can begin.
                 Step C must be finished before step F can begin.
                 Step A must be finished before step B can begin.
                 Step A must be finished before step D can begin.
                 Step B must be finished before step E can begin.
                 Step D must be finished before step E can begin.
                 Step F must be finished before step E can begin.
                 """,
                 2
               )
    end

    @tag :skip
    test "Write Diagram" do
      TasksMock
      |> Mox.stub_with(Tasks)
      |> Mox.stub(:duration, fn task -> Tasks.duration(task) - 60 end)

      Day7.solve_part_2(
        """
        Step C must be finished before step A can begin.
        Step C must be finished before step F can begin.
        Step A must be finished before step B can begin.
        Step A must be finished before step D can begin.
        Step B must be finished before step E can begin.
        Step D must be finished before step E can begin.
        Step F must be finished before step E can begin.
        """,
        5
      )

      diagram = DiagramBuilder.build_diagram()
      File.write!("test.puml", diagram)
    end
  end
end
