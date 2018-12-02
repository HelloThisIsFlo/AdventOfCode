defmodule Solution.Day1 do
  @moduledoc """
  --- Part One ---
  After feeling like you've been falling for a few minutes, you look at the device's tiny screen. "Error: Device must be calibrated before first use. Frequency drift detected. Cannot maintain destination lock." Below the message, the device shows a sequence of changes in frequency (your puzzle input). A value like +6 means the current frequency increases by 6; a value like -3 means the current frequency decreases by 3.

  For example, if the device displays frequency changes of +1, -2, +3, +1, then starting from a frequency of zero, the following changes would occur:

  Current frequency  0, change of +1; resulting frequency  1.
  Current frequency  1, change of -2; resulting frequency -1.
  Current frequency -1, change of +3; resulting frequency  2.
  Current frequency  2, change of +1; resulting frequency  3.
  In this example, the resulting frequency is 3.

  Here are other example situations:

  +1, +1, +1 results in  3
  +1, +1, -2 results in  0
  -1, -2, -3 results in -6
  Starting with a frequency of zero, what is the resulting frequency after all of the changes in frequency have been applied?


  --- Part Two ---
  You notice that the device repeats the same frequency change list over and over. To calibrate the device, you need to find the first frequency it reaches twice.

  For example, using the same list of changes above, the device would loop as follows:

  Current frequency  0, change of +1; resulting frequency  1.
  Current frequency  1, change of -2; resulting frequency -1.
  Current frequency -1, change of +3; resulting frequency  2.
  Current frequency  2, change of +1; resulting frequency  3.
  (At this point, the device continues from the start of the list.)
  Current frequency  3, change of +1; resulting frequency  4.
  Current frequency  4, change of -2; resulting frequency  2, which has already been seen.
  In this example, the first frequency reached twice is 2. Note that your device might need to repeat its list of frequency changes many times before a duplicate frequency is found, and that duplicates might be found while in the middle of processing the list.

  Here are other examples:

  +1, -1 first reaches 0 twice.
  +3, +3, +4, -2, -4 first reaches 10 twice.
  -6, +3, +8, +5, -6 first reaches 5 twice.
  +7, +7, -2, -7, -4 first reaches 14 twice.
  What is the first frequency your device reaches twice?
  """
  @behaviour Solution

  @doc """
  The result is simply the sum of all frequency changes.
  """
  def solve_part_1(input_as_string) do
    input_as_string
    |> parse_changes()
    |> Enum.sum()
    |> Integer.to_string()
  end

  @doc """
  While probably not the most optimized solution a simple implementation would be to
  keep track of all traversed frequencies, and each time a new frequency is reached,
  check the list to see if the frequency was already there.
  """
  def solve_part_2(input_as_string) do
    input_as_string
    |> parse_changes()
    |> find_frequency_reached_twice()
    |> Integer.to_string()
  end

  defp find_frequency_reached_twice(changes) do
    do_find_frequency_reached_twice(0, MapSet.new(), changes, changes)
  end

  defp do_find_frequency_reached_twice(
         current_freq,
         traversed_freq,
         changes_to_apply,
         all_changes
       )

  defp do_find_frequency_reached_twice(current_freq, traversed_freq, [], all_changes) do
    do_find_frequency_reached_twice(current_freq, traversed_freq, all_changes, all_changes)
  end

  defp do_find_frequency_reached_twice(
         current_freq,
         traversed_freq,
         [next_change | rest_of_changes_to_apply],
         all_changes
       ) do
    if Enum.member?(traversed_freq, current_freq) do
      current_freq
    else
      do_find_frequency_reached_twice(
        current_freq + next_change,
        MapSet.put(traversed_freq, current_freq),
        rest_of_changes_to_apply,
        all_changes
      )
    end
  end

  defp parse_changes(input_as_string) do
    input_as_string
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end
