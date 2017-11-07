require 'rails_helper'

RSpec.describe Queen, type: :model do

  it "should return true to move diagonally" do
    game = Game.create
    queen = FactoryGirl.create :queen, x_coord: 5, y_coord: 5, game_id: game.id
    expect(queen.valid_move?(7, 7)).to eq(true)
  end

  it "should return true to move three squares backward" do
      game = Game.create
      queen = FactoryGirl.create :queen, x_coord: 5, y_coord: 5, game_id: game.id
      expect(queen.valid_move?(5, 2)).to eq(true)
  end

  it "should return true to move two squares to the right" do
      game = Game.create
      queen = FactoryGirl.create :queen, x_coord: 5, y_coord: 5, game_id: game.id
      expect(queen.valid_move?(7, 5)).to eq(true)
  end

  it "should return false to move one square forward, two squares up" do
    game = Game.create
    queen = FactoryGirl.create :queen, x_coord: 5, y_coord: 5, game_id: game.id
    expect(queen.valid_move?(6, 7)).to eq(false)
  end   

end
