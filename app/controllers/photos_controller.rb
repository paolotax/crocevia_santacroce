class PhotosController < ApplicationController

  def index
      @photos = Photo.all
    end

    def show
      @photo = Photo.find(params[:id])
    end

    def new
      @photo = Photo.new
    end

    def create
      @photo = Photo.create(params[:photo])
    end

    def edit
      @photo = Photo.find(params[:id])
    end

    def update
      #raise params.inspect
      @photo = Photo.find(params[:id])
      if @photo.update_attributes(params[:photo])
        redirect_to photos_url, notice: "photo was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      @photo = Photo.find(params[:id])
      @photo.destroy
      redirect_to photos_url, notice: "photo was successfully destroyed."
    end



end