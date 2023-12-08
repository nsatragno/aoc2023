lines = File.new("input.txt", chomp: true)
  .readlines(chomp: true)

instructions = lines.shift().split("").map do |c|
  c.to_sym
end
lines.shift()

paths = {}
lines.each do |line|
  parts = line.split(" = (")
  from = parts[0]
  parts = parts[1].chop().split(", ")
  paths[from] = {
    "L": parts[0],
    "R": parts[1],
  }
end

#cur = "AAA"
#i = 0
#loop do
  #cur = paths[cur][instructions[i % instructions.size]]
  #i += 1
  #break if cur == "ZZZ"
#end

#p i

currents = paths.keys.filter {|key| key.end_with? "A" }

currents = currents.map do |cur|
  i = 0
  loop do
    cur = paths[cur][instructions[i % instructions.size]]
    i += 1
    break if cur.end_with? "Z"
  end
  i
end

r = currents.reduce(1) { |lcm, cur| lcm.lcm(cur) }
p r