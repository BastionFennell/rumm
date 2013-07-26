require "spec_helper"
require "netrc"
require 'io/console'

describe "logging in" do
  Given do
    #@announce_dir = true
    #@announce_cmd = true
    #@announce_env = true
    #@announce_stdout = true
    #@announce_stderr = true
    @home = Pathname(set_env "HOME", File.expand_path(current_dir))
  end
  context "interactively with valid credentials" do
    When do
      VCR.use_cassette('successful-login') do
        if VCR.current_cassette.recording?
          print "\nUsername: "
          username = $stdin.gets.chomp
          print "Password: "
          password = $stdin.noecho(&:gets).chomp
        end
        will_type username || "<username>"
        will_type password || "<password>"
        run_interactive "rumm login"
        stop_process @interactive
      end
    end
    Then {last_exit_status == 0}

    context "places your login credentials in your .netrc" do
      Given(:netrc) { Netrc.read["api.rackspace.com"] }
      Given(:user) {netrc.first}
      Given(:password) {netrc.last}

      Then { user != nil }
      And { password != nil }
    end
  end

  context "logging out" do
    When {VCR.use_cassette('successful-logout') {run "rumm logout"}}
    Then {last_exit_status == 0}

    context "removes your login credentials from .netrc" do
      Then do
        n = Netrc.read
        user, pass = n["api.rackspace.com"]
        user == nil and pass == nil
      end
    end
    context "interactively with invalid credentials" do
      When do
        VCR.use_cassette("unsuccessful-login") do
          will_type "nil"
          will_type "nil"
          run_interactive "rum login"
          stop_process @interactive
        end
      end
      Then {last_exit_status != 0}
      And {all_stderr =~ /User could not be authenticated/}
    end
  end
end
