class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to user_path
    else
      render :new
    end
  end

  def create
    user = User.find_by_email(user_params[:email])


  	# if User.confirm(params[:email], params[:password])

    if user && user.authenticate(user_params[:password])
  		#save the user's id into the session
  		session[:user_id] = user.id
  		#redirect to the show page
  		redirect_to user_path(user.id)
  	else
  		#if error logging user in
  		redirect_to login_path
  	end
  end


  def destroy
    #set session id to nil (meaning no user)
    session[:user_id] = nil
    #redirect back to index page after logout
    redirect_to "/"
  end

  private
    def user_params
      params.require(:user).permit(:email, :password)
    end

end