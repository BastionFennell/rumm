class LoadbalancersController < MVCLI::Controller
  requires :loadbalancers
  requires :command

  def index
    loadbalancers.all
  end

  def show
    balancer
  end

  def create
    template = Loadbalancers::CreateForm
    argv = MVCLI::Argv.new command.argv
    form = template.new argv.options
    form.validate!
    loadbalancers.create form.value
  end

  def destroy
    balancer.tap do |b|
      b.destroy
    end
  end

  private

  def balancer
    index.find {|s| s.name == params[:id]} or fail Fog::Erors::NotFound
  end
end
