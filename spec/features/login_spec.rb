require "spec_helper"

describe "logging in" do
  before do
    pending
    @announce_dir = true
    @announce_cmd = true
    @announce_env = true
    @announce_stdout = true
    @announce_stderr = true
    @home = Pathname(set_env "HOME", File.expand_path(current_dir))
  end
  describe "interactively with valid credentials" do
    before do
      run_interactive "rax login"
      type "<username>"
      type "<valid-password>"
      stop_process @interactive
    end
    it "successfully exits" do
      last_exit_status.should eq(0), "process failed"
    end
    it "stores the authentication information and service catalog" do
      @home.join('.raxrc').should exist
      access = Map(JSON.parse @home.join(".raxrc").read).access
      access.user.name.should eql "cowboyd"
      access.serviceCatalog.first.name.should eql "cloudServers"
    end
  end
  describe "non-interactively" do
    before do
      run "rax login --username <username> --password <valid-password>"
    end
    it "works also" do

    end
  end
  describe "failure to log in" do
    before do
      run "rax login --username <username> --password <invalid-password>"
    end
    it "exits with an error message an EX_NOPERM" do
      last_exit_status.should eql 67
    end
  end

  describe "with an expired auth token"
end
