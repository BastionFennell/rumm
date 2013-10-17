require "rumm"
require "vcr"
require "aruba/api"
require "rspec-given"
$: << File.expand_path("../../app/providers", __FILE__)

module Rumm::SpecHelper
  def will_type(string)
    Aruba::InProcess.main_class.input << _ensure_newline(string)
  end

  def rumm(command)
    run_interactive "rumm #{command}"
    stop_process @interactive
  end

  def stderr
    all_stderr
  end

  def stdout
    all_stdout
  end
end

RSpec.configure do |config|
  config.color_enabled = true
  config.include Aruba::Api, :example_group => {
    :file_path => /spec\/features/
  }
  config.include Rumm::SpecHelper

  config.before(:each){ Aruba::InProcess.main_class.input.clear }

  config.before(:each) do
    @__aruba_original_paths = (ENV['PATH'] || '').split(File::PATH_SEPARATOR)
    ENV['PATH'] = ([File.expand_path('bin')] + @__aruba_original_paths).join(File::PATH_SEPARATOR)
  end

  config.after(:each) do
    ENV['PATH'] = @__aruba_original_paths.join(File::PATH_SEPARATOR)
  end
end

shared_context "rummrc" do
  before do
    if File.exists? "#{File.expand_path('~')}/.rummrc"
      FileUtils.copy_file "#{File.expand_path('~')}/.rummrc", home.join('.rummrc')
    else
      File.open(home.join('.rummrc'), "w") do |f|
        f.puts "{\"environments\":{\"default\":{\"region\":\"ord\",\"username\":\"<rackspace_username>\",\"api_key\":\"<rackspace_api_key>\"}}}"
      end
    end
  end
  include_context "set home"
end

shared_context "set fake home" do
  Given(:home) {Pathname(set_env "HOME", "#{File.expand_path(current_dir)}/tmp")}

  after do
    restore_env
  end

end
shared_context "set home" do

  Given(:home) {Pathname(set_env "HOME", File.expand_path(current_dir))}

  after do
    restore_env
  end
end

VCR.configure do |c|
  c.default_cassette_options = {:record => :once}
  c.hook_into :excon
  #c.debug_logger = $stderr

  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.filter_sensitive_data("<rackspace-username>") do |interaction|
    if interaction.response.body =~ /"username":"(\w+)"/ or interaction.request.body =~ /"username":"(\w+)"/
      $1
    else
      ENV['RACKSPACE_USERNAME']
    end
  end
  c.filter_sensitive_data("<rackspace-password>") do |interaction|
    if interaction.response.body =~ /"password":"(.+)"/ or interaction.request.body =~ /"password":"(.+)"/
      $1
    else
      ENV['RACKSPACE_PASSWORD']
    end
  end
  c.filter_sensitive_data("<rackspace-api-token>") do |interaction|
    if interaction.response.body =~ /"token":{"id":"(\w+)"/
      $1
    elsif token = interaction.request.headers['X-Auth-Token']
      token.first
    end
  end
  c.filter_sensitive_data("<rackspace-api-key>") do |interaction|
    if interaction.response.body =~ /"apiKey":"(\w+)"/ or interaction.request.body =~ /"apiKey":"(\w+)"/
      $1
    else
      ENV['RACKSPACE_API_KEY']
    end
  end
end


require "aruba/in_process"
require_relative "../app"
Aruba.process = Aruba::InProcess
class Aruba::InProcess
  attr_reader :stdin

  def self.main_class;
    @@main_class;
  end

  self.main_class = Class.new do
    @@input = ""
    class << self
      def input
        @@input
      end
    end

    def initialize(argv, stdin=STDIN, stdout=STDOUT, stderr=STDERR, kernel=Kernel)
      @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel

      def @stdin.noecho
        yield self
      end

      @stdin << @@input
      @stdin.rewind
    end

    def execute!
      @kernel.exit Rumm::App.main @argv, @stdin, @stdout, @stderr
    end
  end
end
