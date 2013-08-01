class VolumesController < MVCLI::Controller
  requires :volumes
  requires :command

  def index
    volumes.all
  end

  def show
    volume
  end

  def create
    template = Volumes::CreateForm
    argv = MVCLI::Argv.new command.argv
    form = template.new argv.options
    form.validate!

    options = {
      display_name: form.name,
      volume_type: form.type,
      size: form.size
    }
    volumes.create options
  end

  def destroy
    #Must be detached from servers
    volume.tap do |v|
      v.destroy
    end
  end

  private

  def volume
    index.find {|v| v.display_name == params[:id]} or fail Fog::Errors::NotFound
  end
end
