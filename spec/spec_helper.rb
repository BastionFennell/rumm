require "rax"
require "vcr"
require "aruba/api"
require "rspec-given"

RSpec.configure do |config|
  config.color_enabled = true
  config.include Aruba::Api, :example_group => {
    :file_path => /spec\/features/
  }
  config.before(:each) do
    @__aruba_original_paths = (ENV['PATH'] || '').split(File::PATH_SEPARATOR)
    ENV['PATH'] = ([File.expand_path('bin')] + @__aruba_original_paths).join(File::PATH_SEPARATOR)
  end

  config.after(:each) do
    ENV['PATH'] = @__aruba_original_paths.join(File::PATH_SEPARATOR)
  end
end

VCR.configure do |c|
  c.default_cassette_options = { :record => :new_episodes }
  c.hook_into :excon
#  c.debug_logger = $stderr

  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.filter_sensitive_data("<rackspace-login>") do
    ENV['RACKSPACE_LOGIN']
  end
  c.filter_sensitive_data("<rackspace-api-token>") do
    ENV['RACKSPACE_API_TOKEN']
  end
end


require "aruba/in_process"
require_relative "../app"
Aruba.process = Aruba::InProcess
Aruba::InProcess.main_class = Class.new do
  def initialize(argv, stdin=STDIN, stdout=STDOUT, stderr=STDERR, kernel=Kernel)
    @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
  end

  def execute!
    @kernel.exit Rax::App.main @argv, @stdin, @stdout, @stderr
  end
end
