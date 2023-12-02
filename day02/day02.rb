input = File.new "input.txt", chomp: true

# Part 1
def is_impossible(pull)
    splits = pull.split(", ")
    splits.any? do |split|
        number = split.match(/\d+/)[0].to_i
        if split.match? "blue"
            number > 14
        elsif split.match? "green"
            number > 13
        elsif split.match? "red"
            number > 12
        else
            throw "unknown colour in line #{split}"
        end
    end
end

def parse(pull)
    result = {
        :red => 0,
        :green => 0,
        :blue => 0,
    }
    splits = pull.split(", ")
    splits.each do |split|
        number = split.match(/\d+/)[0].to_i
        if split.match? "blue"
            result[:blue] = number
        elsif split.match? "green"
            result[:green] = number
        elsif split.match? "red"
            result[:red] = number
        else
            throw "unknown colour in line #{split}"
        end
    end
    result
end

lines = input.readlines(chomp: true)
result = lines.filter do |line|
    parts = line.split(": ")
    pulls = parts[1].split("; ")
    pulls.none? do |pull|
        is_impossible(pull)
    end
end.map do |line|
    line.split(": ")[0].match(/\d+/)[0].to_i
end.sum

puts "Part 1 result: #{result}"

# Part 2
result = lines.map do |line|
    parts = line.split(": ")
    pulls = parts[1].split("; ")
    reduced = pulls.map do |pull|
        parse(pull)
    end.reduce do |first, second|
        {
            :red => [first[:red], second[:red]].max,
            :green => [first[:green], second[:green]].max,
            :blue => [first[:blue], second[:blue]].max,
        }
    end
    reduced[:red] * reduced[:green] * reduced[:blue]
end.sum

puts "Part 2 result: #{result}"