require "spec_helper"
require 'io/console'

describe "logging in" do
  before do
    run "rumm logout"
  end

  context "with valid credentials" do
    Given(:region) { "ord"}

    When do
      VCR.use_cassette('authentication/successful-login') do
        if VCR.current_cassette.recording?
          print "\nUsername: "
          username = $stdin.gets.chomp
          print "Password: "
          password = $stdin.noecho(&:gets).chomp
        end
        @username = username || "<username>"
        will_type(@username)
        will_type(password || "<password>")
        will_type region
        run_interactive "rumm login"
        stop_process @interactive
      end
    end

    Then { last_exit_status == 0 }

    Given(:config_file_path) {
      File.expand_path("~/.rummrc")
    }

    Then { File.exists?(config_file_path) }

    Given(:json) {
      File.open(config_file_path) do |f|
        JSON.load(f)["environments"]["default"]
      end
    }

    Then { @username == json["username"] }
    Then { json["api_key"] }
    Then { region == json["region"] }
  end

  context "with invalid credentials"
  When do
    VCR.use_cassette('authentication/unsuccessful-login') do
      will_type "nil"
      will_type "nil"
      will_type "nil"
      run_interactive "rumm login"
      stop_process @interactive
    end
  end
  Then {last_exit_status != 0}
  And {all_stderr =~ /User could not be authenticated/}

  context "deletes .rummrc" do
    Then { !File.exists? "#{File.expand_path('~')}/.rummrc" }
  end 
end
context "after previous successful login"

context "logging out"
end
