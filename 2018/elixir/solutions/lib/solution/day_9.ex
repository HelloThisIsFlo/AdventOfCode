defmodule Solution.Day9 do
  alias Solution.Day9.MarbleGame
  require Logger

  defmodule MarbleGame do
    defstruct number_of_players: 0,
              current_player: 1,
              current_round: [0],
              current_marble: 0,
              next_marble: 1,
              scores: %{},
              scored_marbles: MapSet.new()

    @spec new(integer()) :: Solution.Day9.MarbleGame.t()
    def new(number_of_players) do
      initial_scores =
        1..number_of_players
        |> Enum.map(fn player -> {player, 0} end)
        |> Map.new()

      %__MODULE__{
        scores: initial_scores,
        number_of_players: number_of_players
      }
    end

    @spec play_round(MarbleGame.t()) :: MarbleGame.t()
    def play_round(marble_game) do
      marble_game
      |> log_and_passthrough("Current marble: #{marble_game.current_marble}")
      |> log_and_passthrough("Next    marble: #{marble_game.next_marble}")
      |> log_and_passthrough(
        "Next is multiple of 23? => #{marble_game.next_marble |> is_multiple_of_23?()}"
      )
      |> log_and_passthrough("Next marble: #{marble_game.next_marble}")
      |> update_scores()
      |> log_and_passthrough("Update marbles - START")
      |> update_marbles()
      |> log_and_passthrough("Update marbles -  END ")
      |> update_current_player()
    end

    defp log_and_passthrough(thing, message) do
      Logger.debug(message)
      thing
    end

    @type direction() :: :clockwise | :anticlockwise
    @spec index_from_current(MarbleGame.t(), non_neg_integer(), direction()) :: integer()
    def index_from_current(marble_game, offset, :anticlockwise),
      do: index_from_current(marble_game, -offset, :clockwise)

    def index_from_current(marble_game, offset, :clockwise) do
      %{current_round: round, current_marble: current_marble} = marble_game

      round
      |> Enum.find_index(&(&1 == current_marble))
      |> Kernel.+(offset)
      |> index_in_circle(length(round))
    end

    defp index_in_circle(candidate_index, current_round_length) do
      case {candidate_index < current_round_length, candidate_index >= 0} do
        {true, true} ->
          candidate_index

        {false, _} ->
          index_in_circle(
            candidate_index - current_round_length,
            current_round_length
          )

        {_, false} ->
          index_in_circle(
            candidate_index + current_round_length,
            current_round_length
          )
      end
    end


    @spec update_scores(MarbleGame.t()) :: MarbleGame.t()
    def update_scores(marble_game) do
      %{current_player: player, scores: scores, next_marble: next_marble} = marble_game

      if next_marble |> is_multiple_of_23?() do
        seventh_anti_clockwise =
          Enum.at(marble_game.current_round, index_from_current(marble_game, 7, :anticlockwise))

        %{
          marble_game
          | scores: Map.update!(scores, player, &(&1 + next_marble + seventh_anti_clockwise))
        }
      else
        marble_game
      end
    end

    @spec update_marbles(MarbleGame.t()) :: MarbleGame.t()
    def update_marbles(marble_game) do
      %{current_round: round, next_marble: next, scored_marbles: scored} = marble_game

      if marble_game.next_marble |> is_multiple_of_23?() do
        seventh_anticlockwise_from_current = index_from_current(marble_game, 7, :anticlockwise)
        current_marble = Enum.at(round, index_from_current(marble_game, 6, :anticlockwise))

        %{
          marble_game
          | current_round: List.delete_at(round, seventh_anticlockwise_from_current),
            current_marble: current_marble,
            next_marble: next_marble(marble_game),
            scored_marbles:
              scored
              |> MapSet.put(next)
              |> MapSet.put(Enum.at(round, seventh_anticlockwise_from_current))
        }
      else
        next_clockwise_from_current = index_from_current(marble_game, 1, :clockwise)

        %{
          marble_game
          | current_round: insert_after(round, next, next_clockwise_from_current),
            current_marble: next,
            next_marble: next + 1
        }
      end
    end

    def update_current_player(%{current_player: current, number_of_players: num} = marble_game),
      do: %{marble_game | current_player: rem(current, num) + 1}

    defp insert_after(round, marble, index_to_insert_after) do
      List.insert_at(round, index_to_insert_after + 1, marble)
    end

    defp is_multiple_of_23?(marble), do: rem(marble, 23) == 0

    defp next_marble(marble_game) do
      %{
        scored_marbles: scored,
        current_round: round,
        current_marble: current,
        next_marble: next
      } = marble_game

      all_used_marbles =
        round
        |> MapSet.new()
        |> MapSet.union(scored)
        |> MapSet.put(next)

      do_next_marble(current + 1, all_used_marbles)
    end

    defp do_next_marble(candidate_next_marble, already_used_marbles) do
      if not Enum.member?(already_used_marbles, candidate_next_marble) do
        candidate_next_marble
      else
        do_next_marble(candidate_next_marble + 1, already_used_marbles)
      end
    end
  end

  @behaviour Solution

  def solve_part_1(input_as_string) do
    first_line =
      input_as_string
      |> String.split("\n")
      |> List.first()

    %{"num_of_players" => players, "target_marble" => target} =
      ~r/(?<num_of_players>\d+) players; last marble is worth (?<target_marble>\d+) points/
      |> Regex.named_captures(first_line)
      |> Map.new(fn {capture, value} -> {capture, String.to_integer(value)} end)

    players
    |> MarbleGame.new()
    |> iterate_until_target_current_marble_is_reached(target)
    |> Map.get(:scores)
    |> Enum.map(fn {_player, score} -> score end)
    |> Enum.max()
    |> Integer.to_string()
  end

  def iterate_until_target_current_marble_is_reached(marble_game, target_marble) do
    if marble_game.current_marble == target_marble do
      marble_game
    else
      marble_game
      |> MarbleGame.play_round()
      |> iterate_until_target_current_marble_is_reached(target_marble)
    end
  end

  def solve_part_2(_input_as_string) do
    "TODO"
  end
end
