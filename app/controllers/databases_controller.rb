class DatabasesController < MVCLI::Controller

  requires :instances
  requires :databases
  requires :naming

  def index
    d = databases
    d.instance = instance
    d.all
  end

  def show
    d = databases
    d.instance = instance
    find_database_in d
  end

  def create
    d = databases
    d.instance = instance
    d.create ({name: "naming"})
  end

  def destroy
    d = databases
    d.instance = instance
    find_database_in(d).destroy
    :id
  end

  private

  def instance
    instances.find{|i| i.name == params[:instance_id]} or fail Fog::Errors::NotFound
  end

  def find_database_in instance
    instance.find{|d| d.name == params[:id]} or fail Fog::Errors::NotFound
  end
end
