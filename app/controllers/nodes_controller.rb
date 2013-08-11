class NodesController < MVCLI::Controller
  requires :loadbalancers
  requires :nodes
  requires :command

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
    template = Nodes::CreateForm
    argv = MVCLI::Argv.new command.argv
    form = template.new argv.options
    form.validate!

    n = nodes
    n.load_balancer = load_balancer
    options = {
      address: form.address,
      condition: form.condition,
      port: form.port,
      type: form.type
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
