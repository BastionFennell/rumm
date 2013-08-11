require "spec_helper"

describe "using the nodes api" do
  include_context "netrc"

  context "to create" do
    When { VCR.use_cassette('nodes/create') { run "rumm create node on loadbalancer laughing-barrel --address 198.61.221.220 --condition ENABLED --port: 80" }}
    Then { all_stdout =~ /Created node/ }
    And { last_exit_status.should eql 0 }
  end


  context "to show" do
    Given { pending "not sure how to test this without ID" }
    When { VCR.use_cassette('nodes/show') { run "rumm show node" }}
    Then { all_stdout =~ /dancing-bear/ }
    And { last_exit_status.should eql 0 }
  end

  context "to show all" do
    When { VCR.use_cassette('nodes/show-all') { run "rumm show nodes on loadbalancer laughing-barrel" }}
    Then { all_stdout =~ /Nodes/}
    And { last_exit_status.should eql 0 }
  end

  context "to destroy" do
    Given { pending "not sure how to test this without ID" }
    When { VCR.use_cassette('nodes/destroy') { run "rumm destroy node on loadbalancer laughing-barrel" }}
    Then { all_stdout =~ /Destroyed/}
    And { last_exit_status.should eql 0 }
  end
end
