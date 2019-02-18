alias Solution.Day6.VisualizationServer.HelloWorldPlug

IO.puts("Yoooooooooooooooooooooooooooooo")
{:ok, _} = Plug.Cowboy.http(HelloWorldPlug, [])
