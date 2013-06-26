class ImagesController < MVCLI::Controller
  requires :compute

  def index
    compute.images.all
  end
end
