defmodule Solution.Day4.SleepPeriod do
  alias __MODULE__

  @type t() :: %__MODULE__{
          start: NaiveDateTime.t(),
          end: NaiveDateTime.t()
        }
  defstruct([:start, :end])

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
