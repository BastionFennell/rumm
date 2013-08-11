require "spec_helper"

describe "using the databases api" do
  include_context "netrc"

  context "to create" do
    When { VCR.use_cassette('databases/create') { run "rumm create database on dbinstance decided-irony --name dancing-bear" }}
    Then { all_stdout =~ /Created database/ }
    And { last_exit_status.should eql 0 }
  end

  context "to show" do
    When { VCR.use_cassette('databases/show') { run "rumm show database dancing-bear on dbinstance decided-irony" }}
    Then { all_stdout =~ /dancing-bear/ }
    And { last_exit_status.should eql 0 }
  end

  context "to show all" do
    Given { pending "Not working, some sort of error in forms" }
    When { VCR.use_cassette('databases/show-all') { run "rumm show databases on dbinstance decided-irony" }}
    Then { all_stdout =~ /Databases/}
    And { last_exit_status.should eql 0 }
  end

  context "to destroy" do
    When { VCR.use_cassette('databases/destroy') { run "rumm destroy database dancing-bear on dbinstance decided-irony" }}
    Then { all_stdout =~ /Detached volume/}
    And { last_exit_status.should eql 0 }
  end
end
