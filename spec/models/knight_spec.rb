require 'rails_helper'

RSpec.describe Knight, type: :model do
  describe "#valid move?" do
    it "should return true to move one square forward, two squares up" do
      game = Game.create
      knight = FactoryGirl.create :knight, x_coord: 5, y_coord: 5, game_id: game.id
      expect(knight.valid_move?(6, 7)).to eq(true)
    end 

    it "should return true to move one square backward, two squares up" do
      game = Game.create
      knight = FactoryGirl.create :knight, x_coord: 5, y_coord: 5, game_id: game.id
      expect(knight.valid_move?(4, 7)).to eq(true)
    end 

    it "should return true to move two squares forward, one square down" do
      game = Game.create
      knight = FactoryGirl.create :knight, x_coord: 5, y_coord: 5, game_id: game.id
      expect(knight.valid_move?(7, 6)).to eq(true)
    end 

    it "should return true to move two squares backward, one square down" do
      game = Game.create
      knight = FactoryGirl.create :knight, x_coord: 5, y_coord: 5, game_id: game.id
      expect(knight.valid_move?(3, 6)).to eq(true)
    end 

    it "should return false to move two squares horizontal, zero squares vertically" do
      game = Game.create
      knight = FactoryGirl.create :knight, x_coord: 5, y_coord: 5, game_id: game.id
      expect(knight.valid_move?(7, 5)).to eq(false)
    end 
  end
end
