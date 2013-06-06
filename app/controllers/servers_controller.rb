class ServersController < MVCLI::Controller
  requires :compute
  requires :naming
  requires :command

  def index
    compute.servers.all
  end

  def show
    #What if you have two or more servers with the same name?
    server
  end

  def create
    #Add personalization
    options = {
      name: naming.generate_name('s', 's'),
      flavor_id: 2,
      image_id: '9922a7c7-5a42-4a56-bc6a-93f857ae2346',
      private_key_path: "~/.ssh/id_rsa",
      public_key_path: "~/.ssh/id_rsa.pub"
    }
    command.output.puts "--> bootstrapping server #{options[:name]}"
    #Progress bar
    server = compute.servers.bootstrap options
    command.output.puts "    done."
    return server
  end

  def destroy
    server.tap do |s|
      s.destroy
    end
  end

  private

  def server
    index.find {|s| s.name == params[:id]} or fail Fog::Errors::NotFound
  end

  def generate_name
    'divine-reef'
  end

  def ssh
    test = server
    ip_address = test.ipv4_address
    exec "ssh root@#{ip_address} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q"
  end
end
