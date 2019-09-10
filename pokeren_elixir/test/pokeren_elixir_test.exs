defmodule PokerenElixirTest do
  use ExUnit.Case
  # doctest PokerenElixir

  # test "greets the world" do
  #   assert PokerenElixir.hello() == :world
  # end

  # test "equals four" do
  #   assert PokerenElixir.four() == 4
  # end

  def high_card() do
    %Hand{
      cards: [
        %Card{suite: "C", value: "2"},
        %Card{suite: "S", value: "8"},
        %Card{suite: "H", value: "6"},
        %Card{suite: "H", value: "J"},
        %Card{suite: "D", value: "7"}
      ]
    }
  end

  def high_card2() do
    %Hand{
      cards: [
        %Card{suite: "C", value: "3"},
        %Card{suite: "S", value: "8"},
        %Card{suite: "H", value: "5"},
        %Card{suite: "H", value: "J"},
        %Card{suite: "D", value: "7"}
      ]
    }
  end

  def pair() do
    %Hand{
      cards: [
        %Card{suite: "C", value: "2"},
        %Card{suite: "S", value: "6"},
        %Card{suite: "H", value: "6"},
        %Card{suite: "H", value: "J"},
        %Card{suite: "D", value: "7"}
      ]
    }
  end

  def two_pair() do
    %Hand{
      cards: [
        %Card{suite: "C", value: "9"},
        %Card{suite: "S", value: "6"},
        %Card{suite: "H", value: "6"},
        %Card{suite: "H", value: "J"},
        %Card{suite: "D", value: "9"}
      ]
    }
  end

  def two_pair2() do
    %Hand{
      cards: [
        %Card{suite: "C", value: "9"},
        %Card{suite: "S", value: "6"},
        %Card{suite: "H", value: "6"},
        %Card{suite: "H", value: "7"},
        %Card{suite: "D", value: "9"}
      ]
    }
  end

  def two_pair3() do
    %Hand{
      cards: [
        %Card{suite: "C", value: "9"},
        %Card{suite: "S", value: "6"},
        %Card{suite: "H", value: "6"},
        %Card{suite: "H", value: "2"},
        %Card{suite: "D", value: "9"}
      ]
    }
  end

  def three_of_a_kind() do
    %Hand{
      cards: [
        %Card{suite: "C", value: "6"},
        %Card{suite: "S", value: "6"},
        %Card{suite: "H", value: "6"},
        %Card{suite: "H", value: "J"},
        %Card{suite: "D", value: "Q"}
      ]
    }
  end

  def three_of_a_kind2() do
    %Hand{
      cards: [
        %Card{suite: "C", value: "6"},
        %Card{suite: "S", value: "6"},
        %Card{suite: "H", value: "6"},
        %Card{suite: "H", value: "4"},
        %Card{suite: "D", value: "Q"}
      ]
    }
  end

  def three_of_a_kind3() do
    %Hand{
      cards: [
        %Card{suite: "C", value: "6"},
        %Card{suite: "S", value: "6"},
        %Card{suite: "H", value: "6"},
        %Card{suite: "H", value: "5"},
        %Card{suite: "D", value: "3"}
      ]
    }
  end

  def four_of_a_kind() do
    %Hand{
      cards: [
        %Card{suite: "C", value: "6"},
        %Card{suite: "S", value: "6"},
        %Card{suite: "H", value: "6"},
        %Card{suite: "H", value: "5"},
        %Card{suite: "D", value: "6"}
      ]
    }
  end

  def four_of_a_kind2() do
    %Hand{
      cards: [
        %Card{suite: "C", value: "6"},
        %Card{suite: "S", value: "6"},
        %Card{suite: "H", value: "6"},
        %Card{suite: "H", value: "K"},
        %Card{suite: "D", value: "6"}
      ]
    }
  end

  def flush() do
    %Hand{
      cards: [
        %Card{suite: "H", value: "A"},
        %Card{suite: "H", value: "5"},
        %Card{suite: "H", value: "3"},
        %Card{suite: "H", value: "4"},
        %Card{suite: "H", value: "6"}
      ]
    }
  end

  def full_house() do
    %Hand{
      cards: [
        %Card{suite: "C", value: "A"},
        %Card{suite: "S", value: "6"},
        %Card{suite: "H", value: "6"},
        %Card{suite: "H", value: "A"},
        %Card{suite: "D", value: "6"}
      ]
    }
  end

  def straight() do
    %Hand{
      cards: [
        %Card{suite: "S", value: "7"},
        %Card{suite: "D", value: "5"},
        %Card{suite: "H", value: "3"},
        %Card{suite: "C", value: "4"},
        %Card{suite: "H", value: "6"}
      ]
    }
  end

  def straight_flush() do
    %Hand{
      cards: [
        %Card{suite: "S", value: "7"},
        %Card{suite: "S", value: "5"},
        %Card{suite: "S", value: "3"},
        %Card{suite: "S", value: "4"},
        %Card{suite: "S", value: "6"}
      ]
    }
  end

  def straight_flush2() do
    %Hand{
      cards: [
        %Card{suite: "H", value: "A"},
        %Card{suite: "H", value: "Q"},
        %Card{suite: "H", value: "K"},
        %Card{suite: "H", value: "T"},
        %Card{suite: "H", value: "J"}
      ]
    }
  end

  test "card parses correctly" do
    assert Card.parse("2H") == {:ok, %Card{suite: "H", value: "2"}}
  end

  test "card parses incorrectly" do
    assert Card.parse("H2") ==
             {:error, "Cards have to form \"{value}{suite}\" for example \"2H\" is Two of Hearts"}
  end

  test "card parses incorrectly2" do
    assert Card.parse("testing") ==
             {:error, "Cards have to form \"{value}{suite}\" for example \"2H\" is Two of Hearts"}
  end

  test "card parses incorrectly3" do
    assert Card.parse("QQ") ==
             {:error, "Cards have to form \"{value}{suite}\" for example \"2H\" is Two of Hearts"}
  end

  test "hand parse correctly" do
    assert Hand.parse("2H 3H 4H 5H 6H\n") ==
             {:ok,
              %Hand{
                cards: [
                  %Card{suite: "H", value: "2"},
                  %Card{suite: "H", value: "3"},
                  %Card{suite: "H", value: "4"},
                  %Card{suite: "H", value: "5"},
                  %Card{suite: "H", value: "6"}
                ]
              }}
  end

  test "hand parse incorrectly length" do
    assert Hand.parse("2H 3H 4H\n") ==
             {:error, "Hand should have five cards"}
  end

  test "hand parse incorrectly invalid cards" do
    assert Hand.parse("2H 3H 4H 1 test\n") ==
             {:error, "'1' is not a valid card, 'test' is not a valid card"}
  end

  test "sort cards works" do
    hand = %Hand{
      cards: [
        %Card{suite: "H", value: "A"},
        %Card{suite: "D", value: "5"},
        %Card{suite: "H", value: "3"},
        %Card{suite: "C", value: "4"},
        %Card{suite: "H", value: "6"}
      ]
    }

    sorted_hand = %Hand{
      cards: [
        %Card{suite: "H", value: "3"},
        %Card{suite: "C", value: "4"},
        %Card{suite: "D", value: "5"},
        %Card{suite: "H", value: "6"},
        %Card{suite: "H", value: "A"}
      ]
    }

    assert HandOutcome.sort_cards(hand) == sorted_hand
  end

  test "get pair should return cards if hand is pair" do
    hand = pair()

    assert HandOutcome.get_pair(hand) ==
             {true,
              {%Card{suite: "S", value: "6"}, %Card{suite: "H", value: "J"},
               %Card{suite: "D", value: "7"}, %Card{suite: "C", value: "2"}}}
  end

  test "get pair should return false if hand is not pair" do
    hand = straight()
    assert HandOutcome.get_pair(hand) == {false, nil}
  end

  test "get two pair should return cards if hand is two pair" do
    hand = two_pair()

    assert HandOutcome.get_two_pair(hand) ==
             {true,
              {%Card{suite: "C", value: "9"}, %Card{suite: "S", value: "6"},
               %Card{suite: "H", value: "J"}}}

    hand = two_pair2()

    assert HandOutcome.get_two_pair(hand) ==
             {true,
              {%Card{suite: "C", value: "9"}, %Card{suite: "S", value: "6"},
               %Card{suite: "H", value: "7"}}}

    hand = two_pair3()

    assert HandOutcome.get_two_pair(hand) ==
             {true,
              {%Card{suite: "C", value: "9"}, %Card{suite: "S", value: "6"},
               %Card{suite: "H", value: "2"}}}
  end

  test "get two pair should return false if hand is not two pair" do
    hand = straight()
    assert HandOutcome.get_two_pair(hand) == {false, nil}
  end

  test "get three of a kind should return cards if hand is three of a kind" do
    hand = three_of_a_kind()

    assert HandOutcome.get_three_of_a_kind(hand) ==
             {true,
              {%Card{suite: "C", value: "6"}, %Card{suite: "D", value: "Q"},
               %Card{suite: "H", value: "J"}}}

    hand = three_of_a_kind2()

    assert HandOutcome.get_three_of_a_kind(hand) ==
             {true,
              {%Card{suite: "C", value: "6"}, %Card{suite: "D", value: "Q"},
               %Card{suite: "H", value: "4"}}}

    hand = three_of_a_kind3()

    assert HandOutcome.get_three_of_a_kind(hand) ==
             {true,
              {%Card{suite: "C", value: "6"}, %Card{suite: "H", value: "5"},
               %Card{suite: "D", value: "3"}}}
  end

  test "get three of a kind should return false if hand is not three of a kind" do
    hand = straight()
    assert HandOutcome.get_three_of_a_kind(hand) == {false, nil}
  end

  test "get four of a kind should return cards if hand is four of a kind" do
    hand = four_of_a_kind()

    assert HandOutcome.get_four_of_a_kind(hand) ==
             {true, {%Card{suite: "C", value: "6"}, %Card{suite: "H", value: "5"}}}

    hand = four_of_a_kind2()

    assert HandOutcome.get_four_of_a_kind(hand) ==
             {true, {%Card{suite: "C", value: "6"}, %Card{suite: "H", value: "K"}}}
  end

  test "get four of a kind should return false if hand is not four of a kind" do
    hand = straight()
    assert HandOutcome.get_four_of_a_kind(hand) == {false, nil}
  end

  test "get flush should return card if hand is flush" do
    hand = flush()
    assert HandOutcome.get_flush(hand) == {true, %Card{suite: "H", value: "A"}}
  end

  test "get flush should return false if hand is not flush" do
    hand = straight()
    assert HandOutcome.get_flush(hand) == {false, nil}
  end

  test "get straight should return card if hand is straight" do
    hand = straight()
    assert HandOutcome.get_straight(hand) == {true, %Card{suite: "S", value: "7"}}
  end

  test "get straight should return false if hand is not straight" do
    hand = flush()
    assert HandOutcome.get_straight(hand) == {false, nil}
  end

  test "get straight_flush should return card if hand is straight flush" do
    hand = straight_flush()
    assert HandOutcome.get_straight_flush(hand) == {true, %Card{suite: "S", value: "7"}}
  end

  test "get straight_flush should return false if hand is not straight flush" do
    hand = flush()
    assert HandOutcome.get_straight_flush(hand) == {false, nil}
    hand = straight()
    assert HandOutcome.get_straight_flush(hand) == {false, nil}
  end

  test "get full house should return cards if hand is full house" do
    hand = full_house()

    assert HandOutcome.get_full_house(hand) ==
             {true, {%Card{suite: "S", value: "6"}, %Card{suite: "C", value: "A"}}}
  end

  test "get full house should return false if hand is not full house" do
    hand = flush()
    assert HandOutcome.get_full_house(hand) == {false, nil}
    hand = straight()
    assert HandOutcome.get_full_house(hand) == {false, nil}
    hand = four_of_a_kind()
    assert HandOutcome.get_full_house(hand) == {false, nil}
  end

  test "what is works for high card" do
    hand = high_card()

    assert HandOutcome.what_is(hand) ==
             {"High Card",
              {%Card{suite: "H", value: "J"}, %Card{suite: "S", value: "8"},
               %Card{suite: "D", value: "7"}, %Card{suite: "H", value: "6"},
               %Card{suite: "C", value: "2"}}}
  end

  test "what is works for pair" do
    hand = pair()

    assert HandOutcome.what_is(hand) ==
             {"Pair",
              {%Card{suite: "S", value: "6"}, %Card{suite: "H", value: "J"},
               %Card{suite: "D", value: "7"}, %Card{suite: "C", value: "2"}}}
  end

  test "what is works for two pair" do
    hand = two_pair()

    assert HandOutcome.what_is(hand) ==
             {"Two Pair",
              {%Card{suite: "C", value: "9"}, %Card{suite: "S", value: "6"},
               %Card{suite: "H", value: "J"}}}
  end

  test "what is works for three of a kind" do
    hand = three_of_a_kind()

    assert HandOutcome.what_is(hand) ==
             {"Three of a Kind",
              {%Card{suite: "C", value: "6"}, %Card{suite: "D", value: "Q"},
               %Card{suite: "H", value: "J"}}}
  end

  test "what is works for four of a kind" do
    hand = four_of_a_kind()

    assert HandOutcome.what_is(hand) ==
             {"Four of a Kind", {%Card{suite: "C", value: "6"}, %Card{suite: "H", value: "5"}}}
  end

  test "what is works for straight" do
    hand = straight()
    assert HandOutcome.what_is(hand) == {"Straight", %Card{suite: "S", value: "7"}}
  end

  test "what is works for straight flush" do
    hand = straight_flush()
    assert HandOutcome.what_is(hand) == {"Straight Flush", %Card{suite: "S", value: "7"}}
  end

  test "what is works for full house" do
    hand = full_house()

    assert HandOutcome.what_is(hand) ==
             {"Full House", {%Card{suite: "S", value: "6"}, %Card{suite: "C", value: "A"}}}
  end

  test "what is works for flush" do
    hand = flush()
    assert HandOutcome.what_is(hand) == {"Flush", %Card{suite: "H", value: "A"}}
  end

  test "compare hands straight flush - tie" do
    hand1 = straight_flush()
    hand2 = straight_flush()
    assert HandOutcome.compare_hands(hand1, hand2) == {"Straight Flush", nil, nil}
  end

  test "compare hands straight flush - right hand" do
    hand1 = straight_flush()
    hand2 = straight_flush2()

    assert HandOutcome.compare_hands(hand1, hand2) ==
             {"Straight Flush", nil, %Card{suite: "H", value: "A"}}
  end

  test "compare hands flush - full house" do
    hand1 = flush()
    hand2 = full_house()

    assert HandOutcome.compare_hands(hand1, hand2) ==
             {"Full House", nil, %Card{suite: "S", value: "6"}}
  end

  test "compare hands three of a kind - high card" do
    hand1 = three_of_a_kind()
    hand2 = high_card()

    assert HandOutcome.compare_hands(hand1, hand2) ==
             {"Three of a Kind", %Card{suite: "C", value: "6"}, nil}
  end

  test "compare hands high card - right" do
    hand1 = high_card()
    hand2 = high_card2()

    assert HandOutcome.compare_hands(hand1, hand2) ==
             {"High Card", %Card{suite: "H", value: "6"}, nil}
  end

  test "compare hands high card - tie" do
    hand1 = high_card()
    hand2 = high_card()
    assert HandOutcome.compare_hands(hand1, hand2) == {"High Card", nil, nil}
  end
end
