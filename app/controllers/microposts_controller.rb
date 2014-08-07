class MicropostsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy]
	before_action	:correct_user, only: :destroy
	
	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created."
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end
	
	def destroy
		@micropost.destroy
		redirect_to :back 
	end
	
	private
		
		def micropost_params
			params.require(:micropost).permit(:content)
		end
		
		def correct_user
			@micropost = current_user.microposts.find_by(id: params[:id])
			if @micropost.nil? && !current_user.admin?
				flash[:error] = "You are not allowed to delete someone else's posts"
				redirect_to root_url
			else
				@micropost = Micropost.find(params[:id])
			end
		end
end
