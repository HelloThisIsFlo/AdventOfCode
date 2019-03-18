defmodule Solution.Day9Test do
  use ExUnit.Case, async: false
  alias Solution.Day9
  alias Solution.Day9.MarbleGame
  alias Solution.Day9.Circle

  @number_of_players 15

  setup context do
    context
    |> Map.put(:game, MarbleGame.new(@number_of_players))
  end

  defp play_rounds(current_round_old, round_range) do
    round_range
    |> Enum.reduce(current_round_old, fn _, round ->
      MarbleGame.play_round(round)
    end)
  end

  describe "New game =>" do
    test "Start at round 0" do
      new_game = MarbleGame.new(100)

      assert new_game.current_round |> Circle.to_list() == [0]
      assert MarbleGame.current_marble(new_game) == 0
      assert new_game.next_marble == 1
    end

    test "All scored marbles lists are initialized to empty set" do
      number_of_players = 100
      new_game = MarbleGame.new(number_of_players)

      Enum.each(1..number_of_players, fn player ->
        assert Map.get(new_game.scored_marbles, player) == MapSet.new()
      end)
    end

    test "Number of players is initialized" do
      number_of_players = 1234
      new_game = MarbleGame.new(number_of_players)

      assert new_game.number_of_players == number_of_players
    end
  end

  describe "Play round => Update players" do
    test "Current player is not last player => Current player is incremented", %{game: game} do
      game = %{game | current_player: 3}
      after_round = MarbleGame.play_round(game)
      assert after_round.current_player == 4
    end

    test "Current player is last player => Current player is reset to '1'", %{game: game} do
      game = %{game | current_player: @number_of_players}
      after_round = MarbleGame.play_round(game)
      assert after_round.current_player == 1
    end
  end

  describe "Play round => Update scored marbles =>" do
    test "'next marble' isn't a multiple of 23 => Scored marbles stay the same", %{game: game} do
      game = %{game | next_marble: 21}
      game_after_update_scores = MarbleGame.play_round(game)
      assert game.scored_marbles == game_after_update_scores.scored_marbles
    end

    # TODO: Do not increment scores, but store scored marbles. Calculate scores at the end.
    test "'next marble' is a multiple of 23 =>
          Current player scored 'next marble' and the marble 7 marbles away anti-clockwise from 'current'",
         %{game: game} do
      current_player = 4
      n = next_marble = 3 * 23
      s = _seventh_marble_anticlockwise = 44
      c = _current_marble = 55

      game = %{
        game
        | current_player: current_player,
          current_round: Circle.new([c, 1, 1, 1, 1, 1, s, 1, 1, 1, 1, 1, 1]),
          next_marble: next_marble
      }

      game_after_update_scores = MarbleGame.play_round(game)

      assert game_after_update_scores.scored_marbles[current_player] == MapSet.new([n, s])
    end
  end

  describe "Play round => Update marbles => Next marble isn't a multiple of 23 =>" do
    test "Next 'current marble' is previous 'next marble'" do
      game = %MarbleGame{
        current_round: Circle.new([3, 1, 1, 1, 1]),
        next_marble: 4,
        number_of_players: 7
      }

      game_after_play_round = MarbleGame.play_round(game)

      assert MarbleGame.current_marble(game_after_play_round) == game.next_marble
    end

    test "Next 'next marble' is previous 'next marble' + 1" do
      game = %MarbleGame{
        current_round: Circle.new([3, 1, 1, 1, 1]),
        next_marble: 4,
        number_of_players: 7
      }

      game_after_play_round = MarbleGame.play_round(game)
      assert game_after_play_round.next_marble == game.next_marble + 1
    end

    test "'next marble' is inserted after next marble clockwise from 'current marble'" do
      c = _current = 20
      n = next = 35

      game =
        MarbleGame.new(7)
        |> Map.put(:current_round, Circle.new([c, 1, 1, 1, 1, 1, 1]))
        |> Map.put(:next_marble, next)

      game_after_play_round = MarbleGame.play_round(game)

      assert game_after_play_round.current_round |> Circle.to_list() ==
               [c, 1, n, 1, 1, 1, 1, 1]
    end
  end

  describe "Play round => Update marbles => Next marble is a multiple of 23 =>" do
    test "7th anticlockwise from 'current marble' has been removed & current is 6th anticlockwise" do
      c = _current = 888
      se = _seventh_marble_anticlockwise = 777
      si = _seventh_marble_anticlockwise = 666

      game =
        MarbleGame.new(7)
        |> Map.put(:current_round, Circle.new([c, 1, 2, 3, se, si, 5, 6, 7, 8, 9]))
        |> Map.put(:next_marble, 46)

      game_after_play_round = MarbleGame.play_round(game)

      assert Circle.current(game_after_play_round.current_round) == si

      assert Circle.to_list(game_after_play_round.current_round) ==
               [c, 1, 2, 3, si, 5, 6, 7, 8, 9]
    end

    test "Next 'next marble' is the lowest-numbered remaining marble" do
      # Note: This example doesn't represent a valid round, but is enough to test the 'next marble' logic
      c = _current_marble = 12
      _n = next_marble = 46
      r = _about_to_be_removed = 5
      current_round = Circle.new([c, 1, 2, 4, r, 6, 7, 8, 9, 10, 11])
      scored_marbles_by_player_3 = MapSet.new([23, 3])

      game =
        MarbleGame.new(7)
        |> Map.put(:current_round, current_round)
        |> Map.put(:next_marble, next_marble)
        |> Map.update!(:scored_marbles, fn scored_marbles ->
          Map.put(scored_marbles, 3, scored_marbles_by_player_3)
        end)

      game_after_play_round = MarbleGame.play_round(game)

      assert game_after_play_round.next_marble ==
               1..100
               |> Enum.to_list()
               |> Kernel.--(current_round |> Circle.to_list())
               |> Kernel.--(scored_marbles_by_player_3 |> MapSet.to_list())
               |> Kernel.--([next_marble])
               |> List.first()
    end

    # test "'scored_marbles' is updated with 'next_marble' and the removed marble" do
    #   c = current_marble = 12
    #   n = _next_marble = 46
    #   r = _about_to_be_removed = 5
    #   current_round_old = [1, 2, 4, r, 6, 7, 8, 9, 10, 11, c]
    #   scored_marbles = MapSet.new([23, 3])

    #   game = %MarbleGame{
    #     next_marble: n,
    #     current_round_old: current_round_old,
    #     current_marble: current_marble,
    #     scored_marbles: scored_marbles
    #   }

    #   game_after_play_round = MarbleGame.play_round(game)

    #   assert game_after_play_round.scored_marbles == MapSet.new([23, 3, n, r])
    # end
  end

  describe "Get scores =>" do
    test "No scored marbles => Score 0" do
      game = MarbleGame.new(7)
      assert MarbleGame.score(game, 3) == 0
    end

    test "Some scored marbles => Score sum of scored marbles" do
      scored_marbles_by_player_3 = MapSet.new([23, 3])

      game =
        MarbleGame.new(7)
        |> Map.update!(:scored_marbles, &Map.put(&1, 3, scored_marbles_by_player_3))

      assert MarbleGame.score(game, 3) == 23 + 3
    end
  end

  describe "Play round - Example from problem statement" do
    test "Round 1" do
      number_of_players = 9

      round_1 =
        MarbleGame.new(number_of_players)
        |> MarbleGame.play_round()

      assert Circle.to_list(round_1.current_round) == [0, 1]
      assert round_1.next_marble == 2
      assert round_1.current_player == 2

      assert 1..number_of_players
             |> Enum.map(&MarbleGame.score(round_1, &1))
             |> Enum.all?(&(&1 == 0))
    end

    test "Rounds 1-22" do
      number_of_players = 9

      round_22 =
        MarbleGame.new(number_of_players)
        |> play_rounds(1..22)

      assert 1..number_of_players
             |> Enum.map(&MarbleGame.score(round_22, &1))
             |> Enum.all?(&(&1 == 0))

      assert round_22.current_player == 5

      assert Circle.current(round_22.current_round) == 22

      assert Circle.to_list(round_22.current_round) ==
               [0, 16, 8, 17, 4, 18, 9, 19, 2, 20, 10, 21] ++
                 [5, 22, 11, 1, 12, 6, 13, 3, 14, 7, 15]
    end

    test "Rounds 1-23" do
      number_of_players = 9
      player_5 = 5

      round_23 =
        MarbleGame.new(number_of_players)
        |> play_rounds(1..23)

      assert MarbleGame.score(round_23, player_5) == 32

      assert 1..number_of_players
             |> Enum.to_list()
             |> Kernel.--([player_5])
             |> Enum.map(&MarbleGame.score(round_23, &1))
             |> Enum.all?(&(&1 == 0))

      assert round_23.current_player == 6

      assert Circle.to_list(round_23.current_round) ==
               [0, 16, 8, 17, 4, 18, 19, 2, 20] ++
                 [10, 21, 5, 22, 11, 1, 12, 6, 13, 3, 14, 7, 15]
    end

    test "Rounds 1-25" do
      number_of_players = 9
      player_5 = 5

      round_25 =
        MarbleGame.new(number_of_players)
        |> play_rounds(1..25)

      assert MarbleGame.score(round_25, player_5) == 32

      assert 1..number_of_players
             |> Enum.to_list()
             |> Kernel.--([player_5])
             |> Enum.map(&MarbleGame.score(round_25, &1))
             |> Enum.all?(&(&1 == 0))

      assert round_25.current_player == 8

      assert Circle.to_list(round_25.current_round) ==
               [0, 16, 8, 17, 4, 18, 19, 2, 24, 20] ++
                 [25, 10, 21, 5, 22, 11, 1, 12, 6, 13, 3, 14, 7, 15]
    end
  end

  def log_to_file(_context) do
    file_backend = {LoggerFileBackend, :debug}
    Logger.add_backend(file_backend)
    Logger.configure_backend(file_backend, path: "debug.log")

    on_exit(fn ->
      Logger.remove_backend(file_backend)
      IO.puts("oooooooooooooooookkkkkkkkkkkkkkkkkkkkkk")
    end)
  end

  describe "Debug =>" do
    setup :log_to_file

    @tag timeout: 15_000
    @tag :skip
    test "Performance" do
      Day9.solve_part_1("""
      411 players; last marble is worth 72059 points
      """)

      assert 1 == 2
    end
  end

  describe "Part 1" do
    @tag timeout: 10_000
    # @tag :skip
    test "Example from Problem Statement" do
      assert "8317" ==
               Day9.solve_part_1("""
               10 players; last marble is worth 1618 points
               """)
    end
  end

  describe "Part 2" do
    @tag :skip
    test "Example from Problem Statement" do
      assert "66" ==
               Day9.solve_part_2("""
               2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
               """)
    end
  end
end
