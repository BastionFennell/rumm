class Attachments::ShowAllForm < MVCLI::Form
  require "fog"

  requires :compute

  input :server, Fog::Compute::Servers, required: true, decode: ->(s) { compute.servers.all.find {|server| server.name == s} or fail Fog::Errors::NotFound}
end
