class FoldersController < ApplicationController
  	before_action :logged_in_user
	def new
		set_user
		@folders = get_folders(@user.id)
		@folder = Folder.new
	    @folder.parent_folder_id = params[:folder]
	    @new_folder = true
    	render layout: 'folders'
	end

	def edit
	    set_user
		set_folder
		@folders = get_folders(@user.id, params[:id])
	    @edit_folder = true
    	render layout: 'folders'
	end

	def create
		@folder = Folder.new(folder_params)
		@folder.user = current_user
		if @folder.save
			flash[:success] = 'Folder was successfully created.'
			redirect_to memories_path(folder: @folder.id)
		else
			set_user
			@folder = Folder.new
		    @folder.parent_folder_id = params[:folder]
			render 'new', layout: 'folders'
		end
	end

	def show
		@folder = Folder.find_by(id: params[:id])
		@memories = @folder.all_memories
	    render layout: 'folders'
	end

	def index
	    set_user
		@folders = Folder.where(published: true)
    	render layout: 'folders'
	end

	def update
	    set_user
		set_folder
		@folder.user = current_user
		if @folder.update(folder_params)
			flash[:success] = 'Folder was successfully updated.'
			redirect_to memories_path(folder: @folder.id)
		else
			render 'edit', layout: 'folders'
		end
	end


	def destroy
	    set_user
		set_folder
		@folder.destroy
		flash[:success] = 'Folder was successfully destroyed.'
		redirect_to memories_url
	end

	private
		def set_user
			@user = current_user
			if @user == nil
				log_out
				logged_in_user
			end
		end

	    def set_folder
			@folder = Folder.find_by(id: params[:id], user_id: @user.id)
			if @folder == nil        
				flash[:danger] = "Unable to retrieve record."
				redirect_to memories_path
			end
	    end

		def folder_params
			params.require(:folder).permit(:user_id, :parent_folder_id, :name, :description, :published)
		end

	    def logged_in_user
	      unless logged_in?
	        store_location
	        flash[:danger] = "Please log in."
	        redirect_to login_url
	      end
	    end
end
