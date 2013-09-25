require "spec_helper"

describe "using the users api" do
  include_context "netrc"

  context "to create" do
    When { VCR.use_cassette('users/create') { run "rumm create user on dbinstance decided-irony --name test --password test --database dependable-bottom" }}
    Then { all_stdout =~ /Created user/ }
    And { last_exit_status.should eql 0 }
  end

  context "to show" do
    When { VCR.use_cassette('users/show') { run "rumm show user test on dbinstance decided-irony" }}
    Then { last_exit_status.should eql 0 }
  end

  context "to show all" do
    When { VCR.use_cassette('users/show-all') { run "rumm show users on dbinstance decided-irony" }}
    Then { all_stdout =~ /test/ }
    And { last_exit_status == 0 }
  end

  context "to destroy" do
    When { VCR.use_cassette('users/destroy') { run "rumm destroy user test on dbinstance decided-irony" }}
    Then { all_stdout =~ /Requested/ }
    And { last_exit_status.should eql 0 }
  end
end
