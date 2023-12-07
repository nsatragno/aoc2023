def calculate_wins(time, distance)
    time = time.to_i
    distance = distance.to_i
    root = Math.sqrt((time ** 2) - 4 * distance)
    min = ((-time + root) / -2).ceil
    max = ((-time - root) / -2).floor

    min += 1 if min * (time - min) == distance
    max -= 1 if max * (time - max) == distance
    max - min + 1
end

input = File.new("input.txt", chomp: true)
  .readlines(chomp: true)
  .map{ |line| line.split().drop(1)}

# Part 1.
result = input.reduce(&:zip)
  .map do |time, distance|
    calculate_wins(time, distance)
end.reduce {|a, b| a * b}

puts "The result for part 1 is #{result}"

# Part 2.
time = input[0].join("")
distance = input[1].join("")
result = calculate_wins(time, distance)

puts "The result for part 2 is #{result}"