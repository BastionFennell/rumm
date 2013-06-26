require "ipaddr"

class Loadbalancers::CreateForm < MVCLI::Form
  requires :naming

  input :name, String, default: -> {naming.generate_name 'l', 'b'}

  input :port, Integer, default: 80, decode: ->(s) {Integer s}

  input :protocol, String, default: 'HTTP', decode: :upcase

  input :virtual_ips, [String], default: ['PUBLIC']

  input :nodes, [Node], required: true do
    input :address, IPAddr, required: true, decode: ->(s) {IPAddr.new s}
    input :port, Integer, default: 80, decode: ->(s) {Integer s}
    input :type, String, default: 'PRIMARY', decode: :upcase
    input :condition, String, default: 'ENABLED', decode: :upcase

    validates(:port, "port must be between 0 and 65,535") {|port| port >= 0 && port <= 65535}
    validates(:type, "invalid type") {|type| ['PRIMARY', 'SECONDARY'].member? type}
    validates(:condition, "invalid condition") {|c| ['ENABLED', 'DISABLED'].member? c}
  end

  validates(:nodes, "at least one node must be enabled") { |nodes|
    nodes.any? {|n| n.condition == 'ENABLED'}
  }

  output do |form|
    form.attributes.merge attrs = {
      virtual_ips: form.virtual_ips.map {|t| Map(type: t)},
      nodes: form.nodes.map(&:attributes)
    }
  end
end
