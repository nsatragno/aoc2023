input = File.new "input.txt", chomp: true
lines = input.readlines(chomp: true)

# Part 1.
adjacent = Set.new
lines.each_with_index do |line, y|
    line.each_char.with_index do |character, x|
        next if character.match? /\d|\./
        [-1, 0, 1].each do |dx|
            [-1, 0, 1].each do |dy|
                adjacent << { x: x + dx, y: y + dy}
            end
        end
    end
end

sum = 0
lines.each_with_index do |line, y|
    current_number = ""
    is_adjacent = false
    line.each_char.with_index do |character, x|
        if character.match? /\d/
            current_number << character
            is_adjacent = true if adjacent.include?({x: x, y: y})
        else
            if not current_number.empty? and is_adjacent
                sum += current_number.to_i
            end
            current_number = ""
            is_adjacent = false
        end
    end
    if not current_number.empty? and is_adjacent
        sum += current_number.to_i
    end
end

puts "The result for part 1 is #{sum}"

# Part 2.
gears = []
gear_map = {}
lines.each_with_index do |line, y|
    line.each_char.with_index do |character, x|
        gear_map[{x: x, y: y}] = []
    end
end
lines.each_with_index do |line, y|
    line.each_char.with_index do |character, x|
        next unless character.match? /\*/
        gear = {
            neighbours: 0,
            value: 1
        }
        gears << gear
        [-1, 0, 1].each do |dx|
            [-1, 0, 1].each do |dy|
                gear_map[{ x: x + dx, y: y + dy}] << gear
            end
        end
    end
end

lines.each_with_index do |line, y|
    current_number = ""
    gears_adjacent = Set.new
    line.each_char.with_index do |character, x|
        if character.match? /\d/
            current_number << character
            gears_adjacent.merge(gear_map[{x: x, y: y}])
        else
            if not current_number.empty?
                gears_adjacent.each do |gear|
                    gear[:neighbours] += 1
                    gear[:value] *= current_number.to_i
                end
            end
            current_number = ""
            gears_adjacent = Set.new
        end
    end
    if not current_number.empty?
        gears_adjacent.each do |gear|
            gear[:neighbours] += 1
            gear[:value] *= current_number.to_i
        end
    end
end

result = gears.filter do |gear|
    gear[:neighbours] == 2
end.map do |gear|
    gear[:value]
end.sum

puts "The result for part 2 is #{result}"