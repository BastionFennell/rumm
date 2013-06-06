class AttachmentsController < MVCLI::Controller
  requires :compute
  requires :volumes

  def index
    #Maybe it would be best to give better information about the
    #attachments?
    #Maybe list the volume information rather than attachment info
    server.attachments.all
  end

  def attach
    server.attach_volume volume
  end

  def detach
    id = volume.id
    attachment(id).detach
  end

  def show
    id = volume.id
    attachment id
  end

  private

  def volume
    volumes.all.find {|v| v.display_name == params[:id]} or fail Fog::Errors::NotFound
  end

  def server
    compute.servers.all.find {|s| s.name == params[:server_id]} or fail Fog::Errors::NotFound
  end

  def attachment vol_id
    server.attachments.find {|a| a.volume_id == vol_id} or fail Fog::Errors::NotFound
  end
end
