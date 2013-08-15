class Attachments::AttachDetachShowForm < MVCLI::Form
  require "fog"

  requires :volumes
  requires :compute

  input :volume, Fog::Volume,  required: true, decode: ->(s) { volumes.all.find {|v| v.display_name == s} or fail Fog::Errors::NotFound}
end
