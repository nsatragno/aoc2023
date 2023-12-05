input = File.new "input.txt", chomp: true
lines = input.readlines(chomp: true)

# Part 1.
result = lines.map do |line|
    parts = line.split(":")[1].split("|")
    winning = parts[0].split(" ").reduce(Set.new) do |set, num|
        set << num.to_i
    end
    playing = parts[1].split(" ").reduce(Set.new) do |set, num|
        set << num.to_i
    end
    winning_count = winning.intersection(playing).size
    next 0 if winning_count == 0
    2 ** (winning_count - 1)
end.sum

puts "The result for part 1 is #{result}"

# Part 2.
# Parse the cards into the number of winning numbers
cards = lines.map do |line|
    parts = line.split(":")[1].split("|")
    winning = parts[0].split(" ").reduce(Set.new) do |set, num|
        set << num.to_i
    end
    playing = parts[1].split(" ").reduce(Set.new) do |set, num|
        set << num.to_i
    end
    {copies: 1, winning: winning.intersection(playing).size}
end

cards.each_with_index do |card, index|
    # Safe as we always update ahead.
    (0...card[:copies]).each do |_|
        (0...card[:winning]).each do |winning|
            cards[index + winning + 1][:copies] += 1
        end
    end
end

result = cards.reduce(0) do |sum, card|
    sum + card[:copies]
end

puts "The result of part 2 is #{result}"