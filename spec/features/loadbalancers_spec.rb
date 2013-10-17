require "spec_helper"

describe "using the load balancers api" do

  include_context "rummrc"

  context "to create" do
    When { VCR.use_cassette('loadbalancers/create') { run "rumm create loadbalancer --name likable-bear --node 166.78.114.25:80" }}
    Then { all_stdout =~ /Created load balancer/ }
    And { last_exit_status.should eql 0 }
  end

  context "to show" do
    When { VCR.use_cassette('loadbalancers/show') { run "rumm show loadbalancer likable-bear" }}
    Then { all_stdout =~ /likable-bear/ }
    And { last_exit_status.should eql 0 }
  end

  context "to show all" do
    When { VCR.use_cassette('loadbalancers/show-all') { run "rumm show loadbalancers" }}
    Then { all_stdout =~ /Loadbalancers:/}
    And { last_exit_status.should eql 0 }
  end

  context "to destroy" do
    When { VCR.use_cassette('loadbalancers/destroy') { run "rumm destroy loadbalancer likable-bear" }}
    Then { all_stdout =~ /Requested destruction/}
    And { last_exit_status.should eql 0 }
  end
end
