class VolumesController < MVCLI::Controller
  requires :compute
  requires :volumes
  requires :naming

  def index
    volumes.all
  end

  def show
    volume
  end

  def create
    options = {
      display_name: naming.generate_name(nil, nil),
      volume_type: "SATA",
      size: 100
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
