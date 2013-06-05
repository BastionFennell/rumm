class NodesController < MVCLI::Controller
  requires :loadbalancers
  requires :nodes

  def index
    n = nodes
    n.load_balancer = load_balancer
    n.all
  end

  def show
    n = nodes
    n.load_balancer = load_balancer
    find_node_in n
  end

  def create
    n = nodes
    n.load_balancer = load_balancer
    options = {
      address: params[:ip_address],
      #address: "198.61.221.220",
      condition: "ENABLED",
      port: 80
    }
    n.create options
  end

  def destroy
    n = nodes
    n.load_balancer = load_balancer
    find_node_in(n).destroy
    :id
  end

  private

  def load_balancer
    loadbalancers.find{|l| l.name == params[:loadbalancer_id]} or fail Fog::Errors::NotFound
  end

  def find_node_in loadbalancer
    loadbalancer.find{|n| n.id.to_s == params[:id]} or fail Fog::Errors::NotFound
  end
end
