import pytest

from main import *


def test_is_not_straight():
    not_straight = [("S", "7"), ("H", "8"), ("D", "9"), ("D", "T"), ("S", "2")]
    assert False == is_straight(not_straight)


def test_is_straight():
    straight = [("S", "7"), ("H", "8"), ("D", "9"), ("D", "T"), ("S", "J")]
    assert True == is_straight(straight)


def test_is_not_flush():
    not_flush = [("S", "7"), ("H", "8"), ("D", "9"), ("D", "T"), ("S", "2")]
    assert False == is_flush(not_flush)


def test_is_flush():
    flush = [("H", "7"), ("H", "8"), ("H", "9"), ("H", "T"), ("H", "2")]
    assert True == is_flush(flush)


def test_is_not_straight_flush():
    straight_flush = [("H", "7"), ("H", "8"), ("H", "9"), ("H", "T"), ("H", "5")]
    assert False == is_straight_flush(straight_flush)


def test_is_straight_flush():
    straight_flush = [("H", "7"), ("H", "8"), ("H", "9"), ("H", "T"), ("H", "6")]
    assert True == is_straight_flush(straight_flush)


def test_is_not_pair():
    not_pair = [("H", "7"), ("H", "8"), ("H", "9"), ("S", "T"), ("H", "6")]
    assert False == is_pair(not_pair)


def test_is_pair():
    pair = [("H", "7"), ("H", "8"), ("H", "9"), ("S", "9"), ("H", "6")]
    assert True == is_pair(pair)


def test_is_not_three_of_a_kind():
    not_three_of_a_kind = [("H", "7"), ("H", "8"), ("H", "9"), ("S", "9"), ("H", "6")]
    assert False == is_three_of_a_kind(not_three_of_a_kind)


def test_is_three_of_a_kind():
    three_of_a_kind = [("H", "7"), ("D", "9"), ("H", "9"), ("S", "9"), ("H", "6")]
    assert True == is_three_of_a_kind(three_of_a_kind)


def test_is_not_four_of_a_kind():
    not_four_of_a_kind = [("H", "7"), ("D", "9"), ("H", "9"), ("S", "9"), ("H", "6")]
    assert False == is_four_of_a_kind(not_four_of_a_kind)


def test_is_four_of_a_kind():
    four_of_a_kind = [("C", "9"), ("D", "9"), ("H", "9"), ("S", "9"), ("H", "6")]
    assert True == is_four_of_a_kind(four_of_a_kind)


def test_is_not_full_house():
    full_house = [("H", "6"), ("D", "7"), ("H", "9"), ("S", "9"), ("S", "7")]
    assert False == is_full_house(full_house)
    full_house = [("H", "9"), ("D", "9"), ("H", "9"), ("S", "9"), ("S", "7")]
    assert False == is_full_house(full_house)


def test_is_full_house():
    full_house = [("H", "7"), ("D", "7"), ("H", "9"), ("S", "9"), ("S", "7")]
    assert True == is_full_house(full_house)
    full_house = [("H", "7"), ("D", "9"), ("H", "9"), ("S", "9"), ("S", "7")]
    assert True == is_full_house(full_house)


def test_is_not_two_pair():
    full_house = [("H", "7"), ("D", "7"), ("H", "9"), ("S", "9"), ("S", "7")]
    assert False == is_two_pairs(full_house)
    four_of_a_kind = [("C", "9"), ("D", "9"), ("H", "9"), ("S", "9"), ("H", "6")]
    assert False == is_two_pairs(four_of_a_kind)
    pair = [("H", "7"), ("H", "8"), ("H", "9"), ("S", "9"), ("H", "6")]
    assert False == is_two_pairs(pair)


def test_is_two_pair():
    two_pairs = [("H", "7"), ("D", "7"), ("H", "9"), ("S", "9"), ("S", "8")]
    assert True == is_two_pairs(two_pairs)
    two_pairs = [("H", "7"), ("D", "9"), ("H", "7"), ("S", "9"), ("S", "6")]
    assert True == is_two_pairs(two_pairs)


def test_what_is_hand():
    two_pairs = [("H", "7"), ("D", "7"), ("H", "9"), ("S", "9"), ("S", "8")]
    full_house = [("H", "7"), ("D", "7"), ("H", "9"), ("S", "9"), ("S", "7")]
    three_of_a_kind = [("H", "7"), ("D", "9"), ("H", "9"), ("S", "9"), ("H", "6")]
    four_of_a_kind = [("C", "9"), ("D", "9"), ("H", "9"), ("S", "9"), ("H", "6")]
    pair = [("H", "7"), ("H", "8"), ("H", "9"), ("S", "9"), ("H", "6")]
    straight_flush = [("H", "7"), ("H", "8"), ("H", "9"), ("H", "T"), ("H", "6")]
    high_card = [("S", "7"), ("H", "8"), ("D", "9"), ("D", "T"), ("S", "2")]
    flush = [("H", "7"), ("H", "8"), ("H", "9"), ("H", "T"), ("H", "2")]
    straight = [("S", "7"), ("H", "8"), ("D", "9"), ("D", "T"), ("S", "J")]

    assert PokerHand.StraightFlush == what_is_hand(straight_flush)
    assert PokerHand.FourOfAKind == what_is_hand(four_of_a_kind)
    assert PokerHand.FullHouse == what_is_hand(full_house)
    assert PokerHand.Flush == what_is_hand(flush)
    assert PokerHand.Straight == what_is_hand(straight)
    assert PokerHand.ThreeOfAKind == what_is_hand(three_of_a_kind)
    assert PokerHand.TwoPairs == what_is_hand(two_pairs)
    assert PokerHand.Pair == what_is_hand(pair)
    assert PokerHand.HighCard == what_is_hand(high_card)


def test_from_hand_enum():
    full_house = [("H", "7"), ("D", "7"), ("H", "9"), ("S", "9"), ("S", "7")]
    assert PokerHand.FullHouse == PokerHand.from_hand(full_house)


def test_high_card_score():
    hand = [("S", "7"), ("H", "8"), ("D", "9"), ("D", "K"), ("S", "2")]
    assert 1107060500 == high_card_score(hand)
    hand = [("S", "7"), ("H", "8"), ("D", "9"), ("D", "K"), ("S", "A")]
    assert 1211070605 == high_card_score(hand)
    hand = [("S", "7"), ("H", "6"), ("D", "4"), ("D", "9"), ("S", "2")]
    assert 705040200 == high_card_score(hand)


def test_score_pair():
    pair = [("H", "7"), ("H", "8"), ("H", "9"), ("S", "9"), ("H", "6")]
    assert 7060504 == score_pair(pair)


def test_highest_most_common_card():
    hand = [("H", "7"), ("D", "9"), ("H", "9"), ("S", "9"), ("H", "6")]
    assert "9" == highest_most_common_card(hand)
    hand = [("H", "7"), ("D", "7"), ("H", "Q"), ("S", "Q"), ("S", "8")]
    assert "Q" == highest_most_common_card(hand)


def test_score():
    two_pairs = [("H", "7"), ("D", "7"), ("H", "9"), ("S", "9"), ("S", "8")]
    full_house = [("H", "7"), ("D", "7"), ("H", "9"), ("S", "9"), ("S", "7")]
    three_of_a_kind = [("H", "7"), ("D", "9"), ("H", "9"), ("S", "9"), ("H", "6")]
    four_of_a_kind = [("C", "9"), ("D", "9"), ("H", "9"), ("S", "9"), ("H", "6")]
    pair = [("H", "7"), ("H", "8"), ("H", "9"), ("S", "9"), ("H", "6")]
    straight_flush = [("H", "7"), ("H", "8"), ("H", "9"), ("H", "T"), ("H", "6")]
    high_card = [("S", "7"), ("H", "8"), ("D", "9"), ("D", "T"), ("S", "2")]
    flush = [("H", "7"), ("H", "8"), ("H", "9"), ("H", "T"), ("H", "2")]
    straight = [("S", "7"), ("H", "8"), ("D", "9"), ("D", "T"), ("S", "J")]

    assert 20000070506 == score(two_pairs)
    assert 60000000005 == score(full_house)
    assert 30000000007 == score(three_of_a_kind)
    assert 70000000007 == score(four_of_a_kind)
    assert 10007060504 == score(pair)
    assert 80807060504 == score(straight_flush)
    assert 807060500 == score(high_card)
    assert 50807060500 == score(flush)
    assert 40908070605 == score(straight)


def test_hand():
    two_pairs = Hand([("H", "7"), ("D", "7"), ("H", "9"), ("S", "9"), ("S", "8")])
    full_house = Hand([("H", "7"), ("D", "7"), ("H", "9"), ("S", "9"), ("S", "7")])

    assert two_pairs != full_house
    assert two_pairs < full_house


def test_hand_2():
    two_pairs = Hand([("H", "7"), ("D", "7"), ("H", "9"), ("S", "9"), ("S", "8")])
    two_pairs_2 = Hand([("H", "2"), ("D", "2"), ("D", "9"), ("C", "9"), ("S", "8")])

    assert two_pairs != two_pairs_2
    assert two_pairs > two_pairs_2


def test_parse_input():
    txt = "2H 3D 5S 9C KD"
    hand = [("H", "2"), ("D", "3"), ("S", "5"), ("C", "9"), ("D", "K")]
    assert hand == parse_input(txt)


def test_parse_input_2():
    with pytest.raises(HandError, match="Cards should have one symbol for suit and one symbol for value"):
        parse_input("123456789")

def test_parse_input_3():
    with pytest.raises(HandError, match="['KQ']"):
        parse_input("2H 3D 5S 9C KQ")

def test_parse_input_4():
    with pytest.raises(HandError, match="['1S', '9U']"):
        parse_input("2H 3D 1S 9U KD")

# test_is_straight()
# test_is_not_straight()
# test_is_not_flush()
# test_is_flush()
# test_is_not_straight_flush()
# test_is_straight_flush()
# test_is_not_pair()
# test_is_pair()
# test_is_not_three_of_a_kind()
# test_is_three_of_a_kind()
# test_is_not_four_of_a_kind()
# test_is_four_of_a_kind()
# test_is_not_full_house()
# test_is_full_house()
# test_is_not_two_pair()
# test_is_two_pair()
# test_what_is_hand()
# test_from_hand_enum()
# test_high_card_score()
# test_score_pair()
# test_highest_most_common_card()
# test_score()
# test_hand()
# test_hand_2()
