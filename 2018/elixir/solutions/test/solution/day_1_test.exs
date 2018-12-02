defmodule Solution.Day1Test do
  use ExUnit.Case
  alias Solution.Day1

  test "Single Change" do
    assert "1" == Day1.solve_part_1("""
      +1
    """)
  end
end
