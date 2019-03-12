defmodule Solution.Day9Test do
  use ExUnit.Case, async: false
  alias Solution.Day9
  alias Solution.Day9.MarbleGame

  @number_of_players 15

  setup context do
    context
    |> Map.put(:game, MarbleGame.new(@number_of_players))
  end


  defp play_rounds(current_round, round_range) do
    round_range
    |> Enum.reduce(current_round, fn _, round ->
      MarbleGame.play_round(round)
    end)
  end

  describe "New game =>" do
    test "Start at round 0" do
      new_game = MarbleGame.new(100)

      assert new_game.current_round == [0]
      assert new_game.current_marble == 0
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

  describe "Get index from current marble =>" do
    test "Clockwise", %{game: game} do
      current = 33

      game = %{
        game
        | current_round: [1, 1, 1, 1, 1, current, 1, 1, 1, 1, 1, 1],
          current_marble: current
      }

      assert MarbleGame.index_from_current(game, 1, :clockwise) == 6
      assert MarbleGame.index_from_current(game, 4, :clockwise) == 9
      assert MarbleGame.index_from_current(game, 6, :clockwise) == 11
      assert MarbleGame.index_from_current(game, 7, :clockwise) == 0
      assert MarbleGame.index_from_current(game, 8, :clockwise) == 1
    end

    test "Anti-Clockwise", %{game: game} do
      current = 33

      game = %{
        game
        | current_round: [1, 1, 1, 1, 1, current, 1, 1, 1, 1, 1, 1],
          current_marble: current
      }

      assert MarbleGame.index_from_current(game, 1, :anticlockwise) == 4
      assert MarbleGame.index_from_current(game, 4, :anticlockwise) == 1
      assert MarbleGame.index_from_current(game, 8, :anticlockwise) == 9
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
          current_round: [1, 1, 1, 1, s, 1, 1, 1, 1, 1, 1, c, 1],
          current_marble: c,
          next_marble: next_marble
      }

      game_after_update_scores = MarbleGame.update_scores(game)

      assert game_after_update_scores.scores[player] ==
               game.scores[player] + next_marble + seventh_marble_anticlockwise
    end
  end

  describe "Update marbles => Next marble isn't a multiple of 23 =>" do
    test "Next 'current marble' is previous 'next marble'" do
      game = %MarbleGame{current_round: [1, 1, 3, 1], current_marble: 3, next_marble: 6}
      game_after_update_marbles = MarbleGame.update_marbles(game)
      assert game_after_update_marbles.current_marble == game.next_marble
    end

    test "Next 'next marble' is previous 'next marble' + 1" do
      game = %MarbleGame{current_round: [1, 1, 3, 1], current_marble: 3, next_marble: 6}
      game_after_update_marbles = MarbleGame.update_marbles(game)
      assert game_after_update_marbles.next_marble == game.next_marble + 1
    end

    test "'next marble' is inserted after next marble clockwise from 'current marble'" do
      current = 20
      next = 35

      game = %MarbleGame{
        current_round: [1, 1, 1, current, 1, 1, 1],
        current_marble: current,
        next_marble: next
      }

      game_after_update_marbles = MarbleGame.update_marbles(game)

      assert game_after_update_marbles.current_round == [1, 1, 1, current, 1, next, 1, 1]
    end

    test "'next marble' is inserted after next marble clockwise from 'current marble' => Edge case 1" do
      current = 20
      next = 35

      game = %MarbleGame{
        current_round: [1, 1, 1, 1, 1, current, 1],
        current_marble: current,
        next_marble: next
      }

      game_after_update_marbles = MarbleGame.update_marbles(game)

      assert game_after_update_marbles.current_round == [1, 1, 1, 1, 1, current, 1, next]
    end

    test "'next marble' is placed 2 marbles away clockwise from 'current marble' => Edge case 2" do
      current = 20
      next = 35

      game = %MarbleGame{
        current_round: [1, 1, 1, 1, 1, 1, current],
        current_marble: current,
        next_marble: next
      }

      game_after_update_marbles = MarbleGame.update_marbles(game)

      assert game_after_update_marbles.current_round == [1, next, 1, 1, 1, 1, 1, current]
    end
  end

  describe "Update marbles => Next marble is a multiple of 23 =>" do
    test "Next 'current marble' is 6 anticlockwise from previous 'current marble'" do
      current = 3
      e = expected_next_current_marble = 9

      game = %MarbleGame{
        next_marble: 46,
        current_round: [1, 1, e, 1, 1, 1, 1, 1, current, 1, 1],
        current_marble: current
      }

      game_after_update_marbles = MarbleGame.update_marbles(game)

      assert game_after_update_marbles.current_marble == expected_next_current_marble
    end

    test "7th anticlockwise from 'current marble' has been removed" do
      c = current = 3
      s = _seventh_marble_anticlockwise = 4

      game = %MarbleGame{
        next_marble: 46,
        current_round: [1, s, 1, 1, 1, 1, 1, 1, c, 1, 1],
        current_marble: current
      }

      game_after_update_marbles = MarbleGame.update_marbles(game)

      assert game_after_update_marbles.current_round == [1, 1, 1, 1, 1, 1, 1, c, 1, 1]
    end

    test "Next 'next marble' is the lowest-numbered remaining marble" do
      # Note: This example doesn't represent a valid round, but is enough to test the 'next marble' logic
      c = current_marble = 12
      n = next_marble = 46
      r = _about_to_be_removed = 5
      current_round = [1, 2, 4, r, 6, 7, 8, 9, 10, 11, c]
      scored_marbles = MapSet.new([23, 3])

      game = %MarbleGame{
        next_marble: n,
        current_round: current_round,
        current_marble: current_marble,
        scored_marbles: scored_marbles
      }

      game_after_update_marbles = MarbleGame.update_marbles(game)

      assert game_after_update_marbles.next_marble ==
               1..100
               |> Enum.to_list()
               |> Kernel.--(current_round)
               |> Kernel.--(scored_marbles |> MapSet.to_list())
               |> Kernel.--([next_marble])
               |> List.first()
    end

    test "'scored_marbles' is updated with 'next_marble' and the removed marble" do
      c = current_marble = 12
      n = _next_marble = 46
      r = _about_to_be_removed = 5
      current_round = [1, 2, 4, r, 6, 7, 8, 9, 10, 11, c]
      scored_marbles = MapSet.new([23, 3])

      game = %MarbleGame{
        next_marble: n,
        current_round: current_round,
        current_marble: current_marble,
        scored_marbles: scored_marbles
      }

      game_after_update_marbles = MarbleGame.update_marbles(game)

      assert game_after_update_marbles.scored_marbles == MapSet.new([23, 3, n, r])
    end
  end

  describe "Play round - Example from problem statement" do
    test "Round 1" do
      number_of_players = 9

      round_1 =
        MarbleGame.new(number_of_players)
        |> MarbleGame.play_round()

      assert round_1.current_round == [0, 1]
      assert round_1.current_marble == 1
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

      assert round_22.current_round ==
               [0, 16, 8, 17, 4, 18, 9, 19, 2, 20, 10, 21] ++
                 [5, 22, 11, 1, 12, 6, 13, 3, 14, 7, 15]
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

      assert round_23.current_round ==
               [0, 16, 8, 17, 4, 18, 19, 2, 20, 10, 21] ++
                 [5, 22, 11, 1, 12, 6, 13, 3, 14, 7, 15]
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

      assert round_25.current_round ==
               [0, 16, 8, 17, 4, 18, 19, 2, 24, 20, 25, 10] ++
                 [21, 5, 22, 11, 1, 12, 6, 13, 3, 14, 7, 15]
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
