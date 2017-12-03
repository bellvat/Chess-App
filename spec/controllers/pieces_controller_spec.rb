require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  describe "#update" do
    #before {sign_in user}

    it "should update coordinates if successful move" do
      current_user = FactoryGirl.create(:user, id: 1)
      current_user2 = FactoryGirl.create(:user, id: 2)

      sign_in current_user2
      sign_in current_user
      game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
      game.pieces.delete_all
      black_king = FactoryGirl.create(:king, x_coord:5, y_coord: 1, user_id: 2, game_id: game.id, white: false)
      white_king = FactoryGirl.create(:king, x_coord:5, y_coord: 8, user_id: 1, game_id: game.id, white:true)
      pawn = FactoryGirl.create(:pawn, x_coord: 1, y_coord: 6, user_id: 1, game_id: game.id, white: true)
      post :update, params: {id: pawn.id, piece:{x_coord: 1, y_coord: 5}}
      expect(response).to have_http_status(200)
      pawn.reload
      expect(pawn.y_coord).to eq 5
    end

    it "should switch player turns if successful move" do
      current_user = FactoryGirl.create(:user, id: 1)
      current_user2 = FactoryGirl.create(:user, id: 2)

      sign_in current_user2
      sign_in current_user
      game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
      game.pieces.delete_all
      black_king = FactoryGirl.create(:king, x_coord:5, y_coord: 1, user_id: 2, game_id: game.id, white: false)
      white_king = FactoryGirl.create(:king, x_coord:5, y_coord: 8, user_id: 1, game_id: game.id, white:true)
      pawn = FactoryGirl.create(:pawn, x_coord: 1, y_coord: 6, user_id: 1, game_id: game.id, white: true)
      post :update, params: {id: pawn.id, piece:{x_coord: 1, y_coord: 5}}
      expect(response).to have_http_status(200)
      game.reload
      expect(game.turn_user_id).to eq 2
    end

     it "should return error if player turn is incorrect" do
       current_user = FactoryGirl.create(:user, id: 1)
       sign_in current_user
       game = Game.create turn_user_id: 2, white_player_user_id: 1, black_player_user_id: 2
       pawn = FactoryGirl.create :pawn, x_coord: 1, y_coord: 6, game_id: game.id, white: true
       post :update, params: {id: pawn.id, piece:{x_coord: 1, y_coord: 5}}, :format => :json
       expect(response).to have_http_status(422)
     end

     it "should return error if invalid piece move" do
       current_user = FactoryGirl.create(:user, id: 1)
       sign_in current_user
       game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
       pawn = FactoryGirl.create :pawn, x_coord: 1, y_coord: 6, game_id: game.id, white: true
       post :update, params: {id: pawn.id, piece:{x_coord: 3, y_coord: 4}}, :format => :json
       expect(response).to have_http_status(422)
     end

     it "should return error if the piece's move path is obstructed" do
       current_user = FactoryGirl.create(:user, id: 1)
       sign_in current_user
       game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
       bishop = FactoryGirl.create :bishop, x_coord: 1, y_coord: 6, game_id: game.id, white: true
       pawn = FactoryGirl.create :pawn, x_coord: 2, y_coord: 5, game_id: game.id, white: true
       post :update, params: {id: bishop.id, piece:{x_coord: 3, y_coord: 4}}, :format => :json
       expect(response).to have_http_status(422)
     end

    it "should return error if the piece is moving to a square occupied by same color" do
      current_user = FactoryGirl.create(:user, id: 1)
      current_user2 = FactoryGirl.create(:user, id: 2)

      sign_in current_user2
      sign_in current_user
      game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
      bishop = FactoryGirl.create :bishop, x_coord: 1, y_coord: 6, game_id: game.id, white: true
      pawn = FactoryGirl.create :pawn, x_coord: 3, y_coord: 4, game_id: game.id, white: true
      post :update, params: {id: bishop.id, piece:{x_coord: 3, y_coord: 4}}, :format => :json
      expect(response).to have_http_status(422)
    end

    it "should return true if a rook tries to capture opponent" do
      current_user = FactoryGirl.create(:user, id: 1)
      current_user2 = FactoryGirl.create(:user, id: 2)

      sign_in current_user
      sign_in current_user2
      game = Game.create turn_user_id: 2, white_player_user_id: 1, black_player_user_id: 2
      game.pieces.delete_all
      black_king = FactoryGirl.create(:king, x_coord:5, y_coord: 1, user_id: 2, game_id: game.id, white: false)
      white_king = FactoryGirl.create(:king, x_coord:5, y_coord: 8, user_id: 1, game_id: game.id, white:true)
      rook = FactoryGirl.create(:rook, x_coord:3, y_coord: 3, user_id: 2, game_id: game.id, white:false)
      bishop = FactoryGirl.create(:bishop, x_coord:5, y_coord: 3, user_id: 1, game_id: game.id, white:true)
      post :update, params: {id:rook.id, piece:{x_coord: 5, y_coord: 3}}
      expect(response).to have_http_status(200)
      bishop.reload
      expect(bishop.x_coord).to eq nil
    end

    it "should return false if a pawn tries to capture opponent vertically" do
      current_user = FactoryGirl.create(:user, id: 1)
      current_user2 = FactoryGirl.create(:user, id: 2)

      sign_in current_user2
      sign_in current_user
      game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
      pawn = game.pieces.find_by(name: "Pawn_white")
      bishop = game.pieces.find_by(name: "Bishop_black")
      bishop.update_attributes(x_coord: 1, y_coord: 6)
      post :update, params: {id:pawn.id, piece:{x_coord: 1, y_coord:6}}, :format => :json
      expect(response).to have_http_status(422)
    end

    it "should return true if a pawn tries to capture opponent diagonally" do
      current_user = FactoryGirl.create(:user, id: 1)
      current_user2 = FactoryGirl.create(:user, id: 2)

      sign_in current_user2
      sign_in current_user
      game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
      game.pieces.delete_all
      black_king = FactoryGirl.create(:king, x_coord:5, y_coord: 1, user_id: 2, game_id: game.id, white: false)
      white_king = FactoryGirl.create(:king, x_coord:5, y_coord: 8, user_id: 1, game_id: game.id, white:true)
      pawn = FactoryGirl.create(:pawn, x_coord:1, y_coord: 7, user_id: 1, game_id: game.id, white:true)
      bishop = FactoryGirl.create(:bishop, x_coord:2, y_coord: 6, user_id: 2, game_id: game.id, white:false)
      post :update, params: {id:pawn.id, piece:{x_coord: 2, y_coord:6}}
      expect(response).to have_http_status(200)
    end

    it "should return false if a pawn tries to move vertically into a square that contains the same color piece" do
      current_user = FactoryGirl.create(:user, id: 1)
      current_user2 = FactoryGirl.create(:user, id: 2)

      sign_in current_user2
      sign_in current_user
      game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
      pawn = game.pieces.find_by(name: "Pawn_white")
      bishop = game.pieces.find_by(name: "Bishop_white")
      bishop.update_attributes(x_coord: 1, y_coord: 6)
      post :update, params: {id:pawn.id, piece:{x_coord: 1, y_coord:6}}, :format => :json
      expect(response).to have_http_status(422)
    end

    it "should return status 201 if opponent king is in check and cannot move out of check" do
      current_user = FactoryGirl.create(:user, id: 1)
      current_user2 = FactoryGirl.create(:user, id: 2)

      sign_in current_user2
      sign_in current_user
      game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
      game.pieces.delete_all
      white_king = FactoryGirl.create(:king,user_id: 1,x_coord:6, y_coord: 2, game_id: game.id, white:true)
      black_king = FactoryGirl.create(:king, x_coord:1, y_coord: 4, user_id: 2, white:false, game_id: game.id)
      rook = FactoryGirl.create(:rook, user_id: 1, x_coord:1, y_coord:8,white:true, game_id: game.id)
      black_piece1 = FactoryGirl.create(:pawn,user_id: 2,x_coord:1, y_coord: 3, game_id: game.id, white:false)
      black_piece2 = FactoryGirl.create(:pawn,user_id: 2,x_coord:2, y_coord: 3, game_id: game.id, white:false)
      black_piece3 = FactoryGirl.create(:pawn,user_id: 2,x_coord:2, y_coord: 4, game_id: game.id, white:false)
      black_piece4 = FactoryGirl.create(:pawn,user_id: 2,x_coord:2, y_coord: 5, game_id: game.id, white:false)
      post :update, params: {id: rook.id, piece: {x_coord:1, y_coord:7 }}
      expect(response).to have_http_status(201)
    end

    it "should return status 200 if opponent king is in check and can move out of check" do
      current_user = FactoryGirl.create(:user, id: 1)
      current_user2 = FactoryGirl.create(:user, id: 2)

      sign_in current_user2
      sign_in current_user
      game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
      black_king = game.pieces.find_by(name:"King_black")
      black_king.update_attributes(x_coord:1, y_coord: 4, user_id: 2)
      white_pawn = game.pieces.where(name: "Pawn_white")
      white_pawn.delete_all
      black_pawn = game.pieces.where(name: "Pawn_black")
      black_pawn.update_all(user_id: 2)
      rook = game.pieces.find_by(name: "Rook_white")
      rook.update_attributes(user_id: 1, x_coord:1, y_coord:8)
      black_piece1 = FactoryGirl.create(:pawn,user_id: 2,x_coord:1, y_coord: 3, game_id: game.id, white:false)
      black_piece2 = FactoryGirl.create(:pawn,user_id: 2,x_coord:2, y_coord: 3, game_id: game.id, white:false)
      black_piece3 = FactoryGirl.create(:pawn,user_id: 2,x_coord:2, y_coord: 4, game_id: game.id, white:false)
      post :update, params: {id: rook.id, piece: {x_coord:1, y_coord:7 }}
      black_king.reload
      expect(flash[:notice]).to eq "King_black is in check!"
      expect(black_king.king_check).to eq 1
      expect(response).to have_http_status(200)
    end

    it "should return status 201 if opponent king is not in check but has no valide moves left (stalemate)" do
      current_user = FactoryGirl.create(:user, id: 1)
      current_user2 = FactoryGirl.create(:user, id: 2)

      sign_in current_user2
      sign_in current_user
      game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
      game.pieces.delete_all
      black_king = FactoryGirl.create(:king, x_coord:8, y_coord: 1, user_id: 2, game_id: game.id, white: false)
      white_king = FactoryGirl.create(:king,user_id: 1,x_coord:6, y_coord: 2, game_id: game.id, white:true)
      white_queen = FactoryGirl.create(:queen,user_id: 1,x_coord:7, y_coord: 4, game_id: game.id, white:true)
      post :update, params: {id: white_queen.id, piece: {x_coord:7, y_coord:3 }}
      expect(response).to have_http_status(201)
      game.reload
      expect(game.state).to eq "end"
    end

    it "should return 422 if the king tries to move into check by vertical pawn capture" do
      current_user = FactoryGirl.create(:user, id: 1)
      current_user2 = FactoryGirl.create(:user, id: 2)

      sign_in current_user2
      sign_in current_user

      game = Game.create turn_user_id: 1, white_player_user_id: 1, black_player_user_id: 2
      game.pieces.delete_all
      black_king = FactoryGirl.create(:king, x_coord:8, y_coord: 1, user_id: 2, game_id: game.id, white: false)
      white_king = FactoryGirl.create(:king, user_id: 1, x_coord:1, y_coord: 6, game_id: game.id, white:true)
      black_pawn = FactoryGirl.create(:pawn, x_coord: 2, y_coord: 4, game_id: game.id, white:false, user_id: 2)
      post :update, params: {id: white_king.id, piece: {x_coord:1, y_coord:5 }}, :format => :json
      expect(response).to have_http_status(422)
    end
  end
end
