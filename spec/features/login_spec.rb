require "spec_helper"

describe "logging in" do
  before do
    @announce_dir = true
    @announce_cmd = true
    @announce_env = true
    @announce_stdout = true
    @announce_stderr = true
    @home = Pathname(set_env "HOME", File.expand_path(current_dir))
  end
  describe "interactively with valid credentials" do
    before do
      run_interactive "rumm login"
      type "<username>"
      type "<valid-password>"
      stop_process @interactive
    end
    it "successfully exits" do
      last_exit_status.should eq(0), "process failed"
    end
    it "stores the authentication information and service catalog" do
      @home.join('.rummrc').should exist
      access = Map(JSON.parse @home.join(".rummrc").read).access
      access.user.name.should eql "cowboyd"
      access.serviceCatalog.first.name.should eql "cloudServers"
    end
  end
end
