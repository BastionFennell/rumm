class ServersController < MVCLI::Controller
  requires :compute

  def index
    compute.servers.all
  end

  def show
    server
  end

  def create
    options = {
      name: generate_name,
      flavor_id: 2,
      image_id: '9922a7c7-5a42-4a56-bc6a-93f857ae2346'
    }
    compute.servers.create options
  end

  def destroy
    server.tap do |s|
      s.destroy
    end
  end

  private

  def server
    index.find {|s| s.name == params[:id]} or fail Fog::Errors::NotFound
  end

  def generate_name
    'divine-reef'
  end
end
