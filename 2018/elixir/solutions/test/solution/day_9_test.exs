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

    test "All score are initialized to 0" do
      number_of_players = 100
      new_game = MarbleGame.new(number_of_players)

      Enum.each(1..number_of_players, fn player ->
        assert Map.get(new_game.scores, player) == 0
      end)
    end

    test "Number of players is initialized" do
      number_of_players = 1234
      new_game = MarbleGame.new(number_of_players)

      assert new_game.number_of_players == number_of_players
    end
  end


  describe "Update players" do
    test "Current player is not last player => Current player is incremented", %{game: game} do
      game = %{game | current_player: 3}
      after_round = MarbleGame.update_current_player(game)
      assert after_round.current_player == 4
    end

    test "Current player is last player => Current player is reset to '1'", %{game: game} do
      game = %{game | current_player: @number_of_players}
      after_round = MarbleGame.update_current_player(game)
      assert after_round.current_player == 1
    end
  end

  describe "Update scores =>" do
    test "'next marble' isn't a multiple of 23 => Scores stay the same", %{game: game} do
      game = %{game | next_marble: 21}
      game_after_update_scores = MarbleGame.update_scores(game)
      assert game.scores == game_after_update_scores.scores
    end

    # TODO: Do not increment scores, but store scored marbles. Calculate scores at the end.
    test "'next marble' is a multiple of 23 =>
          Current player score is incremented by 'next marble' and marble 7 marbles away anti-clockwise from 'current'",
         %{game: game} do
      player = 4
      next_marble = 3 * 23
      s = seventh_marble_anticlockwise = 44
      c = _current_marble = 55

      game = %{
        game
        | current_player: player,
          current_round: Circle.new([c, 1, 1, 1, 1, 1, s, 1, 1, 1, 1, 1, 1]),
          next_marble: next_marble
      }

      game_after_update_scores = MarbleGame.update_scores(game)

      assert game_after_update_scores.scores[player] ==
               game.scores[player] + next_marble + seventh_marble_anticlockwise
    end
  end

  describe "Update marbles => Next marble isn't a multiple of 23 =>" do
    test "Next 'current marble' is previous 'next marble'" do
      game = %MarbleGame{current_round: Circle.new([3, 1, 1, 1, 1]), next_marble: 4}
      game_after_update_marbles = MarbleGame.update_marbles(game)

      assert MarbleGame.current_marble(game_after_update_marbles) == game.next_marble
    end

    test "Next 'next marble' is previous 'next marble' + 1" do
      game = %MarbleGame{current_round: Circle.new([3, 1, 1, 1, 1]), next_marble: 4}
      game_after_update_marbles = MarbleGame.update_marbles(game)
      assert game_after_update_marbles.next_marble == game.next_marble + 1
    end

    test "'next marble' is inserted after next marble clockwise from 'current marble'" do
      c = _current = 20
      n = next = 35

      game = %MarbleGame{
        current_round: Circle.new([c, 1, 1, 1, 1, 1, 1]),
        next_marble: next
      }

      game_after_update_marbles = MarbleGame.update_marbles(game)

      assert game_after_update_marbles.current_round |> Circle.to_list() ==
               [n, 1, 1, 1, 1, 1, c, 1]
    end
  end

  describe "Update marbles => Next marble is a multiple of 23 =>" do
    test "7th anticlockwise from 'current marble' has been removed & current is 6th anticlockwise" do
      c = current = 888
      s = _seventh_marble_anticlockwise = 999

      game = %MarbleGame{
        next_marble: 46,
        current_round: Circle.new([c, 1, 2, 3, s, 4, 5, 6, 7, 8, 9])
      }

      game_after_update_marbles = MarbleGame.update_marbles(game)

      assert Circle.to_list(game_after_update_marbles.current_round) ==
               [4, 5, 6, 7, 8, 9, c, 1, 2, 3]
    end

    # TODO: Use refactored scores instead lf 'scored_marbles'
    test "Next 'next marble' is the lowest-numbered remaining marble" do
      # Note: This example doesn't represent a valid round, but is enough to test the 'next marble' logic
      c = current_marble = 12
      n = next_marble = 46
      r = _about_to_be_removed = 5
      current_round = Circle.new([c, 1, 2, 4, r, 6, 7, 8, 9, 10, 11])
      scored_marbles = MapSet.new([23, 3])

      game = %MarbleGame{
        next_marble: n,
        current_round: current_round,
        scored_marbles: scored_marbles
      }

      game_after_update_marbles = MarbleGame.update_marbles(game)

      assert game_after_update_marbles.next_marble ==
               1..100
               |> Enum.to_list()
               |> Kernel.--(current_round |> Circle.to_list())
               |> Kernel.--(scored_marbles |> MapSet.to_list())
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

    #   game_after_update_marbles = MarbleGame.update_marbles(game)

    #   assert game_after_update_marbles.scored_marbles == MapSet.new([23, 3, n, r])
    # end
  end

  describe "Play round - Example from problem statement" do
    test "Round 1" do
      number_of_players = 9

      round_1 =
        MarbleGame.new(number_of_players)
        |> MarbleGame.play_round()

      assert Circle.to_list(round_1.current_round) == [1, 0]
      assert round_1.next_marble == 2
      assert round_1.current_player == 2
      assert Enum.all?(round_1.scores, fn {_player, score} -> score == 0 end)
    end

    test "Rounds 1-22" do
      number_of_players = 9

      round_22 =
        MarbleGame.new(number_of_players)
        |> play_rounds(1..22)

      assert Enum.all?(round_22.scores, fn {_player, score} -> score == 0 end)
      assert round_22.current_player == 5

      assert Circle.to_list(round_22.current_round) ==
               [22, 11, 1, 12, 6, 13, 3, 14, 7, 15, 0, 16] ++
                 [8, 17, 4, 18, 9, 19, 2, 20, 10, 21, 5]
    end

    test "Rounds 1-23" do
      number_of_players = 9
      player_5 = 5

      round_23 =
        MarbleGame.new(number_of_players)
        |> play_rounds(1..23)

      assert round_23.scores[player_5] == 32

      assert round_23.scores
             |> Map.delete(player_5)
             |> Enum.all?(fn {_player, score} -> score == 0 end)

      assert round_23.current_player == 6

      assert Circle.to_list(round_23.current_round) ==
               [19, 2, 20, 10, 21, 5, 22, 11, 1, 12, 6, 13] ++
                 [3, 14, 7, 15, 0, 16, 8, 17, 4, 18]
    end

    test "Rounds 1-25" do
      number_of_players = 9
      player_5 = 5

      round_25 =
        MarbleGame.new(number_of_players)
        |> play_rounds(1..25)

      assert round_25.scores[player_5] == 32

      assert round_25.scores
             |> Map.delete(player_5)
             |> Enum.all?(fn {_player, score} -> score == 0 end)

      assert round_25.current_player == 8

      assert Circle.to_list(round_25.current_round) ==
               [25, 10, 21, 5, 22, 11, 1, 12, 6, 13, 3, 14] ++
                 [7, 15, 0, 16, 8, 17, 4, 18, 19, 2, 24, 20]
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

    @tag timeout: 5_000
    @tag :skip
    test "Performance" do
      Day9.solve_part_1("""
      13 players; last marble is worth 100000 points
      """)
    end
  end

  describe "Part 1" do
    @tag timeout: 10_000
    @tag :skip
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
