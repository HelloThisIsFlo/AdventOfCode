defmodule Solution.Day6.VisualizationServer.BoardMatrixPlug do
  alias Solution.Day6.Board
  import Solution.Utils
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  @agents %{
    board: String.to_atom("Board"),
    dimensions: String.to_atom("Dimensions")
  }
  @default %{
    height: 50,
    width: 50
  }

  def random_coordinates(width, height) do
    x = :rand.uniform(width)
    y = :rand.uniform(height)
    {x, y}
  end

  defp origin_points(width, height) do
    number_of_points = Enum.random(5..30)

    for _i <- 0..number_of_points do
      random_coordinates(width, height)
    end
  end

  # @origin_points [
  #   {70, 44},
  #   {100, 32},
  #   {59, 90}
  # ]
  # @matrix %{
  #   height: 100,
  #   width: 100
  # }

  def init([]) do
    Agent.start(fn -> %Board{} end, name: @agents.board)
    Agent.start(fn -> %Board{} end, name: @agents.dimensions)
    :ok
  end

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{hey: "yo"}))
  end

  get "/matrix/reset" do
    query_params =
      conn
      |> fetch_query_params()
      |> Map.get(:query_params)

    width= get_dimension(query_params, :width)
    height= get_dimension(query_params, :height)

    update_dimensions(width, height)

    new_board_as_json = to_json(reset_board())

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, new_board_as_json)
  end

  defp get_dimension(query_params, dimension_type) do
    query_params
    |> Map.get(Atom.to_string(dimension_type), Map.get(@default, dimension_type))
    |> String.to_integer()
  end

  get "/matrix/next" do
    next_step_board_as_json = to_json(grow_board())

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, next_step_board_as_json)
  end

  get "/test" do
    conn =
      conn
      |> fetch_query_params()

    IO.inspect(conn.query_params)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "ok")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

  ### Private functions ###
  defp update_dimensions(width, height) do
    :ok = Agent.get_and_update(@agents.dimensions, fn _ -> {:ok, {width, height}} end)
  end

  defp reset_board do
    {width, height} = Agent.get(@agents.dimensions, &(&1))

    Agent.get_and_update(@agents.board, fn _board ->
      new_board = Board.from_origin_points(origin_points(width, height))
      {new_board, {new_board, height, width}}
    end)
  end

  defp grow_board do
    Agent.get_and_update(@agents.board, fn {board, height, width} ->
      next_step_board = Board.grow(board)
      {next_step_board, {next_step_board, height, width}}
    end)
  end

  defp to_json(%Board{} = board) do
    {width, height} = Agent.get(@agents.dimensions, &(&1))

    board
    |> log_and_passthrough("START - ''Board.to_visualization_grid_string(height:")
    |> Board.to_visualization_grid_string(height: height, width: width)
    |> log_and_passthrough("END   - ''Board.to_visualization_grid_string(height:")
    |> log_and_passthrough("START - 'Map.get(:grid)'")
    |> Map.get(:grid)
    |> log_and_passthrough("END   - 'Map.get(:grid)'")
    |> log_and_passthrough("START - ''Poison.encode!()")
    |> Poison.encode!()
    |> log_and_passthrough("END   - ''Poison.encode!()")
  end
end
