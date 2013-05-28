require "spec_helper"

describe "using the server api" do
  context "with credentials are present" do
    Given(:home) {Pathname(set_env "HOME", File.expand_path(current_dir))}
    Given do
      File.open(home.join('.netrc'), "w") do |f|
        f.chmod 0600
        f.puts "machine api.rackspace.com"
        f.puts "  login #{ENV['RACKSPACE_LOGIN'] || '<rackspace-username>'}"
        f.puts "  password #{ENV['RACKSPACE_API_TOKEN'] || '<rackspace-api-token>'}"
      end
    end
    context "when I list all my servers (and I don't have any')" do
      When {VCR.use_cassette('show-servers') {run "rax show servers"}}
      Then {all_stdout =~ /you don't have any servers/}
      And {last_exit_status.should eql 0}
    end
    context "when I create a server" do
      When {VCR.use_cassette('create-server') {run "rax create server"}}
      Then {all_stdout =~ /created server (\w+)/}
      And {last_exit_status.should eql 0}
    end
    context "when I show a server" do
      When {VCR.use_cassette('show-server') {run "rax show server divine-reef"}}
      Then {last_exit_status.should eql 0}
    end
    context "when I destroy a server that exists" do
      When {VCR.use_cassette('destroy-server') {run "rax destroy server divine-reef"}}
      Then {all_stdout =~ /destruction/}
      And {last_exit_status.should eql 0}
    end
  end
  context "without credentials"
end
