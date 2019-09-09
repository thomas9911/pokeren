# defmodule PokerenElixir do
#   @moduledoc """
#   Documentation for PokerenElixir.
#   """

#   @doc """
#   Hello world.

#   ## Examples

#       iex> PokerenElixir.hello()
#       :world

#   """
#   def hello do
#     :world
#   end

#   def four do
#     2 + 2
#   end
# end

require Logger

defmodule Hand do
  @enforce_keys [:cards]
  defstruct [:cards]

  def parse(txt) do
    cards_txt = String.split(String.trim(txt), " ")

    try do
      if length(cards_txt) != 5 do
        raise HandError, message: "Hand should have five cards"
      end

      {cards_results, card_errors} = map_card_errors(cards_txt, [], [])

      if length(card_errors) != 0 do
        raise HandError, message: Enum.join(card_errors, ", ")
      end

      {:ok, %Hand{cards: cards_results}}
    rescue
      e in HandError -> {:error, e.message}
    end
  end

  defp map_card_errors([head | tail], results, errors) do
    case Card.parse(head) do
      {:ok, x} ->
        map_card_errors(tail, results ++ List.wrap(x), errors)

      {:error, _} ->
        map_card_errors(tail, results, errors ++ List.wrap("'#{head}' is not a valid card"))
    end
  end

  defp map_card_errors([], results, errors) do
    {results, errors}
  end
end

defmodule Card do
  @enforce_keys [:suite, :value]
  defstruct [:suite, :value]

  def parse(txt) do
    try do
      case String.length(txt) do
        2 ->
          suite = String.at(txt, 1)

          unless String.contains?(suite, ["H", "S", "D", "C"]) do
            raise HandError
          end

          value = String.at(txt, 0)

          unless String.contains?(value, [
                   "2",
                   "3",
                   "4",
                   "5",
                   "6",
                   "7",
                   "8",
                   "9",
                   "T",
                   "J",
                   "Q",
                   "K",
                   "A"
                 ]) do
            raise HandError
          end

          {:ok, %Card{suite: suite, value: value}}

        _ ->
          raise HandError
      end
    rescue
      _e in HandError ->
        {:error, "Cards have to form \"{value}{suite}\" for example \"2H\" is Two of Hearts"}
    end
  end
end

defmodule HandError do
  defexception message: "Something went wrong"
end

defmodule HandOutcome do
  def card_order() do
    %{
      "2" => 0,
      "3" => 1,
      "4" => 2,
      "5" => 3,
      "6" => 4,
      "7" => 5,
      "8" => 6,
      "9" => 7,
      "T" => 8,
      "J" => 9,
      "Q" => 10,
      "K" => 11,
      "A" => 12
    }
  end

  def sort_cards(hand) do
    %Hand{
      cards: Enum.sort(hand.cards, &(card_order()[&1.value] < card_order()[&2.value]))
    }
  end

  def get_flush(hand) do
    # case MapSet.size(MapSet.new(Enum.map(hand.cards, fn x -> x.suite end))) do
    case Enum.map(hand.cards, fn x -> x.suite end) |> MapSet.new() |> MapSet.size() do
      1 -> {true, Enum.at(HandOutcome.sort_cards(hand).cards, -1)}
      _ -> {false, nil}
    end
  end

  def get_straight(hand) do
    values = Enum.map(HandOutcome.sort_cards(hand).cards, fn x -> x.value end)
    differences = Enum.zip(Enum.slice(values, 0..-2), Enum.slice(values, 1..-1)) |> Enum.map(fn x -> card_order()[elem(x, 1)] - card_order()[elem(x, 0)] end)
    case differences do
      [1,1,1,1] -> {true, Enum.at(HandOutcome.sort_cards(hand).cards, -1)}
      _ -> {false, nil}
    end
  end

end

# defmodule PokerenElixir do
#   use Application

#   def start(_type, _args) do
#     # IO.puts "starting"
#     # black = IO.gets("Black: ")
#     # white = IO.gets("White: ")

#     # IO.puts(black)

#     # black_hand = case Hand.parse(black) do
#     #   {:ok, body}      -> body
#     #   {:error, reason} -> IO.puts("Error: #{reason}")
#     #   exit(1)
#     # end
#     hand = %Hand{
#       cards: [
#         %Card{suite: "H", value: "2"},
#         %Card{suite: "H", value: "5"},
#         %Card{suite: "H", value: "3"},
#         %Card{suite: "H", value: "4"},
#         %Card{suite: "H", value: "6"}
#       ]
#     }

#     bla = HandOutcome.sort_cards(hand)

#     IO.puts(bla)
#     # IO.puts("OKEE: #{black_hand}")
#     # some more stuff
#     Task.start(fn -> :timer.sleep(1000); IO.puts("done sleeping") end)
#     # exit(0)
#   end
# end
