class UsersController < ApplicationController
  def index
  end

  def new
    @user = User.new
  end

  def show
    @posts = Post.where(:user_id => current_user.id).paginate(page: params[:page], per_page: 4).order('created_at DESC')
    @user = User.friendly.find(params[:id])
    # added for friendly id if name is edited to not break url 
    if request.path != user_path(@user)
      redirect_to @user, status: :moved_permanently
    end
    @cities = City.all

    count(@posts, @cities)
  end

  def count(posts, cities)
    count_sf = 0
    count_l = 0
    count_t = 0
    posts.each do |post|
      if post.city_id == 1
        count_sf = count_sf + 1
      elsif post.city_id == 2
        count_l = count_l + 1
      else 
        count_t = count_t + 1
      end
      if count_sf > 1
        @sf = "San Francisco, #{count_sf} posts"
      elsif count_sf == 1
        @sf = "San Francisco, #{count_sf} post"
      end
      if count_l > 1
         @t =  "London, #{count_l} posts"
      elsif count_l == 1
        @t =  "London, #{count_l} post"
      end
      if count_t > 1
        @l =  "Tokyo, #{count_t} posts"
      elsif count_t == 1
        @l =  "Tokyo, #{count_t} post"
      end
    end
    @contributors = @sf, @l, @t
  end 

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, flash: { success: "Successfully signed up!" }
    else
      # show errors
      @users_error = flash[:error] = @user.errors.full_messages.join(', ')
      #if not saved return to new post form
      render :new
    end
  end

  def edit
    @user = User.friendly.find(params[:id])
  end

  def update
    # find user
    user = User.friendly.find(params[:id])
    # update user attributes with new form data
    user.update_attributes(user_params)
    redirect_to user
  end

  def destroy
  end


  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :current_city, :email, :password, :password_confirmation, :profile_pic)
  end
  

end
