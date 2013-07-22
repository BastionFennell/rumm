require "spec_helper"
require "naming_provider"

describe "fancy naming" do
  use_natural_assertions
  Given(:name) { NamingProvider.new.generate_name *arguments }

  context "with no arguments" do
    Given(:arguments) { [] }
    Then { not name.nil? }
    Then { name.length > 0}
  end
  context "with a first letter and last letter" do
    Given(:parts) { name.split '-' }
    context "with different letters" do
      Given(:arguments) { ['f', 'b'] }
      Then { parts.first[0] == 'f' }
      Then { parts.last[0] == 'b' }
    end
    context "with the same letter" do
      Given(:arguments) { ['s', 's'] }
      Then { parts.first[0] == 's'}
      Then { parts.last[0] == 's' }
    end
  end
end
