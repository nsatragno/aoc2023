lines = File.new("input.txt", chomp: true)
  .readlines(chomp: true)

sequences = lines.map do |line|
  sequence = [line.split(" ").map { |num| num.to_i }].reverse
  while not sequence[-1].all? { |num| num == 0 }
    sequence << sequence[-1].each_cons(2).map { |a, b| b - a }
  end
  sequence
end

result1 = sequences.map do |sequence|
  sequence.reverse.map do |seq|
    seq[-1]
  end.sum
end.sum

p result1

result2 = sequences.map do |sequence|
  sequence.reverse.map do |seq|
    seq[0]
  end.reduce {|a, b| b - a}
end.sum

p result2