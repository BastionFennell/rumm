class Files::DownloadForm < MVCLI::Form
  input :destination, String, required: true, decode: ->(s) {File.expand_path s}

  validates(:destination, "File location must lead to an empty file") {|file| !File.exists? file}
end
