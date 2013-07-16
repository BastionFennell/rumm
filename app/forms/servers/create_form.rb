class Servers::CreateForm < MVCLI::Form
  requires :naming

  input :name, String, default: ->() {naming.generate_name 's', 's'}
  input :image_id, String, default: '9922a7c7-5a42-4a56-bc6a-93f857ae2346'
  input :flavor_id, String, default: 2
  input :ssh_private, String, default: ->() {File.expand_path "~/.ssh/id_rsa"}, decode: ->(s) {File.expand_path s}
  input :ssh_public, String, default: ->() {File.expand_path "~/.ssh/id_rsa.pub"}, decode: ->(s) {File.expand_path s}

  validates(:ssh_private, "private ssh key location must lead to a file") {|ssh_private| File.exists? ssh_private}
  validates(:ssh_private, "private ssh key must be a valid key") do |ssh_private|
    if File.exists?(ssh_private) && (test = File.open(ssh_private, "r"))
      test_line = test.readline
      test_line.delete! "\n"
      test_line.delete! "\r"
      test_line == "-----BEGIN RSA PRIVATE KEY-----"
    end
  end

  validates(:ssh_public, "public ssh key location must lead to a file") {|ssh_public| File.exists? ssh_public}
  validates(:ssh_public, "public ssh key must be a valid key") do |ssh_public|
    if File.exists?(ssh_public) && (test = File.open(ssh_public, "r"))
      test_line = test.readline.split[0]
      test_line.delete! "\n"
      test_line.delete! "\r"
      test_line == "ssh-rsa"
    end
  end
end
