alias Solution.Day6.Board

IO.puts("yo")

board =
  Board.from_origin_points([
    {7, 4},
    {1, 3},
    {5, 9}
  ])

board
|> Board.grow()
# |> Board.grow()
|> Board.grow()
# |> Board.grow()
# |> Board.grow()
# |> Board.grow()
|> Board.to_visualization_grid_string(height: 10, width: 10)
|> IO.inspect()
