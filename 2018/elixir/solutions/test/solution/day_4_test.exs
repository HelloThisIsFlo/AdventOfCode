defmodule Solution.Day4Test do
  use ExUnit.Case
  alias Solution.Day4
  alias Solution.Day4.LogEntry
  alias Solution.Day4.SleepPeriod

  describe "LogEntry Parsing" do
    test "New guard entry" do
      assert LogEntry.from_string("[1518-11-01 00:00] Guard #10 begins shift") == %LogEntry{
               timestamp: ~N[1518-11-01 00:00:00],
               value: {:new_guard, 10}
             }
    end

    test "Sleep start entry" do
      assert LogEntry.from_string("[1518-11-01 01:10] falls asleep") == %LogEntry{
               timestamp: ~N[1518-11-01 01:10:00],
               value: {:sleep, :start}
             }
    end

    test "Sleep end entry" do
      assert LogEntry.from_string("[1518-11-01 02:04] wakes up") == %LogEntry{
               timestamp: ~N[1518-11-01 02:04:00],
               value: {:sleep, :end}
             }
    end
  end

  describe "SleepPeriod" do
    test "Minutes asleep" do
      assert SleepPeriod.minutes_asleep(%SleepPeriod{
               start: ~N[1500-01-01 00:24:00],
               end: ~N[1500-01-01 00:27:00]
             }) == [24, 25, 26]

      assert SleepPeriod.minutes_asleep(%SleepPeriod{
               start: ~N[1500-01-01 00:27:00],
               end: ~N[1500-01-01 00:27:00]
             }) == []

      assert SleepPeriod.minutes_asleep(%SleepPeriod{
               start: ~N[1500-01-01 00:26:00],
               end: ~N[1500-01-01 00:27:00]
             }) == [26]
    end
  end

  describe "Part 1" do
    test "Example from Problem Statement" do
      assert "240" ==
               Day4.solve_part_1("""
               [1518-11-01 00:00] Guard #10 begins shift
               [1518-11-01 00:05] falls asleep
               [1518-11-01 00:25] wakes up
               [1518-11-01 00:30] falls asleep
               [1518-11-01 00:55] wakes up
               [1518-11-01 23:58] Guard #99 begins shift
               [1518-11-02 00:40] falls asleep
               [1518-11-02 00:50] wakes up
               [1518-11-03 00:05] Guard #10 begins shift
               [1518-11-03 00:24] falls asleep
               [1518-11-03 00:29] wakes up
               [1518-11-04 00:02] Guard #99 begins shift
               [1518-11-04 00:36] falls asleep
               [1518-11-04 00:46] wakes up
               [1518-11-05 00:03] Guard #99 begins shift
               [1518-11-05 00:45] falls asleep
               [1518-11-05 00:55] wakes up
               """)
    end

    test "Entries in random order" do
      assert "240" ==
               Day4.solve_part_1("""
               [1518-11-04 00:02] Guard #99 begins shift
               [1518-11-01 00:00] Guard #10 begins shift
               [1518-11-02 00:40] falls asleep
               [1518-11-03 00:29] wakes up
               [1518-11-04 00:36] falls asleep
               [1518-11-05 00:03] Guard #99 begins shift
               [1518-11-02 00:50] wakes up
               [1518-11-03 00:05] Guard #10 begins shift
               [1518-11-01 00:05] falls asleep
               [1518-11-01 00:25] wakes up
               [1518-11-01 00:55] wakes up
               [1518-11-01 23:58] Guard #99 begins shift
               [1518-11-01 00:30] falls asleep
               [1518-11-03 00:24] falls asleep
               [1518-11-04 00:46] wakes up
               [1518-11-05 00:55] wakes up
               [1518-11-05 00:45] falls asleep
               """)
    end

    test "Guard didn't sleep a specific night" do
      assert "240" ==
               Day4.solve_part_1("""
               [1518-11-01 00:00] Guard #10 begins shift
               [1518-11-01 00:05] falls asleep
               [1518-11-01 00:25] wakes up
               [1518-11-01 00:30] falls asleep
               [1518-11-01 00:55] wakes up
               [1518-11-01 23:58] Guard #99 begins shift
               [1518-11-03 00:05] Guard #10 begins shift
               [1518-11-03 00:24] falls asleep
               [1518-11-03 00:29] wakes up
               [1518-11-04 00:02] Guard #99 begins shift
               [1518-11-04 00:36] falls asleep
               [1518-11-04 00:46] wakes up
               [1518-11-05 00:03] Guard #99 begins shift
               [1518-11-05 00:45] falls asleep
               [1518-11-05 00:55] wakes up
               """)
    end
  end

  # describe "Part 2" do
  #   test "Example from Problem Statement" do
  #     assert "3" ==
  #              Day3.solve_part_2("""
  #              #1 @ 1,3: 4x4
  #              #2 @ 3,1: 4x4
  #              #3 @ 5,5: 2x2
  #              """)
  #   end

  #   test "Old version" do
  #     assert "3" ==
  #              Day3.solve_part_2_old_version("""
  #              #1 @ 1,3: 4x4
  #              #2 @ 3,1: 4x4
  #              #3 @ 5,5: 2x2
  #              """)
  #   end
  # end
end
