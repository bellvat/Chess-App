require 'rails_helper'

RSpec.describe Piece, type: :model do
  describe "#contains_own_piece?" do
    it "should return true if the end coordinates contains own piece" do
      game = FactoryGirl.create(:game)
      pawn1 = FactoryGirl.create(:pawn, x_coord: 5, y_coord: 5, white:true, game_id: game.id)
      pawn2 = FactoryGirl.create(:pawn, x_coord: 5, y_coord: 4, white:true, game_id: game.id)
      result = pawn1.contains_own_piece?(5,4)
      expect(result).to eq (true)
    end
  end

  describe "#is_obstructed" do
    it "should return true if there is a piece obstructing horizontal path" do
      game = FactoryGirl.create(:game)
      rook = FactoryGirl.create(:rook, x_coord: 5, y_coord: 5, white:true, game_id: game.id)
      pawn = FactoryGirl.create(:pawn, x_coord: 6, y_coord: 5, white:true, game_id: game.id)
      result = rook.is_obstructed(7,5)
      expect(result).to eq (true)
    end

    it "should return true if there is a piece obstructing vertical path" do
      game = FactoryGirl.create(:game)
      rook = FactoryGirl.create(:rook, x_coord: 5, y_coord: 5, white:true, game_id: game.id)
      pawn = FactoryGirl.create(:pawn, x_coord: 5, y_coord: 6, white:true, game_id: game.id)
      result = rook.is_obstructed(5,7)
      expect(result).to eq (true)
    end

    it "should return true if there is a piece obstructing diagonal path" do
      game = FactoryGirl.create(:game)
      bishop = FactoryGirl.create(:bishop, x_coord: 3, y_coord: 3, white:true, game_id: game.id)
      pawn = FactoryGirl.create(:pawn, x_coord: 4, y_coord: 4, white:false, game_id: game.id)
      result = bishop.is_obstructed(5,5)
      expect(result).to eq (true)
    end
  end

  describe "#remove_piece" do
    it "should update captured pieces attributes to nil" do
      game = FactoryGirl.create(:game)
      bishop = FactoryGirl.create(:bishop, x_coord: 3, y_coord: 3, white:true, game_id: game.id)
      result = bishop.remove_piece(bishop)
      expect(bishop.x_coord).to eq nil
    end
  end

end
