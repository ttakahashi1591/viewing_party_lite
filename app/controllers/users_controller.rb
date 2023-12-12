class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
  end

  def create
    user = user_params
    user[:email] = user[:email].downcase
    new_user = User.new(user_params)
    if new_user.save
      session[:new_user_id] = new_user.id
      flash[:success] = 'Successfully Added New User'
      redirect_to user_path(new_user)
    else
      flash[:error] = "#{error_message(new_user.errors)}"
      redirect_to register_user_path
    end
  end

  def login_form
  end

  def login
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

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end