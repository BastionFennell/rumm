class InstancesController < MVCLI::Controller

  requires :instances
  requires :naming

  def index
    instances.all
  end

  def show
    instance
  end

  def create
    options = {
      name: naming.generate_name('d', 'i'),
      flavor_id: 1,
      volume_size: 1,
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
    index.find {|i| i.name == params[:id]} or fail Fog::Errors::NotFound
  end
end
