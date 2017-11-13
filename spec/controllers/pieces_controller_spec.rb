require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  describe "piece#update" do

  it "should return success if the player turn is correct" do

    user = FactoryGirl.create(:user)
    sign_in user
    game = FactoryGirl.create(:game)
    pawn = game.pieces.first
    patch :update, params: {id: pawn.id, piece:{x_coord: 5, y_coord: 2}}
    expect(response).to have_http_status(200)
  end

   it "should return error if the king moves more than one square" do
    game = Game.create
    user = FactoryGirl.create(:user)
    sign_in user
    king = FactoryGirl.create :king, x_coord: 5, y_coord: 1, game_id: game.id
    patch :update, params: {id: king.id, piece:{x_coord: 5, y_coord: 3}}
   expect(response).to have_http_status(422)
   end


   it "should return error if the piece's move path is obstructed" do
    game = Game.create
    user = FactoryGirl.create(:user)
    sign_in user
    rook = FactoryGirl.create :rook, x_coord: 8, y_coord: 1, game_id: game.id
    pawn = FactoryGirl.create :rook, x_coord: 8, y_coord: 2, game_id: game.id
    patch :update, params: {id: rook.id, piece:{x_coord: 8, y_coord: 3}}
   expect(response).to have_http_status(422)
   end

   it "should return error if the piece is moving to a square occupied by a piece of the same color" do
    game = Game.create
    user = FactoryGirl.create(:user)
    sign_in user
    rook = FactoryGirl.create :rook, x_coord: 8, y_coord: 1, game_id: game.id, white: true
    pawn = FactoryGirl.create :rook, x_coord: 8, y_coord: 2, game_id: game.id, white: false
    patch :update, params: {id: rook.id, piece:{x_coord: 8, y_coord: 2}}
   expect(response).to have_http_status(422)
   end

  end

end
