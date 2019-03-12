defmodule Solution.Day9 do
  alias Solution.Day9.MarbleGame
  alias Solution.Day9.Circle
  require Logger

  defmodule MarbleGame do
    defstruct number_of_players: 0,
              current_player: 1,
              current_round: Circle.new([0]),
              next_marble: 1,
              scored_marbles: %{}

    @spec new(integer()) :: Solution.Day9.MarbleGame.t()
    def new(number_of_players) do
      initial_scored_marbles =
        1..number_of_players
        |> Enum.map(fn player -> {player, MapSet.new()} end)
        |> Map.new()

      %__MODULE__{
        scored_marbles: initial_scored_marbles,
        number_of_players: number_of_players
      }
    end

    def current_marble(%MarbleGame{current_round: round}) do
      Circle.current(round)
    end

    @spec play_round(MarbleGame.t()) :: MarbleGame.t()
    def play_round(%{next_marble: next} = marble_game) do
      is_next_marble_multiple_of_23? = is_multiple_of_23?(next)
      Logger.debug("#{MarbleGame.current_marble(marble_game)}")

      marble_game
      |> update_current_round(is_next_marble_multiple_of_23?)
      |> update_next_marble(is_next_marble_multiple_of_23?)
      |> update_current_player()
    end

    @spec score(MarbleGame.t(), pos_integer()) :: non_neg_integer()
    def score(%MarbleGame{scored_marbles: scored}, player) do
      scored
      |> Map.get(player)
      |> Enum.sum()
    end

    #######################
    ## Private functions ##
    #######################
    defp update_current_round(marble_game, next_marble_is_multiple_of_23)

    defp update_current_round(%{next_marble: next} = marble_game, false) do
      %{
        marble_game
        | current_round:
            marble_game.current_round
            |> Circle.rotate(1, :clockwise)
            |> Circle.insert_after_current(next)
      }
    end

    defp update_current_round(%{next_marble: next} = marble_game, true) do
      circle_on_scored_marble =
        marble_game.current_round
        |> Circle.rotate(7, :anticlockwise)

      scored = Circle.current(circle_on_scored_marble)

      scored_marbles =
        marble_game.scored_marbles
        |> Map.update!(marble_game.current_player, fn scored_marbles_by_player ->
          scored_marbles_by_player
          |> MapSet.put(next)
          |> MapSet.put(scored)
        end)

      round =
        circle_on_scored_marble
        |> Circle.delete_current()

      %{
        marble_game
        | current_round: round,
          scored_marbles: scored_marbles
      }
    end

    defp update_next_marble(marble_game, next_marble_is_multiple_of_23)

    defp update_next_marble(marble_game, false),
      do: %{marble_game | next_marble: marble_game.next_marble + 1}

    defp update_next_marble(marble_game, true),
      do: %{marble_game | next_marble: next_marble(marble_game)}

    defp update_current_player(%{current_player: current, number_of_players: num} = marble_game),
      do: %{marble_game | current_player: rem(current, num) + 1}

    defp is_multiple_of_23?(marble), do: rem(marble, 23) == 0

    defp next_marble(marble_game) do
      %{
        scored_marbles: scored,
        current_round: round,
        next_marble: next
      } = marble_game

      all_scored =
        scored
        |> Map.values()
        |> Enum.reduce(
          MapSet.new(),
          fn player_scored_marbles, all_scored_marbles ->
            MapSet.union(all_scored_marbles, player_scored_marbles)
          end
        )

      all_used_in_round =
        round
        |> Circle.to_list()
        |> MapSet.new()

      all_used_marbles =
        all_used_in_round
        |> MapSet.union(all_scored)
        |> MapSet.put(next)

      do_next_marble(MarbleGame.current_marble(marble_game) + 1, all_used_marbles)
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

    finished_game =
      players
      |> MarbleGame.new()
      |> iterate_until_target_current_marble_is_reached(target)

    1..players
    |> Enum.map(&MarbleGame.score(finished_game, &1))
    |> Enum.max()
    |> Integer.to_string()
  end

  def iterate_until_target_current_marble_is_reached(marble_game, target_marble) do
    if MarbleGame.current_marble(marble_game) == target_marble do
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
