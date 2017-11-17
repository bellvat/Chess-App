require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  describe "piece#update" do

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

  end

end
