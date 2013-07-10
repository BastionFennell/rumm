require "ipaddr"

class Loadbalancers::CreateForm < MVCLI::Form
  requires :naming

  input :name, String, default: -> {naming.generate_name 'l', 'b'}

  input :port, Integer, default: 80, decode: ->(s) {Integer s}

  input :protocol, String, default: 'HTTP', decode: :upcase

  input :virtual_ips, [String], default: [Map(type: 'PUBLIC')], decode: ->(s) {Map(type: s.upcase)}

  input :nodes, [Node], required: true do
    input :address, String, required: true, decode: ->(s) { URI('').hostname = s }
    input :port, Integer, default: 80, decode: ->(s) {Integer s}
    input :type, String, default: 'PRIMARY', decode: :upcase
    input :condition, String, default: 'ENABLED', decode: :upcase

    validates(:port, "port must be between 0 and 65,535") {|port| port >= 0 && port <= 65535}
    validates(:type, "invalid type") {|type| ['PRIMARY', 'SECONDARY'].member? type}
    validates(:condition, "invalid condition") {|c| ['ENABLED', 'DISABLED'].member? c}
  end

  validates(:port, "port must be between 0 and 65,535") {|port| port >=0 && port < 65535}

  validates(:nodes, "at least one node must be enabled", each: false) { |nodes|
    nodes.any? {|n| n.condition == 'ENABLED'}
  }
end
