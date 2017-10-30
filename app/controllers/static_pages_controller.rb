class StaticPagesController < ApplicationController

  def home
    if current_user.present?
      redirect_to games_path
    end
  end

  def about
  end
  
end
