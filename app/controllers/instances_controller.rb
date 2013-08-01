class InstancesController < MVCLI::Controller

  requires :instances
  requires :command

  def index
    instances.all
  end

  def show
    instance.reload
  end

  def create
    template = Instances::CreateForm
    argv = MVCLI::Argv.new command.argv
    form = template.new argv.options
    form.validate!

    #How expansive do we want these command line options to be?
    options = {
      name: form.name,
      flavor_id: form.flavor,
      volume_size: form.size
    }
    instances.create options
  end

  def destroy
    instance.tap do |i|
      i.destroy
    end
  end

  private

  def instance
    @instance ||= index.find {|i| i.name == params[:id]} or fail Fog::Errors::NotFound
  end
end
