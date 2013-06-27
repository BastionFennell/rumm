class Users::CreateForm < MVCLI::Form
  input :name, String, required: true
  input :password, String, required: true
  input :databases, [Map], decode: ->(s) {{name: s}}
  input :host, String

  validates(:host, "host must be a valid ip address or %") {|host|
    host == "%" or IPAddr.new(host) rescue nil
  }
end
