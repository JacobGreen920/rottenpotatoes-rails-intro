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
    redir = false
    @movies = Movie.all
    @all_ratings = Movie.ratings
    unless params.key?(:sort)
      params[:sort] = session[:sort]
      unless params[:sort] == nil
        redir = true
      end
    end
    unless params.key?(:ratings)
      params[:ratings] = session[:ratings]
      unless params[:ratings] == nil
        redir = true
      end
    end
    if redir
      redirect_to movies_path(params)
      return
    end
    session[:sort] = params[:sort]
    session[:ratings] = params[:ratings]
    @sort = session[:sort]
    @title_header = nil
    @release_date_header = nil
    if session[:ratings] == nil
      @permitted_ratings = Movie.ratings
    else
      @permitted_ratings = session[:ratings].keys
    end
    if @sort == "Title"
      @movies = Movie.where(rating: @permitted_ratings).order :title
      @title_header = "hilite"
    elsif @sort == "Release Date"
      @movies = Movie.where(rating: @permitted_ratings).order :release_date
      @release_date_header = "hilite"
    else
      @movies = Movie.where(rating: @permitted_ratings)
    end
    @all_checks = []
    @all_ratings.each { |rating|
      if @permitted_ratings.include? rating
        @all_checks.append(true)
      else
        @all_checks.append(false)
      end
    }
    @outputs = @all_ratings.zip(@all_checks)
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
