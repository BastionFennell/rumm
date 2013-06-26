class RailsificationsController < MVCLI::Controller
  requires :compute
  requires :naming
  requires :command

  def create
    #add to Gemfile
    #gem 'knife-solo', '>= 0.3.0pre3'
    #gem 'berkshelf'

    `mkdir chef-kitchen`
    `bundle update`
    `cd chef-kitchen && bundle exec knife solo init .`

    f = File.new("chef-kitchen/Berksfile", 'w')
    f.puts("site :opscode")
    f.puts("")
    f.puts("cookbook 'runit', '>= 1.1.2'")
    f.puts("cookbook 'rackbox'")
    f.close

    `cd chef-kitchen && bundle exec berks install --path cookbooks/`
    `cd chef-kitchen && bundle exec knife solo prepare root@#{server.ipv4_address}`

    f = File.open('chef-kitchen/nodes/host.json', 'w')
    f.puts('{"run_list":["rackbox"],"rackbox":{"apps":{"unicorn":[{"appname":"app1","hostname":"app1"}]},"ruby":{"global_version":"2.0.0-p195","versions":["2.0.0-p195"]}}}')
    f.close

    `rm chef-kitchen/nodes/#{server.ipv4_address}.json`
    `mv  chef-kitchen/nodes/host.json chef-kitchen/nodes/#{server.ipv4_address}.json`

    `cd chef-kitchen && bundle exec knife solo cook root@#{server.ipv4_address}`

    return server
  end

  private

  def server
    compute.servers.find {|s| s.name == params[:id]} or fail Fog::Errors::NotFound
  end
end