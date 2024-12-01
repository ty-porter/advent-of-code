require_relative "../../utils.rb"
require_relative "solution.rb"

pt1_test_signals = [
  ["D2FE28", 6],
  ["38006F45291200", 9],
  ["EE00D40C823060", 14],
  ["8A004A801A8002F478", 16],
  ["620080001611562C8802118E34", 12],
  ["C0015000016115A2E0802F182340", 23],
  ["A0016C880162017C3686B18A3D4780", 31]
]

puts "PART 1 TESTS\n------------"
pt1_test_signals.each { |signal, expected| test(signal, part_1_solution(signal, printable: false), expected) }

pt2_test_signals = [
  ['C200B40A82', 3],
  ['04005AC33890', 54],
  ['880086C3E88112', 7],
  ['CE00C43D881120', 9],
  ['D8005AC2A8F0', 1],
  ['F600BC2D8F', 0],
  ['9C005AC2F8F0', 0],
  ['9C0141080250320F1802104A08', 1]
]

puts "\nPART 2 TESTS\n------------"
pt2_test_signals.each { |signal, expected| test(signal, part_2_solution(signal, printable: false), expected) }
