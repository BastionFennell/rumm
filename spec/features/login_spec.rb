require "spec_helper"
require "netrc"
require 'io/console'

describe "logging in" do
  include_context "netrc"
  before do
    run "rumm logout"
  end
  context "interactively with valid credentials" do
    When do
      VCR.use_cassette('authentication/successful-login') do
        if VCR.current_cassette.recording?
          print "\nUsername: "
          username = $stdin.gets.chomp
          print "Password: "
          password = $stdin.noecho(&:gets).chomp
          puts
          print "Region: "
          region = $stdin.gets.chomp
        end
        will_type username || "<username>"
        will_type password || "<password>"
        will_type region   || "<region>"
        run_interactive "rumm login"
        stop_process @interactive
      end
    end
    Then {last_exit_status == 0}

    context "creates .rummrc" do
      Then { File.exists? "#{File.expand_path('~')}/.rummrc" }
    end
  end

  context "logging out" do
    When {run "rumm logout"}
    Then {last_exit_status == 0}

    context "deletes .rummrc" do
      Then { !File.exists? "#{File.expand_path('~')}/.rummrc" }
    end
  end

  context "interactively with invalid credentials" do
    When do
      VCR.use_cassette("authentication/unsuccessful-login") do
        will_type "nil"
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
