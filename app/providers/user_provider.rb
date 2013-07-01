require 'io/console'

class UserProvider
  requires :command

  def value
    name = get_name
    password = get_password
    Map name: name, password: password
  end

  private

  def get_name
    command.output.print "Username: "
    command.input.gets.chomp
  end

  def get_password
    command.output.print "Password: "
    command.input.noecho(&:gets).chomp
  end
end
