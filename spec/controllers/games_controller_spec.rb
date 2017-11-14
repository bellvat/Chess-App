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

    it "should allow signed in users to create a new game in the database" do
      user = FactoryGirl.create(:user, id: 1)
      sign_in user
      post :create, params:{game:{white_player_user_id: 1,black_player_user_id:7}}
      game = Game.last
      expect(game.black_player_user_id).to eq 7
      piece = game.pieces.find_by(white:true)
      expect(piece.user_id).to eq 1
    end
  end

  describe "games#join" do

    it "should redirect users who have not signed in to sign in" do
      game = FactoryGirl.create(:game)
      patch :join, params:{id: game.id}
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow signed in users to join unmatched games, piece user_id to be updated by the joining player id" do
      user1 = FactoryGirl.create(:user, id:1)
      user2 = FactoryGirl.create(:user, id:2)
      sign_in user1
      sign_in user2

      post :create, params:{game:{white_player_user_id: user1.id}}
      game = Game.last
      piece_white1 = game.pieces.find_by(white:true)
      expect(piece_white1.user_id).to eq user1.id
      patch :join, params:{id: game.id, game:{black_player_user_id: user2.id}}
      game.reload
      expect(game.black_player_user_id).to eq user2.id
      piece_white2 = game.pieces.find_by(white:true)
      expect(piece_white2.user_id).to eq user1.id
      piece_black = game.pieces.find_by(white:false)
      expect(piece_black.user_id).to eq user2.id
      expect(response).to redirect_to game_path(game)
    end
  end

  describe "games#forfeit" do
    it "should update winner_user_id with the player who did not forfeit" do
      user = FactoryGirl.create(:user, id:1)
      sign_in user

      game = FactoryGirl.create(:game, white_player_user_id:1, black_player_user_id:2)
      post :forfeit, params:{id:game.id}
      game.reload
      expect(game.winner_user_id).to eq 2
      expect(response).to redirect_to games_path
    end
  end

end
