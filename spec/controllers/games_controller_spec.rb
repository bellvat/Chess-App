require 'rails_helper'

RSpec.describe GamesController, type: :controller do


  describe "games#new" do

    it "should require users to be logged in" do
      post :new
      expect(response).to redirect_to new_user_session_path
    end


  end

  describe "games#create" do

    it "should require users to be logged in" do
      game = FactoryGirl.create(:game)
      post :create
      expect(response).to redirect_to new_user_session_path
    end
    #currently not recognizing user sign in
    it "should allow signed in users to create a new game" do
      user = FactoryGirl.build(:user)
      sign_in user

      game = FactoryGirl.create(:game)
      post :create
      expect(game.id).to eq Game.last.id
      expect(response).to redirect_to game_path(game.id)
    end
  end

end
