require 'rails_helper'

RSpec.describe Bishop, type: :model do
  
  describe "#valid move?" do

    it "should return true to move diagonally" do
      game = Game.create
      bishop = FactoryGirl.create :bishop, x_coord: 5, y_coord: 5, game_id: game.id
      expect(bishop.valid_move?(7, 7)).to eq(true)
    end

    it "should return false to move one square forward" do
      game = Game.create
      bishop = FactoryGirl.create :bishop, x_coord: 5, y_coord: 5, game_id: game.id
      expect(bishop.valid_move?(5, 6)).to eq(false)
    end 

    it "should return false to move three squares to the left" do
      game = Game.create
      bishop = FactoryGirl.create :bishop, x_coord: 5, y_coord: 5, game_id: game.id
      expect(bishop.valid_move?(2, 5)).to eq(false)
    end     

    it "should return false to move to a non-same-color square" do
      game = Game.create
      bishop = FactoryGirl.create :bishop, x_coord: 5, y_coord: 5, game_id: game.id
      expect(bishop.valid_move?(2, 3)).to eq(false)
    end     
  end 

end
