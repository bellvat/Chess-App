require 'rails_helper'

RSpec.describe GamesController, type: :controller do

  describe "games#update" do
    it "should update Games model once users pick a color" do
      player1 = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game)
      put :update, params:{game: white_player_user_id}
      expect(response).to have_http_status(:success)
      game.reload
      expect(game.white_player_user_id).to eq(player1.id)
    end
  end


end
