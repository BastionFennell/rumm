class Files::CreateForm < MVCLI::Form
  input :file, String, required: true, decode: ->(s) {File.expand_path s}

  validates(:file, "File location must lead to a file") {|file| File.exists? file}
end
