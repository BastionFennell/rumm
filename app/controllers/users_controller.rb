class UsersController < MVCLI::Controller
  requires :instances
  requires :command

  def index
    instance.users.all
  end

  def create
    template = Users::CreateForm
    argv = MVCLI::Argv.new command.argv
    form = template.new argv.options
    form.validate!
    instance.users.create form.value
  end

  private

  def instance
    instances.all.find {|i| i.name == params[:dbinstance_id]} or fail Fog::Errors::NotFound
  end
end
