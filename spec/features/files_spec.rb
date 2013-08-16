require "spec_helper"

describe "using the files api" do

  include_context "netrc"

  context "to create" do
    Given do
      `touch ~/test.txt`
      `echo "the cake is a lie" >> ~/test.txt`
      p `cat ~/test.txt`
    end

    When { VCR.use_cassette('files/create') { run "rumm create file test in container colorful-cat --file \"#{File.expand_path "~" + "/test" }\"" }}
    Then { all_stderr == "" }
    Then { all_stdout =~ /Created file/ }
    And { last_exit_status.should eql 0 }
  end

  context "to show" do
    When { VCR.use_cassette('files/show') { run "rumm show file foo in container colorful-cat" }}
    Then { all_stdout =~ /foo/ }
    And { last_exit_status.should eql 0 }
  end

  context "to show all" do
    When { VCR.use_cassette('files/show-all') { run "rumm show files in container colorful-cat" }}
    Then { all_stdout =~ /Files:/}
    And { last_exit_status.should eql 0 }
  end

  context "to download" do
    When { VCR.use_cassette('files/download') { run "rumm download file test in container colorful-cat --destination test" }}
    Then { File.exists? "test" }
  end

  context "to destroy" do
    When { VCR.use_cassette('files/destroy') { run "rumm destroy file foo in container colorful-cat" }}
    Then { all_stdout =~ /Requested destruction/}
    And { last_exit_status.should eql 0 }
  end
end
