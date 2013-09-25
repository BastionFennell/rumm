class UsersController < MVCLI::Controller
  requires :instances
  requires :users
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

  def show
    list = users
    list.instance = instance
    list.all.find { |u| u.name == params[:id] } or fail Fog::Errors::NotFound
  end

  def destroy
    list = users
    list.instance = instance
    user = list.all.find { |u| u.name == params[:id] }
    user.destroy or fail Fog::Errors::NotFound
  end


  private

  def instance
    instances.all.find {|i| i.name == params[:dbinstance_id]} or fail Fog::Errors::NotFound
  end
end
