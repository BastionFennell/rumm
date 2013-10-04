class Volumes::CreateForm < MVCLI::Form
  requires :naming

  input :name, String, default: ->() { naming.generate_name 'nil', 'nil' }
  input :type, String, default: "SATA"
  input :size, Integer, default: 100

  validates(:type, "must either be SATA or SSD") { |type| type == "SATA" or "SSD" }
end
