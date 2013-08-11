require "ipaddr"

class Nodes::CreateForm < MVCLI::Form
    input :address, String, required: true, decode: ->(s) { URI('').hostname = s }
    input :port, Integer, default: 80, decode: ->(s) {Integer s}
    input :type, String, default: 'PRIMARY', decode: :upcase
    input :condition, String, default: 'ENABLED', decode: :upcase

    validates(:port, "port must be between 0 and 65,535") {|port| port >= 0 && port <= 65535}
    validates(:type, "invalid type") {|type| ['PRIMARY', 'SECONDARY'].member? type}
    validates(:condition, "invalid condition") {|c| ['ENABLED', 'DISABLED'].member? c}
end
