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
  """
  alias __MODULE__.LogEntry

  @behaviour Solution

  defmodule LogEntry do
    @type id() :: non_neg_integer()
    @type guard_value() :: {:new_guard, id()}
    @type sleep_value() :: {:sleep, :start} | {:sleep, :end}
    @type t() :: %__MODULE__{
            timestamp: NaiveDateTime.t(),
            value: guard_value() | sleep_value()
          }
    defstruct [:timestamp, :value]

    def from_string(entry_as_string) do
      ~r/\[(?<year>\d\d\d\d)-(?<month>\d\d)-(?<day>\d\d) (?<hour>\d\d):(?<min>\d\d)\] (?<value_as_string>.+)/
      |> Regex.named_captures(entry_as_string)
      |> parse_to_int("year")
      |> parse_to_int("month")
      |> parse_to_int("day")
      |> parse_to_int("hour")
      |> parse_to_int("min")
      |> parse_value()
      |> to_log_entry()
    end

    defp parse_to_int(named_captures, capture_name) do
      parsed_to_int =
        named_captures
        |> Map.get(capture_name)
        |> String.to_integer()

      %{named_captures | capture_name => parsed_to_int}
    end

    defp parse_value(%{"value_as_string" => value_as_string} = named_captures) do
      named_captures
      |> Map.put("value", do_parse_value(value_as_string))
    end

    defp do_parse_value("falls asleep"), do: {:sleep, :start}
    defp do_parse_value("wakes up"), do: {:sleep, :end}

    defp do_parse_value(new_guard_value) do
      guard_id =
        ~r/Guard #(?<guard_id>\d+) begins shift/
        |> Regex.named_captures(new_guard_value)
        |> Map.get("guard_id")
        |> String.to_integer()

      {:new_guard, guard_id}
    end

    defp to_log_entry(%{
           "year" => y,
           "month" => m,
           "day" => d,
           "hour" => h,
           "min" => min,
           "value" => val
         }) do
      with {:ok, timestamp} <- NaiveDateTime.new(y, m, d, h, min, 0) do
        %LogEntry{
          timestamp: timestamp,
          value: val
        }
      end
    end

    @spec before?(LogEntry.t(), LogEntry.t()) :: boolean()
    def before?(%LogEntry{timestamp: time1}, %LogEntry{timestamp: time2}) do
      case NaiveDateTime.compare(time1, time2) do
        :gt -> false
        :eq -> true
        :lt -> true
      end
    end

    @spec new_guard_entry?(LogEntry.t()) :: boolean()
    def new_guard_entry?(%LogEntry{value: {:new_guard, _}}), do: true
    def new_guard_entry?(_), do: false

    @spec sleep_entry?(LogEntry.t(), atom() | nil) :: boolean()
    def sleep_entry?(log_entry, type \\ nil)
    def sleep_entry?(%LogEntry{value: {:sleep, _}}, nil), do: true
    def sleep_entry?(%LogEntry{value: {:sleep, type}}, expected_type), do: type == expected_type
    def sleep_entry?(_, _), do: false

    @type reason :: String.t()
    @spec guard_id(any()) :: non_neg_integer() | {:error, reason}
    def guard_id(%LogEntry{value: {:new_guard, id}}), do: id
    def guard_id(_), do: {:error, :not_a_guard_entry}
  end

  defmodule SleepPeriod do
    @type t() :: %__MODULE__{
            start: NaiveDateTime.t(),
            end: NaiveDateTime.t()
          }
    defstruct [:start, :end]

    def duration(%SleepPeriod{start: start_time, end: end_time}) when start_time > end_time,
      do: raise("Start time after End time!!")

    def duration(%SleepPeriod{start: start_time, end: end_time}) do
      NaiveDateTime.diff(end_time, start_time, :second)
    end

    @spec minutes_asleep(Solution.Day4.SleepPeriod.t()) :: [integer()]
    def minutes_asleep(%SleepPeriod{start: start_time, end: end_time}) when start_time > end_time,
      do: raise("Start time after End time!!")

    def minutes_asleep(%SleepPeriod{start: start_time, end: end_time})
        when start_time == end_time,
        do: []

    def minutes_asleep(%SleepPeriod{start: start_time, end: end_time}) do
      Enum.to_list(start_time.minute..(end_time.minute - 1))
    end
  end

  @doc """
  Solves:
   - Which guard falls asleep the longest?
   - During which minute was that guard most often asleep?

  Naive first solution:
  Find each guard id
  For each guard, find number of minutes asleep
  Find guard with most hours asleep
  Find minute most often asleep for this particular guard
  """
  def solve_part_1(input_as_string) do
    sleep_entries_by_guard =
      input_as_string
      |> parse_and_sort_log_entries()
      |> group_sleep_entries_by_guard()

    guard_most_asleep = find_guard_most_asleep(sleep_entries_by_guard)

    minute_most_often_asleep =
      find_minute_most_often_asleep(sleep_entries_by_guard, guard_most_asleep)

    (guard_most_asleep * minute_most_often_asleep)
    |> Integer.to_string()
  end

  defp parse_and_sort_log_entries(input_as_string) do
    input_as_string
    |> String.split(~r/\n/)
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&LogEntry.from_string/1)
    |> Enum.sort(&LogEntry.before?/2)
  end

  defp group_sleep_entries_by_guard(log_entries) do
    log_entries
    |> Enum.reduce(
      [current_guard: nil, sleep_entries_by_guard: %{}],
      &do_group_sleep_entries_by_guard/2
    )
    |> Keyword.get(:sleep_entries_by_guard)
  end

  defp do_group_sleep_entries_by_guard(log_entry, accumulator_as_keyword_list)
  defp do_group_sleep_entries_by_guard(
         %{value: {:new_guard, new_guard_id}} = _new_guard_entry,
         current_guard: _,
         sleep_entries_by_guard: sleep_entries_by_guard
       ) do
    [current_guard: new_guard_id, sleep_entries_by_guard: sleep_entries_by_guard]
  end
  defp do_group_sleep_entries_by_guard(
         sleep_entry,
         current_guard: current_guard,
         sleep_entries_by_guard: sleep_entries_by_guard
       ) do
    sleep_entries_by_guard =
      sleep_entries_by_guard
      |> Map.update(
        current_guard,
        [sleep_entry],
        fn sleep_entries_for_current_guard ->
          sleep_entries_for_current_guard ++ [sleep_entry]
        end
      )

    [current_guard: current_guard, sleep_entries_by_guard: sleep_entries_by_guard]
  end
  defp do_group_sleep_entries_by_guard(
         _sleep_entry,
         current_guard: nil,
         sleep_entries_by_guard: _
       ) do
    raise "Sleep entry was found but there are currently no guards working !!"
  end

  defp find_guard_most_asleep(sleep_entries_by_guard) do
    {guard_with_most_asleep, _total_time_asleep} =
      sleep_entries_by_guard
      |> Enum.max_by(fn {_guard_id, sleep_entries_for_guard} ->
        time_slept =
          sleep_entries_for_guard
          |> map_sleep_entries_to_sleep_periods()
          |> Enum.map(&SleepPeriod.duration/1)
          |> Enum.sum()

        time_slept
      end)

    guard_with_most_asleep
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

  defp find_minute_most_often_asleep(sleep_entries_by_guard, candidate_guard_id) do
    {minute_most_often_asleep, _days_asleep_at_minute} =
      sleep_entries_by_guard
      |> Map.get(candidate_guard_id)
      |> map_sleep_entries_to_sleep_periods()
      |> Enum.flat_map(&SleepPeriod.minutes_asleep/1)
      |> Enum.reduce(%{}, fn minute, occurences_of_each_minute ->
        Map.update(occurences_of_each_minute, minute, 1, &(&1 + 1))
      end)
      |> Enum.max_by(fn {_minute, days_asleep_at_minute} -> days_asleep_at_minute end)

    minute_most_often_asleep
  end


  @doc """
  Solves: "What is the ID of the only claim that doesn't overlap?"
  """
  def solve_part_2(input_as_string) do
    input_as_string
    |> parse_and_sort_log_entries()

    "not done yet"
  end
end
