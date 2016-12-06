class MemoriesController < ApplicationController
  before_action :logged_in_user
  before_action :set_user, only: [:index, :new, :todays_memories]
  before_action :set_memory, only: [:show, :edit, :update, :destroy]
  before_action :set_update_variables, only: [:new, :edit]

  def index
    if params[:offset] != nil
      @offset = params[:offset].to_i
      @date = Date.today + @offset.days
      if (@offset == 0)
        @title = "Schedule for Today"
      else
        format = '%B %-d'
        if @date.year != Date.today.year
          format += ', %Y'
        end
        @title = "Schedule for #{@date.strftime(format)}"
      end
      @memories = Memory.joins(:memory_days).where({user_id: @user.id, memory_days: {day: @date}}).order(start_date: :desc)
    else
      folder_id = params[:folder].to_i
      @memories = Memory.where(user_id: @user.id, folder_id: folder_id).order(start_date: :asc)
      @folders = Folder.where(user_id: @user.id, parent_folder_id: folder_id).order(name: :asc)
      @folder = Folder.find_by(id: folder_id)

      if (@folder == nil)
        @folder = Folder.new(user_id: @user.id, parent_folder_id: nil, name: "Home")
      end
      @title = @folder.name
    end
    render layout: 'folders'
  end

  def show
    memory_ids = nil
    if params[:offset] != nil
      date = Date.today + params[:offset].to_i.days
      memory_ids = Memory.joins(:memory_days).where({user_id: @user.id, memory_days: {day: date}}).order(start_date: :desc).pluck(:id)
    elsif params[:folder] != nil
      memory_ids = Memory.where(user_id: @user.id, folder_id: params[:folder].to_i).order(start_date: :asc).pluck(:id)
    end
    if memory_ids != nil
      index = memory_ids.index(@memory.id)
      if index != nil
        if index > 0
          @previous_memory = Memory.find_by(id: memory_ids[index-1])
        end
        if index < memory_ids.size - 1
          @next_memory = Memory.find_by(id: memory_ids[index+1])
        end
      end
    end
    render layout: 'memories'
  end

  def new
    @memory = Memory.new
    @memory.folder_id = params[:folder]
    render layout: 'folders'
  end

  def edit
    render layout: 'folders'
  end

  def create
    @memory = Memory.new(memory_params)
    @memory.user = current_user
    if @memory.save
      flash[:success] = 'Memory was successfully created.'
      redirect_to @memory
    else
      set_user
      @time_units = TimeUnit.all
      render 'new', layout: 'folders'
    end
  end

  def update
    @memory.user = current_user
    if @memory.update(memory_params)
      flash[:success] = 'Memory was successfully updated.'
      redirect_to @memory
    else
      set_user
      @time_units = TimeUnit.all
      render 'edit', layout: 'folders'
    end
  end

  def destroy
    @memory.destroy
    flash[:success] = 'Memory was successfully destroyed.'
    redirect_to memories_url
  end

  private
    def set_memory
      set_user
      @memory = Memory.find_by(id: params[:id], user_id: @user.id)
      if @memory == nil        
        flash[:danger] = "Unable to retrieve record."
        redirect_to memories_path
      end
    end

    def set_user
      @user = current_user
      if @user == nil
        log_out
        logged_in_user
      end
    end

    def set_update_variables
      @folders = get_folders(@user.id)
      @time_units = TimeUnit.all
    end

    def memory_params
      params.require(:memory).permit(:user_id, :folder_id, :title, :subtitle, :text, :source, :start_date, {:reminders_attributes => [:time_unit_id, :time_unit_quantity, :repeat_quantity] } )
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
