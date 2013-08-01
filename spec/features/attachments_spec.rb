require "spec_helper"

describe "using the attachments api" do
  context "with credentials are present" do

    include_context "netrc"

    context "to create" do
      When { VCR.use_cassette('attachments/create') { run "rumm create attachment --server silly-saffron --volume jumping-jellybean" }}
      Then { all_stdout =~ /Attached volume/ }
      And { last_exit_status.should eql 0 }
    end

    context "to show" do
      When { VCR.use_cassette('attachments/show') { run "rumm show attachment --server silly-saffron --volume jumping-jellybean" }}
      Then { all_stdout =~ /Attachment/ }
      And { last_exit_status.should eql 0 }
    end

    context "to show all" do
      When { VCR.use_cassette('attachments/show-all') { run "rumm show attachments --server silly-saffron" }}
      Then { all_stdout =~ /Attachments/}
      And { last_exit_status.should eql 0 }

    context "to destroy" do
      When { VCR.use_cassette('attachments/destroy`') { run "rumm destroy attachment --server silly-saffron --volume jumping-jellybean" }}
      Then { all_stdout =~ /Detached volume/}
      And { last_exit_status.should eql 0 }
    end
  end
end
