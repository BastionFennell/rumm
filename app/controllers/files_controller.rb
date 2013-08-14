class FilesController < MVCLI::Controller
  requires :containers
  requires :command

  def index
    container.all
  end

  def create
    template = Files::CreateForm
    argv = MVCLI::Argv.new command.argv
    form = template.new argv.options
    form.validate!

    options = {
      :key  => params[:id],
      :body => form.file
    }
    container.create options
  end

  def show
    file
  end

  def destroy
    file.destroy
  end

  def download
    template = Files::DownloadForm
    argv = MVCLI::Argv.new command.argv
    form = template.new argv.options
    form.validate!

    File.open(form.destination, 'w') do | f |
      container.get(params[:id]) do | data, remaining, content_length |
        f.syswrite data
      end
    end
  end

  private

  def container
    containers.find{|c| c.key == params[:container_id]}.files or fail Fog::Errors::NotFound
  end

  def file
    container.find{|f| f.key == params[:id]} or fail Fog::Errors::NotFound
  end
end
