require "spec_helper"
require "configuration_provider"

describe "configuration" do

  describe "defaults" do
    context "should be initialized with defaults" do
      include_context "set fake home"
      Given(:configuration) { ConfigurationProvider.new.value }
      #won't reset home without this?
      Then { home == home }
      And { configuration.region.should == :ord }
      And { configuration.username.should == nil }
      And { configuration.api_key.should == nil}
    end
  end

  describe "Configuration file present" do
    include_context "set home"
    When do
      File.open("#{home}/.rummrc", 'w') do |f|
        f.puts "{\"environments\":{\"default\":{\"region\":\"dfw\",\"username\":\"racker\",\"api_key\":\"1234\"}}}"
      end
      configuration.reload
    end
    Given(:configuration) { ConfigurationProvider.new.value }
    context "should be initialized with .rummrc file if present" do
      Then { configuration.region.should == "dfw" }
      And { configuration.username.should == 'racker' }
      And { configuration.api_key.should == '1234' }
    end

    # Cleanup
    #File.delete "#{@rumm_dir}/.rummrc" if File.exists? "#{@rumm_dir}/.rummrc"
    describe "region" do
      When { ENV['REGION'] = "SYD" }
      context "should be overridable with REGION environment var" do
        Then { configuration.region.should == "SYD" }
      end
    end

    #Clean up
    ENV['REGION'] = nil

    describe "lon_region?" do
      Given(:configuration) { ConfigurationProvider.new.value }
      When { configuration.region = region }

      context "when set with lon" do
        Given (:region) { "lon" }
        Then { configuration.lon_region? }
      end

      context "when set with LON" do
        Given (:region) { "LON" }
        Then { configuration.lon_region? }
      end

      context "when set with :lon" do
        Given (:region) { :lon }
        Then { configuration.lon_region? }
      end

      context "when set as nil" do
        Given (:region) { "nil" }
        Then { !configuration.lon_region? }
      end

      context "when set as dfw" do
        Given (:region) { "nil" }
        Then { !configuration.lon_region? }
      end
    end

    describe "auth_endpoint" do
      Given (:configuration) { ConfigurationProvider.new.value }
      When { configuration.region = region }

      context "when set as :lon" do
        Given (:region) { :lon }
        Then { configuration.auth_endpoint.should == Fog::Rackspace::UK_AUTH_ENDPOINT }
      end

      context "when set as :syd" do
        Given (:region) { :syd }
        Then { configuration.auth_endpoint.should == Fog::Rackspace::US_AUTH_ENDPOINT }
      end
    end

    describe "reload" do
      context "should reload configuration if config file is present" do
        Given(:configuration) do
          ConfigurationProvider.new.value
        end
        Given { ENV['REGION'] = nil }

        When do
          configuration.username = "unclebob"
          configuration.reload.should be_true
        end
        Then { configuration.username.should == "racker" }
      end
    end
    describe "delete" do
      context "should delete file if it exists and revert to default configuration" do
        Given(:configuration) { ConfigurationProvider.new.value }
        Given { File.should_receive(:delete).with "#{File.expand_path(current_dir)}/.rummrc" }
        When { configuration.delete }
        Then { configuration.region.should == :ord }
        And { configuration.username.should == nil }
        And { configuration.api_key.should == nil }
      end
      context "should not delete file if it does not exist" do
        Given(:configuration) { ConfigurationProvider.new.value }
        Given { File.stub(:exists?).with("#{File.expand_path(current_dir)}/.rummrc").and_return(false)}
        Given { File.stub(:delete).never }
        When { configuration.delete.should be_true }
        Then { configuration.region.should == :ord }
        And { configuration.username.should == nil }
        And { configuration.api_key.should == nil }
      end
    end
    describe "save" do
      context "should save the configuration" do
        Given(:configuration) { ConfigurationProvider.new.value }
        Given { JSON.stub :dump }
        Then { configuration.save.should be_true }
      end
    end
  end

  context "should not reload values if configuration file does not exist" do
    include_context "set fake home"

    Given(:configuration) do
      ConfigurationProvider.new.value
    end
    When do
      #Won't reset home without this?
      home == home
      configuration.username = "unclebob"
      configuration.reload.should be_false
    end

    Then { configuration.username.should == "unclebob" }
  end
end
