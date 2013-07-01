require "spec_helper"

describe "logging in" do
  before do
    #@announce_dir = true
    #@announce_cmd = true
    #@announce_env = true
    #@announce_stdout = true
    #@announce_stderr = true
    @home = Pathname(set_env "HOME", File.expand_path(current_dir))
  end
  describe "interactively with valid credentials" do
    before do
      VCR.use_cassette('successful-login') do
        will_type ENV['RACKSPACE_USERNAME'] || "<username>"
        will_type ENV['RACKSPACE_PASSWORD'] || "<valid-password>"
        run_interactive "rumm login"
        stop_process @interactive
      end
    end
    it "successfully exits" do
      last_exit_status.should eq(0), "process failed"
    end
    it "places your login credentials in your .netrc" do

    end
  end
end
