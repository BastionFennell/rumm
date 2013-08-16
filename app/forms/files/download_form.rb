class Files::DownloadForm < MVCLI::Form
  input :destination, Pathname, required: true, decode: ->(s) {Pathname(s)}

  validates(:destination, "File location must lead to an empty file") {|file| !File.exists? file}
end
