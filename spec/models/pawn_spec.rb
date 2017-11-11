require 'rails_helper'

RSpec.describe Pawn, type: :model do
  
  describe "#valid move?" do

# ------ Opening Move ------------    

    it "should return true to move one square forward on first move" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 2, y_coord: 2, game_id: game.id, white: true 
      expect(pawn.valid_move?(2, 3)).to eq(true)
    end

    it "should return true to move two squares forward on first move" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 2, y_coord: 7, game_id: game.id, white: false
      expect(pawn.valid_move?(2, 5)).to eq(true)
    end

    it "should return false to move three squares forward on first move" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 2, y_coord: 2, game_id: game.id, white: true
      expect(pawn.valid_move?(2, 5)).to eq(false)
    end

    it "should return false to move one square sideways on first move" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 2, y_coord: 2, game_id: game.id, white: true
      expect(pawn.valid_move?(3, 2)).to eq(false)
    end

# ------ Subsequent Moves ------------    

    it "should return true for white pawn to move one square forward" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 5, y_coord: 5, game_id: game.id, white: true
      expect(pawn.valid_move?(5, 6)).to eq(true)
    end

    it "should return true for black pawn to move one square forward" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 5, y_coord: 5, game_id: game.id, white: false
      expect(pawn.valid_move?(5, 4)).to eq(true)
    end

    it "should return false for white pawn to move backward" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 5, y_coord: 5, game_id: game.id, white: true
      expect(pawn.valid_move?(5, 4)).to eq(false)
    end

    it "should return false for black pawn to move backward" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 5, y_coord: 5, game_id: game.id, white: false
      expect(pawn.valid_move?(5, 6)).to eq(false)
    end

    it "should return false to move two squares forward" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 5, y_coord: 5, game_id: game.id, white: true
      expect(pawn.valid_move?(5, 7)).to eq(false)
    end

    it "should return false to move one square sideways" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 5, y_coord: 2, game_id: game.id, white: true
      expect(pawn.valid_move?(6, 2)).to eq(false)
    end
  end 
end