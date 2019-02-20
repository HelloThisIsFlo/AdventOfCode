defmodule Solution.Day6.VisualizationServer.HelloWorldPlug do
  alias Solution.Day6.Board
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  @origin_points [
    {700, 444},
    {100, 322},
    {599, 900}
  ]
  @matrix %{
    height: 1000,
    width: 1000
  }

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
      new_board = Board.from_origin_points(@origin_points)
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
    |> Board.to_visualization_grid_string(height: @matrix.height, width: @matrix.width)
    |> Map.get(:grid)
    |> Poison.encode!()
  end
end
