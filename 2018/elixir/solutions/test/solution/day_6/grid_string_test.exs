defmodule Solution.Day6.GridStringTest do
  use ExUnit.Case
  alias Solution.Day6.GridString

  describe "From String" do
    test "Only numbers" do
      assert GridString.from_string("""
             |   |   | 2 |   |   |   |   |   |   |
             |   | 2 | 1 | 2 |   |   |   |   |   |
             | 2 | 1 | 0 | 1 | 2 |   |   |   |   |
             |   | 2 | 1 | 2 |   |   | 2 |   |   |
             |   |   | 2 |   |   | 2 | 1 | 2 |   |
             |   |   |   |   | 2 | 1 | 0 | 1 | 2 |
             |   |   |   |   |   | 2 | 1 | 2 |   |
             |   |   |   |   |   |   | 2 |   |   |
             """) == %GridString{
               grid: [
                 [" ", " ", "2", " ", " ", " ", " ", " ", " "],
                 [" ", "2", "1", "2", " ", " ", " ", " ", " "],
                 ["2", "1", "0", "1", "2", " ", " ", " ", " "],
                 [" ", "2", "1", "2", " ", " ", "2", " ", " "],
                 [" ", " ", "2", " ", " ", "2", "1", "2", " "],
                 [" ", " ", " ", " ", "2", "1", "0", "1", "2"],
                 [" ", " ", " ", " ", " ", "2", "1", "2", " "],
                 [" ", " ", " ", " ", " ", " ", "2", " ", " "]
               ]
             }
    end

    test "Number of space doesn't matter" do
      assert GridString.from_string("""
             |   |      | 2 |     |   |
             |   | 2    | 1 |   2 |    |
             | 2 | 1    | 0 |   1 | 2 |
             |   | 2    | 1 |   2 |        |
             |   |      | 2 |     |   |
             """) == %GridString{
               grid: [
                 [" ", " ", "2", " ", " "],
                 [" ", "2", "1", "2", " "],
                 ["2", "1", "0", "1", "2"],
                 [" ", "2", "1", "2", " "],
                 [" ", " ", "2", " ", " "]
               ]
             }
    end

    test "Multiple chars" do
      assert GridString.from_string("""
             |   |     | 2. |   |   |
             |   | 234 | 1  | 2 |   |
             | 2 | 1   | 0  | 1 | 2 |
             |   | 2   | 1  | x |   |
             |   |     | 2  |   |   |
             """) == %GridString{
               grid: [
                 [" ", " ", "2.", " ", " "],
                 [" ", "234", "1", "2", " "],
                 ["2", "1", "0", "1", "2"],
                 [" ", "2", "1", "x", " "],
                 [" ", " ", "2", " ", " "]
               ]
             }
    end
  end

  describe "To String" do
    test "Add empty line at top" do
      assert """
             |   |   | 2 |   |   |
             |   | 2 | 1 | 2 |   |
             | 2 | 1 | 0 | 1 | 2 |
             |   | 2 | 1 | x |   |
             |   |   | 2 |   |   |
             """
             |> GridString.from_string()
             |> String.Chars.to_string() ==
               """

               |   |   | 2 |   |   |
               |   | 2 | 1 | 2 |   |
               | 2 | 1 | 0 | 1 | 2 |
               |   | 2 | 1 | x |   |
               |   |   | 2 |   |   |\
               """
    end

    test "Varied width" do
      assert """
             |   |     | 2. |   |   |
             |   | 234 | 1  | 2 |   |
             | 2 | 1   | 0  | 1 | 2 |
             |   | 2   | 1  | x |   |
             |   |     | 2  |   |   |
             """
             |> GridString.from_string()
             |> String.Chars.to_string() ==
               """

               |   |     | 2. |   |   |
               |   | 234 | 1  | 2 |   |
               | 2 | 1   | 0  | 1 | 2 |
               |   | 2   | 1  | x |   |
               |   |     | 2  |   |   |\
               """
    end
  end
end
