class StaticPagesController < ApplicationController
  def home
  	if logged_in?
  		redirect_to memories_path(offset: 0)
  	end
  end

  def about
  end

  def contact
  end
end
