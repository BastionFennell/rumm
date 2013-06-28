class Servers::CreateForm < MVCLI::Form
  requires :naming

  input :name, String, default: ->() {naming.generate_name 's', 's'}
  input :image_id, String, default: '9922a7c7-5a42-4a56-bc6a-93f857ae2346'
  input :flavor_id, String, default: 2
end
