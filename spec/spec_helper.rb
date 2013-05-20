require 'rax'
require "aruba/api"

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
