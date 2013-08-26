require "rumm/configuration"

class ConfigurationProvider
  
  def value
    @configuration ||= Rumm::Configuration.new
  end

end
