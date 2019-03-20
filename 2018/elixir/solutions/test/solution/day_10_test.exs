defmodule Solution.Day10Test do
  use ExUnit.Case, async: false
  alias Solution.Day10

  describe "Part 1" do
    test "asdf " do
      # assert "" ==
      #          GridString.from_grid_points([
      #            %GridPoint{point: {1, 1}, value: "2"},
      #            %GridPoint{point: {15, 15}, value: "1"}
      #          ])
    end

    test "Example from Problem Statement" do
      assert """

             #...#..###
             #...#...#.
             #...#...#.
             #####...#.
             #...#...#.
             #...#...#.
             #...#...#.
             #...#..###\
             """ ==
               Day10.solve_part_1("""
               position=< 9,  1> velocity=< 0,  2>
               position=< 7,  0> velocity=<-1,  0>
               position=< 3, -2> velocity=<-1,  1>
               position=< 6, 10> velocity=<-2, -1>
               position=< 2, -4> velocity=< 2,  2>
               position=<-6, 10> velocity=< 2, -2>
               position=< 1,  8> velocity=< 1, -1>
               position=< 1,  7> velocity=< 1,  0>
               position=<-3, 11> velocity=< 1, -2>
               position=< 7,  6> velocity=<-1, -1>
               position=<-2,  3> velocity=< 1,  0>
               position=<-4,  3> velocity=< 2,  0>
               position=<10, -3> velocity=<-1,  1>
               position=< 5, 11> velocity=< 1, -2>
               position=< 4,  7> velocity=< 0, -1>
               position=< 8, -2> velocity=< 0,  1>
               position=<15,  0> velocity=<-2,  0>
               position=< 1,  6> velocity=< 1,  0>
               position=< 8,  9> velocity=< 0, -1>
               position=< 3,  3> velocity=<-1,  1>
               position=< 0,  5> velocity=< 0, -1>
               position=<-2,  2> velocity=< 2,  0>
               position=< 5, -2> velocity=< 1,  2>
               position=< 1,  4> velocity=< 2,  1>
               position=<-2,  7> velocity=< 2, -2>
               position=< 3,  6> velocity=<-1, -1>
               position=< 5,  0> velocity=< 1,  0>
               position=<-6,  0> velocity=< 2,  0>
               position=< 5,  9> velocity=< 1, -2>
               position=<14,  7> velocity=<-2,  0>
               position=<-3,  6> velocity=< 2, -1>
               """)
    end
    test "Example from Problem Statement - Off-center" do
      assert """

      #...#..###
      #...#...#.
      #...#...#.
      #####...#.
      #...#...#.
      #...#...#.
      #...#...#.
      #...#..###\
      """ ==
        Day10.solve_part_1("""
        position=< 11,  3> velocity=< 0,  2>
        position=< 9,  2> velocity=<-1,  0>
        position=< 5, 0> velocity=<-1,  1>
        position=< 8, 12> velocity=<-2, -1>
        position=< 4, -2> velocity=< 2,  2>
        position=<-4, 12> velocity=< 2, -2>
        position=< 3,  10> velocity=< 1, -1>
        position=< 3,  9> velocity=< 1,  0>
        position=<-1, 13> velocity=< 1, -2>
        position=< 9,  8> velocity=<-1, -1>
        position=<0,  5> velocity=< 1,  0>
        position=<-2,  5> velocity=< 2,  0>
        position=<12, -1> velocity=<-1,  1>
        position=< 7, 13> velocity=< 1, -2>
        position=< 6,  9> velocity=< 0, -1>
        position=< 10, 0> velocity=< 0,  1>
        position=<17,  2> velocity=<-2,  0>
        position=< 3,  8> velocity=< 1,  0>
        position=< 10,  11> velocity=< 0, -1>
        position=< 5,  5> velocity=<-1,  1>
        position=< 2,  7> velocity=< 0, -1>
        position=<0,  4> velocity=< 2,  0>
        position=< 7, 0> velocity=< 1,  2>
        position=< 3,  6> velocity=< 2,  1>
        position=<0,  9> velocity=< 2, -2>
        position=< 5,  8> velocity=<-1, -1>
        position=< 7,  2> velocity=< 1,  0>
        position=<-4,  2> velocity=< 2,  0>
        position=< 7,  11> velocity=< 1, -2>
        position=<16,  9> velocity=<-2,  0>
        position=<-1,  8> velocity=< 2, -1>
        """)
    end
  end

  describe "Part 2" do
    test "Example from Problem Statement" do
      assert "3" ==
               Day10.solve_part_2("""
               position=< 9,  1> velocity=< 0,  2>
               position=< 7,  0> velocity=<-1,  0>
               position=< 3, -2> velocity=<-1,  1>
               position=< 6, 10> velocity=<-2, -1>
               position=< 2, -4> velocity=< 2,  2>
               position=<-6, 10> velocity=< 2, -2>
               position=< 1,  8> velocity=< 1, -1>
               position=< 1,  7> velocity=< 1,  0>
               position=<-3, 11> velocity=< 1, -2>
               position=< 7,  6> velocity=<-1, -1>
               position=<-2,  3> velocity=< 1,  0>
               position=<-4,  3> velocity=< 2,  0>
               position=<10, -3> velocity=<-1,  1>
               position=< 5, 11> velocity=< 1, -2>
               position=< 4,  7> velocity=< 0, -1>
               position=< 8, -2> velocity=< 0,  1>
               position=<15,  0> velocity=<-2,  0>
               position=< 1,  6> velocity=< 1,  0>
               position=< 8,  9> velocity=< 0, -1>
               position=< 3,  3> velocity=<-1,  1>
               position=< 0,  5> velocity=< 0, -1>
               position=<-2,  2> velocity=< 2,  0>
               position=< 5, -2> velocity=< 1,  2>
               position=< 1,  4> velocity=< 2,  1>
               position=<-2,  7> velocity=< 2, -2>
               position=< 3,  6> velocity=<-1, -1>
               position=< 5,  0> velocity=< 1,  0>
               position=<-6,  0> velocity=< 2,  0>
               position=< 5,  9> velocity=< 1, -2>
               position=<14,  7> velocity=<-2,  0>
               position=<-3,  6> velocity=< 2, -1>
               """)
    end
  end
end
