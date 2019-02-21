alias Solution.Day6.VisualizationServer.BoardMatrixPlug

IO.puts("http://localhost:4000/")
{:ok, _} = Plug.Cowboy.http(BoardMatrixPlug, [])
