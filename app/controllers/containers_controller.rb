class ContainersController < MVCLI::Controller
  requires :containers
  requires :naming

  def index
    containers.all
  end

  def create
    options = {
      key: naming.generate_name(nil, nil)
    }
    containers.create options
  end

  def show
    directory
  end

  def destroy
    #Note, cannot destroy a container with files in it
    directory.tap do |d|
      d.destroy
    end
  end

  private

  def directory
    index.find {|d| d.key == params[:id]} or fail Fog::Errors::NotFound
  end
end
