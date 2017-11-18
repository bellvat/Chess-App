require 'rails_helper'

RSpec.describe Pawn, type: :model do

  describe "#valid move?" do

# ------ Opening Move ------------

    it "should return true to move one square forward on first move" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 2, y_coord: 2, game_id: game.id, white: false
      expect(pawn.valid_move?(2, 3)).to eq(true)
    end

    it "should return true to move two squares forward on first move" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 2, y_coord: 7, game_id: game.id, white: true
      expect(pawn.valid_move?(2, 5)).to eq(true)
    end

    it "should return false to move three squares forward on first move" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 2, y_coord: 2, game_id: game.id, white: false
      expect(pawn.valid_move?(2, 5)).to eq(false)
    end

    it "should return false to move one square sideways on first move" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 2, y_coord: 2, game_id: game.id, white: false
      expect(pawn.valid_move?(3, 2)).to eq(false)
    end

# ------ Subsequent Moves ------------

    it "should return true for black pawn to move one square forward" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 5, y_coord: 5, game_id: game.id, white: false
      expect(pawn.valid_move?(5, 6)).to eq(true)
    end

    it "should return true for white pawn to move one square forward" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 5, y_coord: 5, game_id: game.id, white: true
      expect(pawn.valid_move?(5, 4)).to eq(true)
    end

    it "should return false for black pawn to move backward" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 5, y_coord: 5, game_id: game.id, white: false
      expect(pawn.valid_move?(5, 4)).to eq(false)
    end

    it "should return false for white pawn to move backward" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 5, y_coord: 5, game_id: game.id, white: true
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

    it "should return true if black pawn is moving diagonally to capture opponent piece" do
      game = Game.create
      pawn = game.pieces.find_by(name: "Pawn_black")
      pawn.update_attributes(x_coord: 3, y_coord: 3)
      rook = game.pieces.find_by(name: "Rook_white")
      rook.update_attributes(x_coord: 4, y_coord: 4)
      expect(pawn.valid_move?(4,4)).to eq(true)
    end

    it "should return false if pawn tries to move vertically to square with an opponent piece" do
      game = Game.create
      pawn = FactoryGirl.create :pawn, x_coord: 2, y_coord: 6, game_id: game.id, white: false
      expect(pawn.valid_move?(2, 7)).to eq(false)
    end

    # ------ En Passant ------------

    it "should return true for black pawn to capture white pawn en passant" do
      game = Game.create
      black_pawn = FactoryGirl.create :pawn, x_coord: 2, y_coord: 5, game_id: game.id, white: false
      white_pawn = FactoryGirl.create :pawn, x_coord: 1, y_coord: 5, game_id: game.id, white: true, move_number: 1
      expect(black_pawn.en_passant?(1, 6)).to eq(true)
    end

    it "should return false for black pawn to capture white pawn en passant if not white's first move" do
      game = Game.create
      black_pawn = FactoryGirl.create :pawn, x_coord: 2, y_coord: 5, game_id: game.id, white: false
      white_pawn = FactoryGirl.create :pawn, x_coord: 1, y_coord: 5, game_id: game.id, white: true, move_number: 2
      expect(black_pawn.en_passant?(1, 6)).to eq(false)
    end

    it "should return false when white pawn is not in a valid position" do
      game = Game.create
      black_pawn = FactoryGirl.create :pawn, x_coord: 2, y_coord: 5, game_id: game.id, white: false
      white_pawn = FactoryGirl.create :pawn, x_coord: 4, y_coord: 5, game_id: game.id, white: true, move_number: 1
      expect(black_pawn.en_passant?(1, 6)).to eq(false)
    end

    it "should return false for black pawn to capture white rook en passant" do
      game = Game.create
      black_pawn = FactoryGirl.create :pawn, x_coord: 2, y_coord: 5, game_id: game.id, white: false
      white_rook = FactoryGirl.create :rook, x_coord: 1, y_coord: 5, game_id: game.id, white: true, move_number: 1
      expect(black_pawn.en_passant?(1, 6)).to eq(false)
    end
  end
end
