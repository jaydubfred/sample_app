class UsersController < ApplicationController

	before_action :signed_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
	before_action :admin_user, only: :destroy	
	before_action :not_signed_in, only: [:new, :create]

	def index
		@users = User.paginate(page: params[:page]) 
	end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

	def destroy
		if current_user?(User.find(params[:id]))
			flash[:error] = "You can't delete yourself."
			redirect_to(current_user)
		else
			User.find(params[:id]).destroy
			flash[:succes] = "User deleted"
			redirect_to users_url
		end
	end

  def create
    @user = User.new(user_params) 
    if @user.save
			sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end 

  def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(user_params)
			flash[:success] = "Profile updated."
			redirect_to @user
		else
			render 'edit'
		end	
	end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
	# Before filters

	def signed_in_user
		unless signed_in?
			store_location
			flash[:notice] = "Please sign in."
			redirect_to signin_url
		end
	end

	def correct_user
		@user = User.find(params[:id])
		unless current_user?(@user)
			flash[:error] = "That ain't your profile."
		  redirect_to(root_url) 
		end
	end
	
	def admin_user
		unless current_user.admin?
			flash[:error] = "You are not an admin."
			redirect_to(root_url)		
		end
	end
	
	def not_signed_in
		if signed_in?
			flash[:error] = "You are already using an account."
			redirect_to(root_url)
		end
	end
end
