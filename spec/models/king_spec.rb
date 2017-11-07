require 'rails_helper'

RSpec.describe King, type: :model do
  
  describe "#valid move?" do
   it "should return true to move one square forward" do
    game = Game.create
    king = FactoryGirl.create :king, x_coord: 5, y_coord: 5, game_id: game.id
   expect(king.valid_move?(6, 5)).to eq(true)
   end 

   it "should return true to move one square backward" do
    game = Game.create
    king = FactoryGirl.create :king, x_coord: 5, y_coord: 5, game_id: game.id
   expect(king.valid_move?(4, 5)).to eq(true)
   end 

   it "should return true to move one square up" do
    game = Game.create
    king = FactoryGirl.create :king, x_coord: 5, y_coord: 5, game_id: game.id
   expect(king.valid_move?(5, 4)).to eq(true)
   end 

   it "should return true to move one square down" do
    game = Game.create
    king = FactoryGirl.create :king, x_coord: 5, y_coord: 5, game_id: game.id
   expect(king.valid_move?(5, 6)).to eq(true)
   end 

   it "should return true to move one square diagonally" do
    game = Game.create
    king = FactoryGirl.create :king, x_coord: 5, y_coord: 5, game_id: game.id
   expect(king.valid_move?(6, 6)).to eq(true)
   end 

   it "should return false to move two squares forward" do
    game = Game.create
    king = FactoryGirl.create :king, x_coord: 5, y_coord: 5, game_id: game.id
   expect(king.valid_move?(7, 5)).to eq(false)
   end 

 end


end
