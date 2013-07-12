class Servers::CreateForm < MVCLI::Form
  requires :naming

  input :name, String, default: ->() {naming.generate_name 's', 's'}
  input :image_id, String, default: '6a668bb8-fb5d-407a-9a89-6f957bced767' #12.04 LTS
  input :flavor_id, String, default: 2
end
