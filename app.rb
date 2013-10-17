require "mvcli/app"
require "rumm/version"
require "rumm/exceptions"

module Rumm
  class App < MVCLI::App
    self.root = Pathname(__FILE__).dirname

    def main(argv = ARGV.dup, input = $stdin, output = $stdout, log = $stderr, env = ENV.dup)
      super.tap do |code|

        # HACK: print out usage information if we can't the the command
        if code == MVCLI::Middleware::ExitStatus::EX_USAGE
          puts "\n"
          super(%w[help commands], input, output, log, env) rescue code
        end
      end
    end

  end
end
