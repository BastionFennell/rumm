require "spec_helper"

describe "using the server api" do
  context "with credentials are present" do

    include_context "netrc"

    context "when I list all my servers (and I don't have any')" do
      When {VCR.use_cassette('show-servers') {run "rumm show servers"}}
      Then {all_stdout =~ /you don't have any servers/}
      And {last_exit_status.should eql 0}
    end
    context "when I create a server" do
      Given { pending "we're having a timeout issue here'" }
      Given(:private_key) { home.join '.ssh/id_rsa' }
      Given do
        FileUtils.mkdir_p private_key.dirname, mode: 0700
        `echo -e "y\n" | ssh-keygen -t rsa -C "test@example.com" -N "testing" -f "#{private_key}"`
      end
      When {VCR.use_cassette('create-server') {run "rumm create server --name silly-saffron"}}
      Then {all_stdout =~ /created server/}
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
