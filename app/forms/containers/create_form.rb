class Containers::CreateForm < MVCLI::Form
  requires :naming

  input :name, String, default: ->() { naming.generate_name 'c', 'c' }
end
