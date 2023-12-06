input = File.new "input.txt", chomp: true
lines = input.readlines(chomp: true)

seeds = lines.shift.split(": ")[1].split(" ").map { |i| i.to_i }

maps = []
lines.shift
while not lines.empty?
    title = lines.shift
    raise "No title found in line #{title}" unless title.match? /\:/

    map = {
        name: title.split(" ")[0],
        ranges: [],
    }
    while not (line = lines.shift).nil? and not line.empty?
        parts = line.split(" ").map { |i| i.to_i }
        map[:ranges] << {
            destination_start: parts[0],
            source_start: parts[1],
            range: parts[2],
        }
    end
    map[:ranges].sort! { |a, b| a[:source_start] - b[:source_start] }
    maps << map
end

def find_min_seed(seeds, maps)
    current_products = seeds.dup
    maps.each do |map|
        current_products.map! do |product|
            # Could use bsearch instead.
            range = map[:ranges].find { |range|
                (range[:source_start]...range[:source_start] + range[:range]).include? product
            }
            next product unless range
            range[:destination_start] + product - range[:source_start]
        end
    end

    current_products.min
end

# Part 1.
puts "The result of part 1 is #{find_min_seed(seeds, maps)}"

# Part 2.
# Segments are [a..b], inclusive on both ends.

# Convert the ranges into segments.
segments = maps.map do |map|
    map[:ranges].map do |range|
        {
            a: range[:source_start],
            b: range[:source_start] + range[:range] - 1,
            value: range[:destination_start] - range[:source_start]
        }
    end
end

# Add zero-value segments in between. This makes the math easier later.
segments.each do |segments|
    new_segments = []
    segments.each_cons(2) do |s|
        next unless s[0][:b] + 1 < s[1][:a]
        new_segments << {a: s[0][:b] + 1, b: s[1][:a] - 1, value: 0}
    end
    segments.concat(new_segments)
    segments.unshift({a: -Float::INFINITY, b: segments[0][:a] - 1, value: 0})
    segments << {a: segments[-1][:b] + 1, b: Float::INFINITY, value: 0}
end

# Convert the seeds into segments.
segments.unshift([])
seeds.each_slice(2) do |range|
    segments[0] << {
        a: range[0],
        b: range[0] + range[1] - 1,
        value: 0,
    }
end

def intersect(s1, s2)
    if s1[:b] < s2[:a] or s2[:b] < s1[:a]
        # Segments outside each other.
        nil
    elsif s1[:a] <= s2[:a] and s1[:b] >= s2[:b]
        # s1 contains s2
        s2.dup
    elsif s2[:a] <= s1[:a] and s2[:b] >= s1[:b]
        # s2 contains s1
        s1.dup
    elsif s1[:a] <= s2[:a]
        # s1 left of s2
        { a: s2[:a], b: s1[:b] }
    else
        raise unless s2[:a] <= s1[:a]
        # s1 right of s2
        { a: s1[:a], b: s2[:b] }
    end
end

def merge(left, right)
    intersections = []
    left.each do |s1|
        right.each do |s2|
            intersection = intersect(s1, {a: s2[:a] - s1[:value], b: s2[:b] - s1[:value]})
            next unless intersection
            intersection[:value] = s1[:value] + s2[:value]
            intersections << intersection
        end
    end
    intersections
end

merged = segments.shift()
while right = segments.shift()
    merged = merge(merged, right)
end

result = merged.map do |segment|
    segment[:a] + segment[:value]
end.min

puts "The result of part 2 is #{result}"