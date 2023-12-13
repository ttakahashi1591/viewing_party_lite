class UsersController < ApplicationController 
  def new
  end
  
  def create
    params[:email] = params[:email].downcase
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      flash[:success] = 'Successfully Added New User'
      redirect_to user_path(user)
    else
      flash[:error] = "#{error_message(user.errors)}"
      redirect_to register_user_path
    end
  end

  def show
    if session[:user_id]
      @user = User.find(params[:id])
    else
      flash[:error] = 'You must log in to view the dashboard'
      redirect_to root_path
    end
  end

  def login_form
  end

  def login
    params[:email] = params[:email].downcase
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to user_path(user)
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :login_form
    end
  end

  def log_out
    session.clear
    # session[:user_id] = nil
    flash[:success] = "You've been logged out!"
    redirect_to root_path
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end