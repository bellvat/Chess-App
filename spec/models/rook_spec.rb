require 'rails_helper'

RSpec.describe Rook, type: :model do
  
  describe "#valid move?" do
    it "should return true to move one square forward" do
      game = Game.create
      rook = FactoryGirl.create :rook, x_coord: 5, y_coord: 5, game_id: game.id
      expect(rook.valid_move?(5, 6)).to eq(true)
    end 

    it "should return true to move three squares backward" do
      game = Game.create
      rook = FactoryGirl.create :rook, x_coord: 5, y_coord: 5, game_id: game.id
      expect(rook.valid_move?(5, 2)).to eq(true)
    end 
 
    it "should return true to move two squares to the left" do
      game = Game.create
      rook = FactoryGirl.create :rook, x_coord: 5, y_coord: 5, game_id: game.id
      expect(rook.valid_move?(3, 5)).to eq(true)
    end 

    it "should return true to move two squares to the right" do
      game = Game.create
      rook = FactoryGirl.create :rook, x_coord: 5, y_coord: 5, game_id: game.id
      expect(rook.valid_move?(7, 5)).to eq(true)
    end 

    it "should return false to move diagonally" do
      game = Game.create
      rook = FactoryGirl.create :rook, x_coord: 5, y_coord: 5, game_id: game.id
      expect(rook.valid_move?(7, 4)).to eq(false)
    end
  end 

end
