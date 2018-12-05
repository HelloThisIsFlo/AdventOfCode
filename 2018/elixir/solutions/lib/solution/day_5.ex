defmodule Solution.Day5 do
  @moduledoc """
  --- Part One ---
  You've managed to sneak in to the prototype suit manufacturing lab.
  The Elves are making decent progress, but are still struggling with
  the suit's size reduction capabilities.

  While the very latest in 1518 alchemical technology might have solved
  their problem eventually, you can do better. You scan the chemical
  composition of the suit's material and discover that it is formed
  by extremely long polymers (one of which is available as your puzzle
  input).

  The polymer is formed by smaller units which, when triggered, react
  with each other such that two adjacent units of the same type and
  opposite polarity are destroyed. Units' types are represented by
  letters; units' polarity is represented by capitalization. For
  instance, r and R are units with the same type but opposite polarity,
  whereas r and s are entirely different types and do not react.

  For example:
  In aA, a and A react, leaving nothing behind.
  In abBA, bB destroys itself, leaving aA. As above, this then destroys
  itself, leaving nothing.
  In abAB, no two adjacent units are of the same type, and so nothing
  happens.
  In aabAAB, even though aa and AA are of the same type, their
  polarities match, and so nothing happens.


  Now, consider a larger example, dabAcCaCBAcCcaDA:

  dabAcCaCBAcCcaDA  The first 'cC' is removed.
  dabAaCBAcCcaDA    This creates 'Aa', which is removed.
  dabCBAcCcaDA      Either 'cC' or 'Cc' are removed (the result is the same).
  dabCBAcaDA        No further actions can be taken.
  After all possible reactions, the resulting polymer contains 10 units.

  How many units remain after fully reacting the polymer you scanned?


  --- Part Two ---

  """

  @behaviour Solution

  @doc """
  Solves: "How many units remain after fully reacting the polymer you scanned?"
  """
  def solve_part_1(input_as_string) do
    input_as_string
    |> String.trim()
    |> String.codepoints()
    |> react_until_stable()
    |> count_remaining_units()
    |> Integer.to_string()
  end

  defp react_until_stable(to_react) do
    case do_react(to_react, []) do
      ^to_react -> to_react
      result_not_yet_stable -> react_until_stable(result_not_yet_stable)
    end
  end

  defp count_remaining_units(remaning_units) when is_list(remaning_units),
    do: length(remaning_units)

  # Note: For performance reasons, instead of appending each time to the reaction_result,
  #       elements are prepended, and the result is reversed before being returned
  #
  #       In elixir lists are linked lists so:
  #        - Appending takes linear time
  #        - Prepending takes constant time
  defp do_react([], reacted), do: Enum.reverse(reacted)
  defp do_react([last], reacted), do: do_react([], [last | reacted])
  defp do_react([first | [second | all_but_first_two] = all_but_first], reacted) do
    if reacting?(first, second) do
      do_react(all_but_first_two, reacted)
    else
      do_react(all_but_first, [first | reacted])
    end
  end

  defp reacting?(unit_1, unit_2) do
    different_case?(unit_1, unit_2) and same_letter?(unit_1, unit_2)
  end

  defp different_case?(char_1, char_2),
    do: (downcase?(char_1) and not downcase?(char_2)) or (upcase?(char_1) and not upcase?(char_2))
  defp same_letter?(char_1, char_2),
    do: String.upcase(char_1) == String.upcase(char_2)
  defp downcase?(char),
    do: String.downcase(char) == char
  defp upcase?(char),
    do: String.upcase(char) == char

  @doc """
  Solves: "Of all guards, which guard is most frequently asleep on the same minute?"
  """
  def solve_part_2(_input_as_string) do
    ""
  end
end
