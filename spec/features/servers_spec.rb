require "spec_helper"

describe "using the server api" do
  context "with credentials are present" do
    Given(:home) {Pathname(set_env "HOME", File.expand_path(current_dir))}
    Given do
      File.open(home.join('.netrc'), "w") do |f|
        f.chmod 0600
        f.puts "machine api.rackspace.com"
        f.puts "  login #{ENV['RACKSPACE_USERNAME'] || '<rackspace-username>'}"
        f.puts "  password #{ENV['RACKSPACE_API_KEY'] || '<rackspace-api-key>'}"
      end
    end
    context "when I list all my servers (and I don't have any')" do
      When {VCR.use_cassette('show-servers') {run "rumm show servers"}}
      Then {all_stdout =~ /you don't have any servers/}
      And {last_exit_status.should eql 0}
    end
    context "when I create a server" do
      When {VCR.use_cassette('create-server') {run "rumm create server --name silly-saffron"}}
      Then {all_stdout =~ /created server (\w+)/}
      And {last_exit_status.should eql 0}
    end
    context "when I show a server" do
      When {VCR.use_cassette('show-server') {run "rumm show server silly-saffron"}}
      Then {last_exit_status.should eql 0}
    end
    context "when I destroy a server that exists" do
      When {VCR.use_cassette('destroy-server') {run "rumm destroy server silly-saffron"}}
      Then {all_stdout =~ /destruction/}
      And {last_exit_status.should eql 0}
    end
  end
end
