class Loadbalancers::Node
  attr_reader :address
  attr_reader :port
  attr_reader :type
  attr_reader :condition

  def initialize(attrs = {})
    @address, @port, @type, @condition = *attrs.values_at(:address, :port, :type, :condition)
  end
end
