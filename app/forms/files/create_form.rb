class Files::CreateForm < MVCLI::Form
  input :file, Pathname, required: true, decode: ->(s) {Pathname(s)}

  validates(:file, "File location must lead to a file") {|file| File.exists? file }
end
