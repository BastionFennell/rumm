class AttachmentsController < MVCLI::Controller
  requires :compute
  requires :volumes
  requires :command

  def index
    #Maybe it would be best to give better information about the
    #attachments?
    #Maybe list the volume information rather than attachment info
    compute.servers.all.find {|s| s.name == params[:server_id]}.attachments.all
  end

  def attach
    template = Attachments::GenericForm
    argv = MVCLI::Argv.new command.argv
    form = template.new argv.options
    form.validate!

    server = form.server
    server.attach_volume form.volume
  end

  def detach
    template = Attachments::GenericForm
    argv = MVCLI::Argv.new command.argv
    form = template.new argv.options
    form.validate!

    attachment(form.server, form.volume).detach
  end

  def show
    attachment attachment(params[:server_id], params[:id])
  end

  private

  def volume volume_name
    volumes.all.find {|v| v.display_name == volume_name} or fail Fog::Errors::NotFound
  end

  def attachment server, volume
    server.attachments.find {|attachments| attachments == volume} or fail Fog::Errors::NotFound
  end
end
