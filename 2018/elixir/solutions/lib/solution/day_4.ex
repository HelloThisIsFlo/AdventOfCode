defmodule Solution.Day4 do
  @moduledoc """
  --- Part One ---
  As you search the closet for anything that might help, you discover that you're not the first person to
  want to sneak in. Covering the walls, someone has spent an hour starting every midnight for the past
  few months secretly observing this guard post! They've been writing down the ID of the one guard on
  duty that night - the Elves seem to have decided that one guard was enough for the overnight shift
  - as well as when they fall asleep or wake up while at their post (your puzzle input).

  For example, consider the following records, which have already been organized into chronological order:

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

  Timestamps are written using year-month-day hour:minute format. The guard falling asleep or
  waking up is always the one whose shift most recently started. Because all asleep/awake times
  are during the midnight hour (00:00 - 00:59), only the minute portion (00 - 59) is relevant
  for those events.

  Visually, these records show that the guards are asleep at these times:

  Date   ID   Minute
              000000000011111111112222222222333333333344444444445555555555
              012345678901234567890123456789012345678901234567890123456789
  11-01  #10  .....####################.....#########################.....
  11-02  #99  ........................................##########..........
  11-03  #10  ........................#####...............................
  11-04  #99  ....................................##########..............
  11-05  #99  .............................................##########.....
  The columns are Date, which shows the month-day portion of the relevant day; ID, which shows the
  guard on duty that day; and Minute, which shows the minutes during which the guard was asleep
  within the midnight hour. (The Minute column's header shows the minute's ten's digit in the first
  row and the one's digit in the second row.) Awake is shown as ., and asleep is shown as #.

  Note that guards count as asleep on the minute they fall asleep, and they count as awake on the
  minute they wake up. For example, because Guard #10 wakes up at 00:25 on 1518-11-01, minute 25
  is marked as awake.

  If you can figure out the guard most likely to be asleep at a specific time, you might be able to
  trick that guard into working tonight so you can have the best chance of sneaking in. You have two
  strategies for choosing the best guard/minute combination.

  Strategy 1: Find the guard that has the most minutes asleep. What minute does that guard spend asleep
  the most?

  In the example above, Guard #10 spent the most minutes asleep, a total of 50 minutes (20+25+5), while
  Guard #99 only slept for a total of 30 minutes (10+10+10). Guard #10 was asleep most during minute 24 (on two days, whereas any other minute the guard was asleep was only seen on one day).

  While this example listed the entries in chronological order, your entries are in the order you found
  them. You'll need to organize them before they can be analyzed.

  What is the ID of the guard you chose multiplied by the minute you chose? (In the above example, the
  answer would be 10 * 24 = 240.)


  --- Part Two ---
  Strategy 2: Of all guards, which guard is most frequently asleep on the same minute?

  In the example above, Guard #99 spent minute 45 asleep more than any other guard or minute - three
  times in total. (In all other cases, any guard spent any minute asleep at most twice.)

  What is the ID of the guard you chose multiplied by the minute you chose? (In the above example,
  the answer would be 99 * 45 = 4455.)
  """
  alias __MODULE__.LogEntry
  alias __MODULE__.SleepPeriod

  @behaviour Solution

  @doc """
  Solves:
   - Which guard falls asleep the longest?
   - During which minute was that guard most often asleep?
  """
  def solve_part_1(input_as_string) do
    sleep_entries_by_guard =
      input_as_string
      |> parse_and_sort_log_entries()
      |> LogEntry.group_sleep_entries_by_guard()

    %{
      guard: guard,
      minute_most_often_asleep: minute
    } = guard_most_asleep(sleep_entries_by_guard)

    Integer.to_string(guard * minute)
  end

  defp guard_most_asleep(sleep_entries_by_guard) do
    sleep_entries_by_guard
    |> Enum.map(fn {guard_id, sleep_entries_for_guard} ->
      sleep_periods_for_guard = map_sleep_entries_to_sleep_periods(sleep_entries_for_guard)

      %{
        guard: guard_id,
        minute_most_often_asleep:
          sleep_periods_for_guard
          |> minute_most_often_asleep()
          |> Map.get(:minute_most_often_asleep),
        total_sleep_time:
          sleep_periods_for_guard
          |> total_sleep_time()
      }
    end)
    |> Enum.max_by(fn %{total_sleep_time: total} -> total end)
  end

  defp total_sleep_time(sleep_periods) do
    sleep_periods
    |> Enum.map(&SleepPeriod.duration/1)
    |> Enum.sum()
  end

  defp minute_most_often_asleep(sleep_periods) do
    {minute, days_asleep_at_minute} =
      sleep_periods
      |> days_asleep_by_minute()
      |> Enum.max_by(fn {_minute, days_asleep_at_minute} ->
        days_asleep_at_minute
      end)

    %{minute_most_often_asleep: minute, days_asleep_at_minute: days_asleep_at_minute}
  end

  defp parse_and_sort_log_entries(input_as_string) do
    input_as_string
    |> String.split(~r/\n/)
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&LogEntry.from_string/1)
    |> Enum.sort(&LogEntry.before?/2)
  end

  defp map_sleep_entries_to_sleep_periods(sleep_entries) do
    sleep_entries
    |> Enum.reduce(
      [sleep_start_time: nil, sleep_periods: []],
      &do_map_sleep_entries_to_sleep_periods/2
    )
    |> Keyword.get(:sleep_periods)
  end
  defp do_map_sleep_entries_to_sleep_periods(%{timestamp: start_time, value: {:sleep, :start}},
         sleep_start_time: nil,
         sleep_periods: periods
       ) do
    [sleep_start_time: start_time, sleep_periods: periods]
  end
  defp do_map_sleep_entries_to_sleep_periods(%{timestamp: end_time, value: {:sleep, :end}},
         sleep_start_time: start_time,
         sleep_periods: periods
       ) do
    completed_period = %SleepPeriod{start: start_time, end: end_time}
    [sleep_start_time: nil, sleep_periods: periods ++ [completed_period]]
  end
  defp do_map_sleep_entries_to_sleep_periods(_, _) do
    raise("Invalid sleep entries sequence! Ensure every sleep start has a matching sleep end!")
  end

  defp days_asleep_by_minute(sleep_periods) do
    sleep_periods
    |> Enum.flat_map(&SleepPeriod.minutes_asleep/1)
    |> Enum.reduce(%{}, fn minute, occurences_of_each_minute ->
      Map.update(occurences_of_each_minute, minute, 1, &(&1 + 1))
    end)
  end

  @doc """
  Solves: "Of all guards, which guard is most frequently asleep on the same minute?"
  """
  def solve_part_2(input_as_string) do
    %{
      guard: guard_id,
      minute_most_often_asleep: minute_most_often_asleep,
      days_asleep_at_minute: _
    } =
      input_as_string
      |> parse_and_sort_log_entries()
      |> LogEntry.group_sleep_entries_by_guard()
      |> guard_most_frequently_asleep_on_the_same_minute()

    Integer.to_string(guard_id * minute_most_often_asleep)
  end

  defp guard_most_frequently_asleep_on_the_same_minute(sleep_entries_by_guard) do
    sleep_entries_by_guard
    |> Enum.map(fn {guard_id, sleep_entries_for_guard} ->
      {minute_most_often_asleep, days_asleep_at_minute} =
        sleep_entries_for_guard
        |> map_sleep_entries_to_sleep_periods()
        |> days_asleep_by_minute()
        |> Enum.max_by(fn {_minute, days_asleep_at_minute} ->
          days_asleep_at_minute
        end)

      %{
        guard: guard_id,
        minute_most_often_asleep: minute_most_often_asleep,
        days_asleep_at_minute: days_asleep_at_minute
      }
    end)
    |> Enum.max_by(fn %{days_asleep_at_minute: days_asleep_at_minute} -> days_asleep_at_minute end)
  end
end
