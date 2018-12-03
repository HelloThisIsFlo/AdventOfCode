defmodule Solution.Day2 do
  @moduledoc """
  --- Part One ---
  To make sure you didn't miss any, you scan the likely candidate boxes again, counting the number
  that have an ID containing exactly two of any letter and then separately counting those with
  exactly three of any letter. You can multiply those two counts together to get a rudimentary
  checksum and compare it to what your device predicts.

  For example, if you see the following box IDs:

  'abcdef' contains no letters that appear exactly two or three times.
  'bababc' contains two a and three b, so it counts for both.
  'abbcde' contains two b, but no letter appears exactly three times.
  'abcccd' contains three c, but no letter appears exactly two times.
  'aabcdd' contains two a and two d, but it only counts once.
  'abcdee' contains two e.
  'ababab' contains three a and three b, but it only counts once.

  Of these box IDs, four of them contain a letter which appears exactly twice, and three of
  them contain a letter which appears exactly three times. Multiplying these together produces
  a checksum of 4 * 3 = 12.

  What is the checksum for your list of box IDs?


  --- Part Two ---
  Confident that your list of box IDs is complete, you're ready to find the boxes full of
  prototype fabric.

  The boxes will have IDs which differ by exactly one character at the same position in
  both strings. For example, given the following box IDs:

  abcde
  fghij
  klmno
  pqrst
  fguij
  axcye
  wvxyz

  The IDs abcde and axcye are close, but they differ by two characters (the second and fourth).
  However, the IDs fghij and fguij differ by exactly one character, the third (h and u). Those
  must be the correct boxes.

  What letters are common between the two correct box IDs? (In the example above, this is found
  by removing the differing character from either ID, producing fgij.)
  """
  @behaviour Solution

  @doc """
  Checksum:
  - Find number of boxes with duplicate letters
  - Find number of boxes with triplicate letters
  - Multiply these numbers
  """
  def solve_part_1(input_as_string) do
    box_names = parse_box_names(input_as_string)

    num_of_boxes_with_duplicate_letters =
      box_names
      |> Enum.filter(&has_duplicate_letters/1)
      |> Enum.count()

    num_of_boxes_with_triplicate_letters =
      box_names
      |> Enum.filter(&has_triplicate_letters/1)
      |> Enum.count()

    (num_of_boxes_with_duplicate_letters  * num_of_boxes_with_triplicate_letters)
    |> Integer.to_string()
  end

  @doc """
  A simple solution would go as follow
  - For each box name:
    - For each other box name:
      - For each char:
        if different, increase diff_counter
        if diff_counter > 1, skip to next entry
  """
  def solve_part_2(_input_as_string) do
    ""
  end

  defp parse_box_names(input_as_string) do
    input_as_string
    |> String.split()
  end

  defp has_duplicate_letters(box_name), do: has_exactly_x_occurences_of_any_letters(box_name, 2)
  defp has_triplicate_letters(box_name), do: has_exactly_x_occurences_of_any_letters(box_name, 3)

  defp has_exactly_x_occurences_of_any_letters(box_name, expected_number_of_occurrences) do
    box_name
    |> String.codepoints()
    |> Enum.reduce(Map.new(), fn char, count_of_each_char ->
      Map.update(count_of_each_char, char, 1, &(&1 + 1))
    end)
    |> Enum.any?(fn {_char, occurences} ->
      occurences == expected_number_of_occurrences
    end)
  end
end
