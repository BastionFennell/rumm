require "spec_helper"
require "naming_provider"

describe "fancy naming" do
  use_natural_assertions
  Given(:name) { NamingProvider.new.generate_name *arguments }

  context "with no arguments" do
    Given(:arguments) { [nil, nil] }
    Then { not name.nil? }
    Then { name.length > 0}
  end
end
