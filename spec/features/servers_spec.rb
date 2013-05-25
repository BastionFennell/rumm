require "spec_helper"

describe "using the server api" do
  context "with credentials are present" do
    Given(:home) {Pathname(set_env "HOME", File.expand_path(current_dir))}
    Given do
      File.open(home.join('.netrc'), "w") do |f|
        f.chmod 0600
        f.puts "machine api.rackspace.com"
        f.puts "  login <rackspace-login>"
        f.puts "  password <rackspace-api-token>"
        # f.puts "  login #{ENV['RACKSPACE_LOGIN']}"
        # f.puts "  password #{ENV['RACKSPACE_API_TOKEN']}"
      end
    end
    context "when I list all my servers" do
      When {VCR.use_cassette('show-servers') {run "rax show servers"}}
      Then {all_stdout =~ /you don't have any server'/}
      And {last_exit_status.should eql 0}
    end
  end
  context "without credentials"
end
