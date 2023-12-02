input = File.new "input.txt"

# Part 1
lines = input.readlines(chomp: true)
result = lines.map do |line|
    first = line.match(/\d/)[0]
    last = line.reverse.match(/\d/)[0]
    (first + last).to_i
end.sum
puts "The result for part 1 is #{result}"

# Part 2
WORD_DIGITS = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
REVERSED_WORD_DIGITS = WORD_DIGITS.map do |word| word.reverse end

def value(number, dictionary)
    if number.match? /\d/
        number
    else
        (dictionary.index(number) + 1).to_s
    end
end

regex = Regexp.new("\\d|" + WORD_DIGITS.join("|"))
reverse_regex = Regexp.new("\\d|" + REVERSED_WORD_DIGITS.join("|"))
result = lines.map do |line|
    first = value(line.match(regex)[0], WORD_DIGITS)
    last = value(line.reverse.match(reverse_regex)[0], REVERSED_WORD_DIGITS)
    (first + last).to_i
end.sum

puts "The result for part 2 is #{result}"