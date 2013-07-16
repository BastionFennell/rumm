class Servers::CreateForm < MVCLI::Form
  requires :naming

  input :name, String, default: ->() {naming.generate_name 's', 's'}
  input :image_id, String, default: '6a668bb8-fb5d-407a-9a89-6f957bced767' #12.04 LTS
  input :flavor_id, String, default: 2
  input :ssh_private, String, default: ->() {File.expand_path "~/.ssh/id_rsa"}, decode: ->(s) {File.expand_path s}
  input :ssh_public, String, default: ->() {File.expand_path "~/.ssh/id_rsa.pub"}, decode: ->(s) {File.expand_path s}

  validates(:ssh_private, "private ssh key location must lead to a file") {|ssh_private| File.exists? ssh_private}
  validates(:ssh_private, "private ssh key must be a valid key") do |ssh_private|
    File.exists?(ssh_private) && File.open(ssh_private, "r") do |keyfile|
      keyfile.read =~ /-----BEGIN .+ PRIVATE KEY-----/
    end
  end

  validates(:ssh_public, "public ssh key location must lead to a file") {|ssh_public| File.exists? ssh_public}
  validates(:ssh_public, "public ssh key must be a valid key") do |ssh_public|
    File.exists?(ssh_public) && File.open(ssh_public, "r") do |keyfile|
      keyfile.read =~ /ssh-/
    end
  end
end
