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

  def get_high_card(hand) do
    Enum.reverse(HandOutcome.sort_cards(hand).cards) |> List.to_tuple()
  end

  def get_pair(hand) do
    values = Enum.map(HandOutcome.sort_cards(hand).cards, fn x -> x.value end)

    differences =
      Enum.zip(Enum.slice(values, 0..-2), Enum.slice(values, 1..-1))
      |> Enum.map(fn x -> card_order()[elem(x, 1)] - card_order()[elem(x, 0)] end)

    count_zeros = differences |> Enum.count(fn x -> x == 0 end)

    if count_zeros == 1 do
      card =
        Enum.at(
          HandOutcome.sort_cards(hand).cards,
          Enum.find_index(differences, fn x -> x == 0 end) + 1
        )

      cards =
        Enum.reverse(HandOutcome.sort_cards(hand).cards)
        |> Enum.filter(fn x -> x.value != card.value end)
        |> List.insert_at(0, card)

      {true, List.to_tuple(cards)}
    else
      {false, nil}
    end
  end

  def get_two_pair(hand) do
    values = Enum.map(HandOutcome.sort_cards(hand).cards, fn x -> x.value end)

    differences =
      Enum.zip(Enum.slice(values, 0..-2), Enum.slice(values, 1..-1))
      |> Enum.map(fn x -> card_order()[elem(x, 1)] - card_order()[elem(x, 0)] end)

    if differences |> Enum.count(fn x -> x == 0 end) == 2 do
      case differences do
        [0, _, _, 0] ->
          # 1, 4
          # 2
          {true,
           {Enum.at(HandOutcome.sort_cards(hand).cards, 4),
            Enum.at(HandOutcome.sort_cards(hand).cards, 1),
            Enum.at(HandOutcome.sort_cards(hand).cards, 2)}}

        [0, _, 0, _] ->
          # 1, 3
          # 4
          {true,
           {Enum.at(HandOutcome.sort_cards(hand).cards, 3),
            Enum.at(HandOutcome.sort_cards(hand).cards, 1),
            Enum.at(HandOutcome.sort_cards(hand).cards, 4)}}

        [_, 0, _, 0] ->
          # 2, 4
          # 0
          {true,
           {Enum.at(HandOutcome.sort_cards(hand).cards, 4),
            Enum.at(HandOutcome.sort_cards(hand).cards, 2),
            Enum.at(HandOutcome.sort_cards(hand).cards, 0)}}

        _ ->
          {false, nil}
      end
    else
      {false, nil}
    end
  end

  def get_three_of_a_kind(hand) do
    values = Enum.map(HandOutcome.sort_cards(hand).cards, fn x -> x.value end)

    differences =
      Enum.zip(Enum.slice(values, 0..-2), Enum.slice(values, 1..-1))
      |> Enum.map(fn x -> card_order()[elem(x, 1)] - card_order()[elem(x, 0)] end)

    if differences |> Enum.count(fn x -> x == 0 end) == 2 do
      case differences do
        [_, _, 0, 0] ->
          {true,
           {Enum.at(HandOutcome.sort_cards(hand).cards, 4),
            Enum.at(HandOutcome.sort_cards(hand).cards, 1),
            Enum.at(HandOutcome.sort_cards(hand).cards, 0)}}

        [_, 0, 0, _] ->
          {true,
           {Enum.at(HandOutcome.sort_cards(hand).cards, 3),
            Enum.at(HandOutcome.sort_cards(hand).cards, 4),
            Enum.at(HandOutcome.sort_cards(hand).cards, 0)}}

        [0, 0, _, _] ->
          {true,
           {Enum.at(HandOutcome.sort_cards(hand).cards, 2),
            Enum.at(HandOutcome.sort_cards(hand).cards, 4),
            Enum.at(HandOutcome.sort_cards(hand).cards, 3)}}

        _ ->
          {false, nil}
      end
    else
      {false, nil}
    end
  end

  def get_four_of_a_kind(hand) do
    values = Enum.map(HandOutcome.sort_cards(hand).cards, fn x -> x.value end)

    differences =
      Enum.zip(Enum.slice(values, 0..-2), Enum.slice(values, 1..-1))
      |> Enum.map(fn x -> card_order()[elem(x, 1)] - card_order()[elem(x, 0)] end)

    if differences |> Enum.count(fn x -> x == 0 end) == 3 do
      case differences do
        [_, 0, 0, 0] ->
          {true,
           {Enum.at(HandOutcome.sort_cards(hand).cards, 4),
            Enum.at(HandOutcome.sort_cards(hand).cards, 0)}}

        [0, 0, 0, _] ->
          {true,
           {Enum.at(HandOutcome.sort_cards(hand).cards, 3),
            Enum.at(HandOutcome.sort_cards(hand).cards, 4)}}

        _ ->
          {false, nil}
      end
    else
      {false, nil}
    end
  end

  def get_flush(hand) do
    case Enum.map(hand.cards, fn x -> x.suite end) |> MapSet.new() |> MapSet.size() do
      1 -> {true, Enum.at(HandOutcome.sort_cards(hand).cards, -1)}
      _ -> {false, nil}
    end
  end

  def get_full_house(hand) do
    values = Enum.map(HandOutcome.sort_cards(hand).cards, fn x -> x.value end)

    differences =
      Enum.zip(Enum.slice(values, 0..-2), Enum.slice(values, 1..-1))
      |> Enum.map(fn x -> card_order()[elem(x, 1)] - card_order()[elem(x, 0)] end)

    case differences do
      [0, 0, _, 0] ->
        {true,
         {Enum.at(HandOutcome.sort_cards(hand).cards, 2),
          Enum.at(HandOutcome.sort_cards(hand).cards, 4)}}

      [0, _, 0, 0] ->
        {true,
         {Enum.at(HandOutcome.sort_cards(hand).cards, 4),
          Enum.at(HandOutcome.sort_cards(hand).cards, 2)}}

      _ ->
        {false, nil}
    end
  end

  def get_straight(hand) do
    values = Enum.map(HandOutcome.sort_cards(hand).cards, fn x -> x.value end)

    differences =
      Enum.zip(Enum.slice(values, 0..-2), Enum.slice(values, 1..-1))
      |> Enum.map(fn x -> card_order()[elem(x, 1)] - card_order()[elem(x, 0)] end)

    case differences do
      [1, 1, 1, 1] -> {true, Enum.at(HandOutcome.sort_cards(hand).cards, -1)}
      _ -> {false, nil}
    end
  end

  def get_straight_flush(hand) do
    case get_flush(hand) do
      {true, _} -> get_straight(hand)
      {false, nil} -> {false, nil}
    end
  end

  def what_is(hand) do
    case get_straight_flush(hand) do
      {true, card} ->
        {"Straight Flush", card}

      {false, _} ->
        case get_full_house(hand) do
          {true, card} ->
            {"Full House", card}

          {false, _} ->
            case get_straight(hand) do
              {true, card} ->
                {"Straight", card}

              {false, _} ->
                case get_flush(hand) do
                  {true, card} ->
                    {"Flush", card}

                  {false, _} ->
                    case get_four_of_a_kind(hand) do
                      {true, card} ->
                        {"Four of a Kind", card}

                      {false, _} ->
                        case get_three_of_a_kind(hand) do
                          {true, card} ->
                            {"Three of a Kind", card}

                          {false, _} ->
                            case get_two_pair(hand) do
                              {true, card} ->
                                {"Two Pair", card}

                              {false, _} ->
                                case get_pair(hand) do
                                  {true, card} -> {"Pair", card}
                                  {false, _} -> {"High Card", get_high_card(hand)}
                                end
                            end
                        end
                    end
                end
            end
        end
    end
  end

  def compare_hands(hand1, hand2) do
    case {what_is(hand1), what_is(hand2)} do
      {{"Straight Flush", card1}, {"Straight Flush", card2}} ->
        t = "Straight Flush"
        compare_cards(t, card1, card2)

      {{"Straight Flush", card1}, _} ->
        t = "Straight Flush"
        {t, card1, nil}

      {_, {"Straight Flush", card2}} ->
        t = "Straight Flush"
        {t, nil, card2}

      {{"Full House", {card11, card12}}, {"Full House", {card21, card22}}} ->
        t = "Full House"

        case compare_cards(t, card11, card21) do
          {t, nil, nil} -> compare_cards(t, card12, card22)
          {t, x, y} -> {t, x, y}
        end

      {{"Full House", cards}, _} ->
        t = "Full House"
        {t, tuple_first(cards), nil}

      {_, {"Full House", cards}} ->
        t = "Full House"
        {t, nil, tuple_first(cards)}

      {{"Straight", card1}, {"Straight", card2}} ->
        t = "Straight"
        compare_cards(t, card1, card2)

      {{"Straight", card1}, _} ->
        t = "Straight"
        {t, card1, nil}

      {_, {"Straight", card2}} ->
        t = "Straight"
        {t, nil, card2}

      {{"Flush", card1}, {"Flush", card2}} ->
        t = "Flush"
        compare_cards(t, card1, card2)

      {{"Flush", card1}, _} ->
        t = "Flush"
        {t, card1, nil}

      {_, {"Flush", card2}} ->
        t = "Flush"
        {t, nil, card2}

      {{"Four of a Kind", {card11, card12}}, {"Four of a Kind", {card21, card22}}} ->
        t = "Four of a Kind"

        case compare_cards(t, card11, card21) do
          {t, nil, nil} -> compare_cards(t, card12, card22)
          {t, x, y} -> {t, x, y}
        end

      {{"Four of a Kind", cards}, _} ->
        t = "Four of a Kind"
        {t, tuple_first(cards), nil}

      {_, {"Four of a Kind", cards}} ->
        t = "Four of a Kind"
        {t, nil, tuple_first(cards)}

      {{"Three of a Kind", {card11, card12, card13}},
       {"Three of a Kind", {card21, card22, card23}}} ->
        t = "Three of a Kind"

        case compare_cards(t, card11, card21) do
          {t, nil, nil} ->
            case compare_cards(t, card12, card22) do
              {t, nil, nil} -> compare_cards(t, card13, card23)
              {t, x, y} -> {t, x, y}
            end

          {t, x, y} ->
            {t, x, y}
        end

      {{"Three of a Kind", cards}, _} ->
        t = "Three of a Kind"
        {t, tuple_first(cards), nil}

      {_, {"Three of a Kind", cards}} ->
        t = "Three of a Kind"
        {t, nil, tuple_first(cards)}

      {{"Two Pair", {card11, card12, card13}}, {"Two Pair", {card21, card22, card23}}} ->
        t = "Two Pair"

        case compare_cards(t, card11, card21) do
          {t, nil, nil} ->
            case compare_cards(t, card12, card22) do
              {t, nil, nil} -> compare_cards(t, card13, card23)
              {t, x, y} -> {t, x, y}
            end

          {t, x, y} ->
            {t, x, y}
        end

      {{"Two Pair", cards}, _} ->
        t = "Two Pair"
        {t, tuple_first(cards), nil}

      {_, {"Two Pair", cards}} ->
        t = "Two Pair"
        {t, nil, tuple_first(cards)}

      {{"Pair", {card11, card12, card13, card14}}, {"Pair", {card21, card22, card23, card24}}} ->
        t = "Pair"

        case compare_cards(t, card11, card21) do
          {t, nil, nil} ->
            case compare_cards(t, card12, card22) do
              {t, nil, nil} ->
                case compare_cards(t, card13, card23) do
                  {t, nil, nil} -> compare_cards(t, card14, card24)
                  {t, x, y} -> {t, x, y}
                end

              {t, x, y} ->
                {t, x, y}
            end

          {t, x, y} ->
            {t, x, y}
        end

      {{"Pair", cards}, _} ->
        t = "Pair"
        {t, tuple_first(cards), nil}

      {_, {"Pair", cards}} ->
        t = "Pair"
        {t, nil, tuple_first(cards)}

      {{"High Card", {card11, card12, card13, card14, card15}},
       {"High Card", {card21, card22, card23, card24, card25}}} ->
        t = "High Card"

        case compare_cards(t, card11, card21) do
          {t, nil, nil} ->
            case compare_cards(t, card12, card22) do
              {t, nil, nil} ->
                case compare_cards(t, card13, card23) do
                  {t, nil, nil} ->
                    case compare_cards(t, card14, card24) do
                      {t, nil, nil} -> compare_cards(t, card15, card25)
                      {t, x, y} -> {t, x, y}
                    end

                  {t, x, y} ->
                    {t, x, y}
                end

              {t, x, y} ->
                {t, x, y}
            end

          {t, x, y} ->
            {t, x, y}
        end

      {{"High Card", cards}, _} ->
        t = "High Card"
        {t, tuple_first(cards), nil}

      {_, {"High Card", cards}} ->
        t = "High Card"
        {t, nil, tuple_first(cards)}
    end
  end

  defp compare_cards(type, card1, card2) do
    cond do
      card_order()[card1.value] > card_order()[card2.value] -> {type, card1, nil}
      card_order()[card1.value] < card_order()[card2.value] -> {type, nil, card2}
      card_order()[card1.value] == card_order()[card2.value] -> {type, nil, nil}
    end
  end

  defp tuple_first(cards) do
    elem(cards, 0)
  end
end

defmodule PokerenElixir do
  use Application

  def print_card(card) do
    value =
      case card.value do
        "2" -> "Two"
        "3" -> "Three"
        "4" -> "Four"
        "5" -> "Five"
        "6" -> "Six"
        "7" -> "Seven"
        "8" -> "Eight"
        "9" -> "Nine"
        "T" -> "Ten"
        "J" -> "Jack"
        "Q" -> "Queen"
        "K" -> "King"
        "A" -> "Ace"
      end

    case card.suite do
      "H" -> "#{value} of Hearts"
      "C" -> "#{value} of Clubs"
      "S" -> "#{value} of Spades"
      "D" -> "#{value} of Diamonds"
    end
  end

  def start(_type, _args) do
    black = IO.gets("Black: ")
    white = IO.gets("White: ")

    black_hand =
      case Hand.parse(black) do
        {:ok, body} ->
          body

        {:error, reason} ->
          IO.puts("Error: #{reason}")
          exit(1)
      end

    white_hand =
      case Hand.parse(white) do
        {:ok, body} ->
          body

        {:error, reason} ->
          IO.puts("Error: #{reason}")
          exit(1)
      end

    case HandOutcome.compare_hands(black_hand, white_hand) do
      {_, nil, nil} -> IO.puts("Tie")
      {t, x, nil} -> IO.puts("Black wins with #{t} with #{print_card(x)}")
      {t, nil, x} -> IO.puts("White wins with #{t} with #{print_card(x)}")
    end

    Task.start(fn ->
      :timer.sleep(1000)
      IO.puts("done sleeping")
    end)
  end
end
