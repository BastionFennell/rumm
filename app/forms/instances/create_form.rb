class Instances::CreateForm < MVCLI::Form
  requires :naming

  input :name, String, default: ->() { naming.generate_name 'd', 'i' }
  input :flavor, Integer, default: 1
  input :size, Integer, default: 1

  validates(:flavor, "must be between 1 and 6") { |id| (1..6) === id }

  validates(:size, "must be between 1 and 150") { |size| (1..150) === size }
end
