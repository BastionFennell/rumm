require 'fog'
class InstanceProvider
  requires :instances

  def value
    instances.find {|i| i.name == params[:id]} or fail Fog::Errors::NotFound
  end
end
