class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    if params[:sort].nil? && params[:ratings].nil? &&
      (!session[:sort].nil? || !session[:ratings].nil?)
      
      # If the session is not empty, redirect to it, otherwise, load the default page
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end
    
    @all_ratings = Movie.ratings
    
    @sort = params[:sort]
#    @ratings = params[:ratings]


    
    @movies = Movie.all
    
    # sort the movies  
    if @sort && Movie.attribute_names.include?(@sort)
      @movies = @movies.order(@sort)
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
