require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  describe "#update" do
    #before {sign_in user}
    it "should update coordinates if successful move" do
      current_user = FactoryGirl.create(:user, id: 1)
      sign_in current_user
      game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
      pawn = FactoryGirl.create :pawn, x_coord: 1, y_coord: 6, game_id: game.id, white: true
      post :update, params: {id: pawn.id, piece:{x_coord: 1, y_coord: 5}}
      expect(response).to have_http_status(200)
      pawn.reload
      expect(pawn.y_coord).to eq 5
    end

    it "should switch player turns if successful move" do
      current_user = FactoryGirl.create(:user, id: 1)
      sign_in current_user
      game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
      pawn = FactoryGirl.create :pawn, x_coord: 1, y_coord: 6, game_id: game.id, white: true
      post :update, params: {id: pawn.id, piece:{x_coord: 1, y_coord: 5}}
      expect(response).to have_http_status(200)
      game.reload
      expect(game.turn_user_id).to eq 2
    end

    it "should return success if correct player turn and move is valid" do
      current_user = FactoryGirl.create(:user, id: 1)
      sign_in current_user
      game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
      pawn = FactoryGirl.create :pawn, x_coord: 1, y_coord: 6, game_id: game.id, white: true
      post :update, params: {id: pawn.id, piece:{x_coord: 1, y_coord: 5}}
      expect(response).to have_http_status(200)
    end

     it "should return error if player turn is incorrect" do
       current_user = FactoryGirl.create(:user, id: 1)
       sign_in current_user
       game = Game.create turn_user_id: 2, white_player_user_id: 1, black_player_user_id: 2
       pawn = FactoryGirl.create :pawn, x_coord: 1, y_coord: 6, game_id: game.id, white: true
       post :update, params: {id: pawn.id, piece:{x_coord: 1, y_coord: 5}}
       expect(response).to have_http_status(422)
     end

     it "should return error if invalid piece move" do
       current_user = FactoryGirl.create(:user, id: 1)
       sign_in current_user
       game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
       pawn = FactoryGirl.create :pawn, x_coord: 1, y_coord: 6, game_id: game.id, white: true
       post :update, params: {id: pawn.id, piece:{x_coord: 3, y_coord: 4}}
       expect(response).to have_http_status(422)
     end

     it "should return error if the piece's move path is obstructed" do
       current_user = FactoryGirl.create(:user, id: 1)
       sign_in current_user
       game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
       bishop = FactoryGirl.create :bishop, x_coord: 1, y_coord: 6, game_id: game.id, white: true
       pawn = FactoryGirl.create :pawn, x_coord: 2, y_coord: 5, game_id: game.id, white: true
       post :update, params: {id: bishop.id, piece:{x_coord: 3, y_coord: 4}}
       expect(response).to have_http_status(422)
     end

    it "should return error if the piece is moving to a square occupied by same color" do
      current_user = FactoryGirl.create(:user, id: 1)
      sign_in current_user
      game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
      bishop = FactoryGirl.create :bishop, x_coord: 1, y_coord: 6, game_id: game.id, white: true
      pawn = FactoryGirl.create :pawn, x_coord: 3, y_coord: 4, game_id: game.id, white: true
      post :update, params: {id: bishop.id, piece:{x_coord: 3, y_coord: 4}}
      expect(response).to have_http_status(422)
    end

    it "should return true if a rook tries to capture opponent" do
      current_user = FactoryGirl.create(:user, id: 2)
      sign_in current_user
      game = Game.create turn_user_id: 2, white_player_user_id: 1, black_player_user_id: 2
      rook = game.pieces.find_by(name: "Rook_black")
      rook.update_attributes(x_coord: 3, y_coord: 3)
      bishop = game.pieces.find_by(name: "Bishop_white")
      bishop.update_attributes(x_coord: 5, y_coord: 3)
      post :update, params: {id:rook.id, piece:{x_coord: 5, y_coord: 3}}
      expect(response).to have_http_status(200)
      bishop.reload
      expect(bishop.x_coord).to eq nil
    end

    it "should return false if a pawn tries to capture opponent vertically" do
      current_user = FactoryGirl.create(:user, id: 1)
      sign_in current_user
      game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
      pawn = game.pieces.find_by(name: "Pawn_white")
      bishop = game.pieces.find_by(name: "Bishop_black")
      bishop.update_attributes(x_coord: 1, y_coord: 6)
      post :update, params: {id:pawn.id, piece:{x_coord: 1, y_coord:6}}
      expect(response).to have_http_status(422)
    end

    it "should return true if a pawn tries to capture opponent diagonally" do
      current_user = FactoryGirl.create(:user, id: 1)
      sign_in current_user
      game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
      pawn = game.pieces.find_by(name: "Pawn_white")
      bishop = game.pieces.find_by(name: "Bishop_black")
      bishop.update_attributes(x_coord: 2, y_coord: 6)
      post :update, params: {id:pawn.id, piece:{x_coord: 2, y_coord:6}}
      expect(response).to have_http_status(200)
    end

    it "should return false if a pawn tries to move vertically into a square that contains the same color piece" do
      current_user = FactoryGirl.create(:user, id: 1)
      sign_in current_user
      game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
      pawn = game.pieces.find_by(name: "Pawn_white")
      bishop = game.pieces.find_by(name: "Bishop_white")
      bishop.update_attributes(x_coord: 1, y_coord: 6)
      post :update, params: {id:pawn.id, piece:{x_coord: 1, y_coord:6}}
      expect(response).to have_http_status(422)
    end
  end


end
