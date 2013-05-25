class ServersController
  requires :compute

  def index
    compute.servers.all
  end

  def show
    server
  end

  def create
    compute.servers.create name: generate_name
  end

  def destroy
    server.destroy
  end

  private

  def server
    index.find {|s| s.name == params[:id]} or fail Fog::Errors::NotFound
  end

  def generate_name
    'divine-reef'
  end
end
