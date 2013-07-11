require "mvcli/app"
require "rumm/version"

module Rumm
  class App < MVCLI::App
    self.root = Pathname(__FILE__).dirname
  end
end
