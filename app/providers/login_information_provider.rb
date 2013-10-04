require 'io/console'

class LoginInformationProvider
  requires :command
  requires :configuration

  def value
    name = get_name
    password = get_password
    region = get_default_region
    Map name: name, password: password, region: region
  end

  private

  def get_name
    command.output.print "Username: "
    command.input.gets.chomp
  end

  def get_password
    command.output.print "Password: "
    password = command.input.noecho(&:gets).chomp
    command.output.print "\n"
    password
  end

  def get_default_region
    command.output.print "Default Region (Enter for #{configuration.region}): "
    region = command.input.gets.chomp
    region.empty? ? configuration.region : region
  end

end
