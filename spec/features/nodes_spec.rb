require "spec_helper"

describe "using the nodes api" do
  $id = "test"
  include_context "netrc"

  context "to create" do
    When { VCR.use_cassette('nodes/create') { run "rumm create node on loadbalancer laughing-barrel --address 198.61.221.220 --condition ENABLED --port: 80" }}
    Then { all_stdout =~ /Created node/ }
    And { last_exit_status.should eql 0 }

    after do
      $id = all_stdout.match(/\d+/)[0]
    end
  end


  context "to show" do
    When { VCR.use_cassette('nodes/show') { run "rumm show node #{$id} on loadbalancer laughing-barrel" }}
    Then { all_stdout =~ /id:/ }
    And { last_exit_status.should eql 0 }
  end

  context "to show all" do
    When { VCR.use_cassette('nodes/show-all') { run "rumm show nodes on loadbalancer laughing-barrel" }}
    Then { all_stdout =~ /Nodes/}
    And { last_exit_status.should eql 0 }
  end

  context "to destroy" do
    When { VCR.use_cassette('nodes/destroy') { run "rumm destroy node #{$id} on loadbalancer laughing-barrel" }}
    Then { all_stdout =~ /Destroyed/}
    And { last_exit_status.should eql 0 }
  end
end
