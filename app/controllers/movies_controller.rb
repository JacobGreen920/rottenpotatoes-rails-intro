class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort)
  end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort = params[:sort]
    @title_header = nil
    @release_date_header = nil
    @movies = Movie.all
    @all_ratings = Movie.ratings
    if params[:ratings] == nil
      @permitted_ratings = Movie.ratings
    else
      @permitted_ratings = params[:ratings].keys
    end
    if @sort == "Title"
      @movies = Movie.order :title
      @title_header = "hilite"
    elsif @sort == "Release Date"
      @movies = Movie.order :release_date
      @release_date_header = "hilite"
    else
      @movies = Movie.where(rating: @permitted_ratings)
    end
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
