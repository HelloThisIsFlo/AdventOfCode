defmodule Solution.Day6.VisualizationServer.BoardMatrixPlug do
  alias Solution.Day6.Board
  import Solution.Utils
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  @matrix %{
    height: 100,
    width: 100
  }

  def random_coordinates do
    x = :rand.uniform(@matrix.width)
    y = :rand.uniform(@matrix.height)
    {x, y}
  end

  defp origin_points do
    number_of_points = Enum.random(5..30)

    for _i <- 0..number_of_points do
      random_coordinates()
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
    Agent.start(fn -> %Board{} end, name: __MODULE__)
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
    new_board_as_json = to_json(reset_board())

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, new_board_as_json)
  end

  get "/matrix/next" do
    next_step_board_as_json = to_json(grow_board())

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, next_step_board_as_json)
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

  ### Private functions ###
  defp reset_board do
    Agent.get_and_update(__MODULE__, fn _board ->
      new_board = Board.from_origin_points(origin_points())
      {new_board, new_board}
    end)
  end

  defp grow_board do
    Agent.get_and_update(__MODULE__, fn board ->
      next_step_board = Board.grow(board)
      {next_step_board, next_step_board}
    end)
  end

  defp to_json(%Board{} = board) do
    board
    |> log_and_passthrough("START - ''Board.to_visualization_grid_string(height:")
    |> Board.to_visualization_grid_string(height: @matrix.height, width: @matrix.width)
    |> log_and_passthrough("END   - ''Board.to_visualization_grid_string(height:")
    |> log_and_passthrough("START - 'Map.get(:grid)'")
    |> Map.get(:grid)
    |> log_and_passthrough("END   - 'Map.get(:grid)'")
    |> log_and_passthrough("START - ''Poison.encode!()")
    |> Poison.encode!()
    |> log_and_passthrough("END   - ''Poison.encode!()")
  end
end
