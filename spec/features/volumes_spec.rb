require "spec_helper"

describe "using the volumes api" do

  include_context "netrc"

  context "to create" do
    When { VCR.use_cassette('volumes/create') { run "rumm create volume --name vaulting-vigilante" }}
    Then { all_stdout =~ /Created volume/ }
    And { last_exit_status.should eql 0 }
  end

  context "to show" do
    When { VCR.use_cassette('volumes/show') { run "rumm show volume vaulting-vigilante" }}
    Then { all_stdout =~ /vaulting-vigilante/ }
    And { last_exit_status.should eql 0 }
  end

  context "to show all" do
    When { VCR.use_cassette('volumes/show-all') { run "rumm show volumes" }}
    Then { all_stdout =~ /Volumes:/}
    And { last_exit_status.should eql 0 }
  end

  context "to destroy" do
    When { VCR.use_cassette('volumes/destroy') { run "rumm destroy volume vaulting-vigilante" }}
    Then { all_stdout =~ /Requested destruction/}
    And { last_exit_status.should eql 0 }
  end
end
