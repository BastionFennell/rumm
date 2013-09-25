class Servers::UpdateForm < MVCLI::Form
  requires :naming

  input :name, String, default: nil
  input :ipv4, String, decode: ->(s) { URI('').hostname = s }
  input :ipv6, String, decode: ->(s) { URI('').hostname = s }
end
