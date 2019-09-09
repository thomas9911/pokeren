defmodule PokerenElixirTest do
  use ExUnit.Case
  # doctest PokerenElixir

  # test "greets the world" do
  #   assert PokerenElixir.hello() == :world
  # end

  # test "equals four" do
  #   assert PokerenElixir.four() == 4
  # end

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

end
