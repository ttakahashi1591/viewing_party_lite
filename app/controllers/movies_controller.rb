class MoviesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    if params[:top]
      @movies_facade = MoviesFacade.new.top_rated
    else
      @movies_facade = MoviesFacade.new.search(params[:query])
    end
  end

  def show
    @user = User.find(params[:user_id])
    @movie_facade = MoviesFacade.new.find_movie(params[:id])   
  end
end