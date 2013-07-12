class RailsificationsController < MVCLI::Controller
  requires :compute
  requires :naming

  def create
    `mkdir chef-kitchen`
    `bundle update`
    execute('cd chef-kitchen && bundle exec knife solo init .')

    f = File.new("chef-kitchen/Berksfile", 'w')
    f.puts("site :opscode")
    f.puts("")
    f.puts("cookbook 'runit', '>= 1.1.2'")
    f.puts("cookbook 'rackbox', github: 'hayesmp/rackbox-cookbook'")
    f.close

    execute('cd chef-kitchen && bundle exec berks install --path cookbooks/')
    execute("cd chef-kitchen && bundle exec knife solo prepare root@#{server.ipv4_address}")

    f = File.open('chef-kitchen/nodes/host.json', 'w')
    f.puts('{"run_list":["rackbox"],"rackbox":{"apps":{"unicorn":[{"appname":"app1","hostname":"app1"}]},"ruby":{"global_version":"2.0.0-p195","versions":["2.0.0-p195"]}}}')
    f.close

    `rm chef-kitchen/nodes/#{server.ipv4_address}.json`
    `mv  chef-kitchen/nodes/host.json chef-kitchen/nodes/#{server.ipv4_address}.json`

    execute("cd chef-kitchen && bundle exec knife solo cook root@#{server.ipv4_address}")

    return server
  end

  def migrate_data(database_url)#mysql2://<username>:<password>@<dbinstance_hostname>/<database name>
    execute("scp db/development.sqlite3 root@#{server.ipv4_address}:/home/apps/app1/current/db/development.sqlite3")
    execute("ssh root@#{server.ipv4_address} 'cd /home/apps/app1/current/db && bundle exec taps server sqlite://development.sqlite3 templogin temppass -d & && bundle exec taps pull #{database_url} http://templogin:temppass@localhost:5000'")
  end

  private

  def execute(cmd)
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      while line = stdout.gets
        puts line
      end
      exit_status = wait_thr.value
      unless exit_status.success?
        abort "FAILED !!! #{cmd}"
      end
    end
  end

  def server
    compute.servers.find {|s| s.name == params[:id]} or fail Fog::Errors::NotFound
  end
end