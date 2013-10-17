require "spec_helper"

describe "using the containers api" do

  include_context "rummrc"

  context "to create" do
    When { VCR.use_cassette('containers/create') { run "rumm create container --name cruising-crouton" }}
    Then { all_stdout =~ /Created container/ }
    And { last_exit_status.should eql 0 }
  end

  context "to show" do
    When { VCR.use_cassette('containers/show') { run "rumm show container cruising-crouton" }}
    Then { all_stdout =~ /cruising-crouton/ }
    And { last_exit_status.should eql 0 }
  end

  context "to show all" do
    When { VCR.use_cassette('containers/show-all') { run "rumm show containers" }}
    Then { all_stdout =~ /Containers:/}
    And { last_exit_status.should eql 0 }
  end

  context "to destroy" do
    When { VCR.use_cassette('containers/destroy') { run "rumm destroy container cruising-crouton" }}
    Then { all_stdout =~ /Requested destruction/}
    And { last_exit_status.should eql 0 }
  end
end
