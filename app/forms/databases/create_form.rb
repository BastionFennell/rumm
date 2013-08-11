class Databases::CreateForm < MVCLI::Form
  requires :naming

  input :name, String, default: ->() {naming.generate_name 'd', 'b'}

end
