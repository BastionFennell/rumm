class ContainersController < MVCLI::Controller
  requires :containers
  requires :command

  def index
    containers.all
  end

  def create
    template = Containers::CreateForm
    argv = MVCLI::Argv.new command.argv
    form = template.new argv.options
    form.validate!

    options = {
      key: form.name
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
