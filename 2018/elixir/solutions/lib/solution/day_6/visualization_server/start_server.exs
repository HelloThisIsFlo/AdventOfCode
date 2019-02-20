alias Solution.Day6.VisualizationServer.HelloWorldPlug

IO.puts("http://localhost:4000/")
{:ok, _} = Plug.Cowboy.http(HelloWorldPlug, [])
