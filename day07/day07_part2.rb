class Hand
  attr_reader :bid, :hand

  include Comparable

  FIVE_OF_A_KIND = 6
  FOUR_OF_A_KIND = 5
  FULL_HOUSE = 4
  THREE_OF_A_KIND = 3
  TWO_PAIR = 2
  ONE_PAIR = 1
  HIGH_CARD = 0

  VALUES = [
    "A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"
  ].reverse

  def initialize(line)
    parts = line.split(" ")
    @hand = parts[0].each_char.map { |card| VALUES.index card }
    @bid = parts[1].to_i
  end

  def type
    cards = {}
    jokers = 0
    @hand.each do |card|
      if card == 0
        jokers += 1
        next
      end
      if cards[card]
        cards[card] += 1
      else
        cards[card] = 1
      end
    end
    cards = cards.sort { |a, b| b[1] - a[1] }
                 .map { |card, count| count }
    return FIVE_OF_A_KIND if jokers == 5
    return FIVE_OF_A_KIND if cards[0] + jokers == 5
    return FOUR_OF_A_KIND if cards[0] + jokers == 4
    return FULL_HOUSE if cards[0] + jokers == 3 and cards[1] == 2
    return FULL_HOUSE if cards[0] == 3 and cards[1] + jokers == 2
    return THREE_OF_A_KIND if cards[0] + jokers == 3
    return TWO_PAIR if cards[0] + jokers == 2 and cards[1] == 2
    return ONE_PAIR if cards[0] + jokers == 2
    HIGH_CARD
  end

  def <=>(other)
    return self.type - other.type unless self.type == other.type
    self.hand <=> other.hand
  end
end

result = File.new("input.txt", chomp: true)
  .readlines(chomp: true)
  .map {|line| Hand.new line}
  .sort()
  .to_enum
  .with_index
  .map {|card, rank| card.bid * (rank + 1)}
  .sum

puts "The result is #{result}"