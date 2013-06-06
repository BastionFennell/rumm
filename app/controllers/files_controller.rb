class FilesController < MVCLI::Controller
  requires :containers

  def index
    container.all
  end

  def create
    options = {
      :key  => params[:id],
      :body => File.open(File.expand_path "nouns.txt")
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
    File.open((File.expand_path "download-" + params[:id]), 'w') do | f |
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
