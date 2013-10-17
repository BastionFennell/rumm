require "spec_helper"

describe "using the files api" do

  include_context "rummrc"

  context "to create" do
    Given do
      `touch ~/test`
      `echo "the cake is a lie" >> ~/test`
    end

    When { VCR.use_cassette('files/create') { run "rumm create file test in container colorful-cat --file \"#{File.expand_path "~" + "/test" }\"" }}
    Then { all_stderr == "" }
    Then { all_stdout =~ /Created file/ }
    And { last_exit_status.should eql 0 }
  end

  context "to show" do
    When { VCR.use_cassette('files/show') { run "rumm show file test in container colorful-cat" }}
    Then { all_stderr == "" }
    Then { all_stdout =~ /test/ }
    And { last_exit_status.should eql 0 }
  end

  context "to show all" do
    When { VCR.use_cassette('files/show-all') { run "rumm show files in container colorful-cat" }}
    Then { all_stderr == ""}
    Then { all_stdout =~ /Files:/}
    And { last_exit_status.should eql 0 }
  end

  context "to download" do
    When { VCR.use_cassette('files/download') { run "rumm download file test in container colorful-cat --destination download-test" }}
    Then { all_stderr == "" }
    Then { all_stdout =~ /Downloaded/ }
    And { last_exit_status.should eql 0 }

    after do
      `rm #{File.expand_path '~'}/download-test`
    end
  end

  context "to destroy" do
    When { VCR.use_cassette('files/destroy') { run "rumm destroy file test in container colorful-cat" }}
    Then { all_stderr == "" }
    Then { all_stdout =~ /Requested destruction/}
    And { last_exit_status.should eql 0 }
  end
end
