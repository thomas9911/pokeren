import itertools
import random
import enum

SUITS = {"C", "D", "H", "S"}
VALUES = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]

_SUIT_KEY = 0
_VALUE_KEY = 1


class Hand:
    def __init__(self, hand):
        self.hand = hand

    def __eq__(self, other):
        return score(self.hand) == score(other.hand)

    def __gt__(self, other):
        return score(self.hand) > score(other.hand)

    def __lt__(self, other):
        return score(self.hand) < score(other.hand)

    def __ge__(self, other):
        return score(self.hand) >= score(other.hand)

    def __le__(self, other):
        return score(self.hand) <= score(other.hand)

    def poker_hand(self):
        return PokerHand.from_hand(self.hand)


class PokerHand(enum.IntEnum):
    HighCard = 0
    Pair = 1
    TwoPairs = 2
    ThreeOfAKind = 3
    Straight = 4
    Flush = 5
    FullHouse = 6
    FourOfAKind = 7
    StraightFlush = 8

    @staticmethod
    def from_hand(hand):
        return what_is_hand(hand)

    def name(self):
        return self._name_


# deck = list(itertools.product(SUITS, VALUES))

# assert 52 == len(deck)

# random.shuffle(deck)


# print(deck)

# hand_one = []
# hand_two = []

# for _ in range(5):
#     hand_one.append(deck.pop())
# for _ in range(5):
#     hand_two.append(deck.pop())


# print(hand_one)
# print(hand_two)


class HandError(Exception):
    pass


def what_is_hand(hand):
    if len(hand) != 5:
        raise HandError("hand has to have 5 cards")
    if is_straight_flush(hand):
        return PokerHand.StraightFlush
    if is_four_of_a_kind(hand):
        return PokerHand.FourOfAKind
    if is_full_house(hand):
        return PokerHand.FullHouse
    if is_flush(hand):
        return PokerHand.Flush
    if is_straight(hand):
        return PokerHand.Straight
    if is_three_of_a_kind(hand):
        return PokerHand.ThreeOfAKind
    if is_two_pairs(hand):
        return PokerHand.TwoPairs
    if is_pair(hand):
        return PokerHand.Pair
    return PokerHand.HighCard


def _sorted_indexes(hand):
    hand_values = sorted((x[_VALUE_KEY] for x in hand), key=VALUES.index)
    indexes = [VALUES.index(x) for x in hand_values]
    return indexes


def highest_most_common_card(hand):
    histogram = _count_hand(hand)
    p = sorted(histogram.items(), key=lambda x: (x[1], x[0]), reverse=True)
    return VALUES[p[0][0]]


def _count_hand(hand):
    indexes = _sorted_indexes(hand)
    histogram = {}
    for item in indexes:
        if item not in histogram:
            histogram[item] = 1
        else:
            histogram[item] += 1
    return histogram


def high_card_score(hand):
    indexes = _sorted_indexes(hand)
    return sum(item * 100 ** i for i, item in enumerate(indexes))


def score_pair(hand):
    histogram = _count_hand(hand)
    p = sorted(histogram.items(), key=lambda x: (x[1], x[0]))
    return sum(item[0] * 100 ** i for i, item in enumerate(p))


def score(hand):
    poker_hand = PokerHand.from_hand(hand)
    HANDSCORE = int(10e9)

    if poker_hand in [
        PokerHand.HighCard,
        PokerHand.Straight,
        PokerHand.Flush,
        PokerHand.StraightFlush,
    ]:
        high_score = high_card_score(hand)
        return poker_hand * HANDSCORE + high_score
    if poker_hand in [
        PokerHand.FullHouse,
        PokerHand.FourOfAKind,
        PokerHand.ThreeOfAKind,
    ]:
        card = highest_most_common_card(hand)
        high_score = VALUES.index(card)
        return poker_hand * HANDSCORE + high_score
    if poker_hand in [PokerHand.Pair, PokerHand.TwoPairs]:
        high_score = score_pair(hand)
        return poker_hand * HANDSCORE + high_score
    raise NotImplementedError()


def is_straight_flush(hand):
    if not is_flush(hand):
        return False
    if not is_straight(hand):
        return False
    return True


def is_flush(hand):
    suit = set(x[_SUIT_KEY] for x in hand)
    if len(suit) > 1:
        return False
    return True


def is_straight(hand):
    indexes = _sorted_indexes(hand)
    difference_between_cards = [x - y for x, y in zip(indexes[1:], indexes[:-1])]
    if difference_between_cards == [1, 1, 1, 1]:
        return True
    return False


def is_pair(hand):
    indexes = _sorted_indexes(hand)
    difference_between_cards = [x - y for x, y in zip(indexes[1:], indexes[:-1])]
    return 0 in difference_between_cards


def is_three_of_a_kind(hand):
    indexes = _sorted_indexes(hand)
    difference_between_cards = "".join(
        [str(x - y) for x, y in zip(indexes[1:], indexes[:-1])]
    )
    return "00" in difference_between_cards


def is_four_of_a_kind(hand):
    indexes = _sorted_indexes(hand)
    difference_between_cards = "".join(
        [str(x - y) for x, y in zip(indexes[1:], indexes[:-1])]
    )
    return "000" in difference_between_cards


def is_full_house(hand):
    indexes = _sorted_indexes(hand)
    difference_between_cards = "".join(
        [str(x - y) for x, y in zip(indexes[1:], indexes[:-1])]
    )
    if difference_between_cards.startswith("00"):
        if difference_between_cards.endswith("0"):
            return True
    if difference_between_cards.endswith("00"):
        if difference_between_cards.startswith("0"):
            return True
    return False


def is_two_pairs(hand):
    indexes = _sorted_indexes(hand)
    difference_between_cards = "".join(
        [str(x - y) for x, y in zip(indexes[1:], indexes[:-1])]
    )
    if "0" not in difference_between_cards:
        return False
    if "00" in difference_between_cards:
        return False

    if difference_between_cards.count("0") == 2:
        return True
    return False


def parse_input(txt):
    allowed_symbols = sorted(SUITS) + VALUES
    not_allowed = []
    cards = []

    for item in txt.split():
        if len(item) != 2:
            raise HandError(
                "Cards should have one symbol for suit and one symbol for value"
            )

        unformatted_card = []
        for t in item:
            if t not in allowed_symbols:
                break
            unformatted_card.append(t)

        card = [None, None]
        for t in unformatted_card:
            if t in VALUES:
                card[_VALUE_KEY] = t
            if t in SUITS:
                card[_SUIT_KEY] = t
        if None in card:
            not_allowed.append(item)
        else:
            cards.append(tuple(card))

    if not_allowed:
        raise HandError("{} are invalid cards".format(not_allowed))
    return cards


if __name__ == "__main__":
    try:
        black = parse_input(input("black: ").strip())
        white = parse_input(input("white: ").strip())

        b_hand = Hand(black)
        w_hand = Hand(white)

        if b_hand > w_hand:
            print("Black wins - {}".format(b_hand.poker_hand().name()))
        if b_hand < w_hand:
            print("White wins - {}".format(w_hand.poker_hand().name()))
        if b_hand == w_hand:
            print("Tie")
    except HandError as e:
        print(e)