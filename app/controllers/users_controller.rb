class UsersController < ApplicationController
  def index
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    #redirect user if already logged in 
    # if current_user
    #   redirect_to user_path
    # else
      user = User.new(user_params)
      if user.save
        session[:user_id] = user.id
        flash[:notice] = "Succesful Signup!"
        redirect_to user
      else
        flash[:error] = user.errors.full_messages.join(', ')
        redirect_to signup_path
      end
    # end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :current_city, :email, :password, :password_confirmation)
  end
  

end
