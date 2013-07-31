class AttachmentsController < MVCLI::Controller
  requires :compute
  requires :volumes
  requires :command

  def index
    #Maybe it would be best to give better information about the
    #attachments?
    #Maybe list the volume information rather than attachment info
    form = get_form Attachments::ShowAllForm

    form.server.attachments.all
  end

  def attach
    form = get_form Attachments::AttachDetachShowForm

    server = form.server
    server.attach_volume form.volume
  end

  def detach
    form = get_form Attachments::AttachDetachShowForm

    attachment(form.server, form.volume).detach
  end

  def show
    form = get_form Attachments::AttachDetachShowForm

    attachment(form.server, form.volume)
  end

  private

  def get_form template
    argv = MVCLI::Argv.new command.argv
    form = template.new argv.options
    form.validate!

    form
  end

  def attachment server, volume
    server.attachments.find {|attachments| attachments.volume_id == volume.id} or fail Fog::Errors::NotFound
  end
end
