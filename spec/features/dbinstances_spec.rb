require "spec_helper"

describe "using the containers api" do

  include_context "netrc"

  context "to create" do
    When { VCR.use_cassette('instances/create') { run "rumm create dbinstance --name dancing-idol" }}
    Then { all_stdout =~ /Created database instance/ }
    And { last_exit_status.should eql 0 }
  end

  context "to show" do
    When { VCR.use_cassette('instances/show') { run "rumm show dbintance dancing-idol" }}
    Then { all_stdout =~ /dancing-idol/ }
    And { last_exit_status.should eql 0 }
  end

  context "to show all" do
    When { VCR.use_cassette('instances/show-all') { run "rumm show dbinstances" }}
    Then { all_stdout =~ /Database instances:/}
    And { last_exit_status.should eql 0 }
  end

  context "to destroy" do
    When { VCR.use_cassette('instances/destroy') { run "rumm destroy dbinstance dancing-idol" }}
    Then { all_stdout =~ /Requested destruction/}
    And { last_exit_status.should eql 0 }
  end
end
