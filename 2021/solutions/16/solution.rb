def parse_packet(packet)
  $version += packet.shift(3).join.to_i(2)
  type      = packet.shift(3).join.to_i(2)

  if type == 4
    value = []
    
    while packet.shift == '1'
      value.append(*packet.shift(4))
    end
    value.append(*packet.shift(4))

    return [value.join.to_i(2), packet]
  else
    results = []

    if packet.shift == '0'
      subpacket_length = packet.shift(15).join.to_i(2)
      packet           = packet.shift(subpacket_length)

      until packet.empty?
        subresult, subpacket = parse_packet(packet)
        results << subresult
      end
    else
      subpacket_count = packet.shift(11).join.to_i(2)

      subpacket_count.times do
        subresult, subpacket = parse_packet(packet)
        results << subresult
      end
    end

    case type
      when 0 then [results.sum, packet]
      when 1 then [results.reduce(&:*), packet]
      when 2 then [results.min, packet]
      when 3 then [results.max, packet]
      when 5 then [results[0] > results[1] ? 1 : 0, packet]
      when 6 then [results[0] < results[1] ? 1 : 0, packet]
      when 7 then [results[0] == results[1] ? 1 : 0, packet]
    end
  end
end

def generate_packet(signal)
  signal.chars.map { |hex| hex.to_i(16).to_s(2).rjust(4, "0").chars }.flatten
end

def part_1_solution(signal, printable: true)
  $version = 0
  packet = generate_packet(signal)
  parse_packet(packet)

  puts "PART 1: #{$version}" if printable

  $version
end

def part_2_solution(signal, printable: true)
  packet = generate_packet(signal)
  output = parse_packet(packet).first

  puts "PART 2: #{output}" if printable

  output
end