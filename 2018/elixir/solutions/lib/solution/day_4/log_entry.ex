defmodule Solution.Day4.LogEntry do
  alias __MODULE__

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

  def group_sleep_entries_by_guard(log_entries) do
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
end
