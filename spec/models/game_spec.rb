require 'rails_helper'

RSpec.describe Game, type: :model do
  describe "lay_out_board" do
    it "should create create white pawns at x coord 1-8, and y coord 7"do
      game = FactoryGirl.create(:game)
      pawn = game.pieces.find_by(name:"Pawn_white")
      expect(pawn.x_coord).to eq 1
      expect(pawn.y_coord).to eq 7
    end
    it "should create create white rooks at x coord 1,8, and y coord 8"do
      game = FactoryGirl.create(:game)
      rook = game.pieces.find_by(name:"Rook_white")
      expect(rook.x_coord).to eq 1
      expect(rook.y_coord).to eq 8
    end
    it "should create create white knights at x coord 2,7, and y coord 8"do
      game = FactoryGirl.create(:game)
      knight = game.pieces.find_by(name:"Knight_white")
      expect(knight.x_coord).to eq 2
      expect(knight.y_coord).to eq 8
    end
    it "should create create white bishops at x coord 3,6, and y coord 8"do
      game = FactoryGirl.create(:game)
      bishop = game.pieces.find_by(name:"Bishop_white")
      expect(bishop.x_coord).to eq 3
      expect(bishop.y_coord).to eq 8
    end
    it "should create create white king at x coord 5, and y coord 8"do
      game = FactoryGirl.create(:game)
      king = game.pieces.find_by(name:"King_white")
      expect(king.x_coord).to eq 5
      expect(king.y_coord).to eq 8
    end
    it "should create create white queen at x coord 4, and y coord 8"do
      game = FactoryGirl.create(:game)
      queen = game.pieces.find_by(name:"Queen_white")
      expect(queen.x_coord).to eq 4
      expect(queen.y_coord).to eq 8
    end
    it "should create create black pawns at x coord 1-8, and y coord 2"do
      game = FactoryGirl.create(:game)
      pawn = game.pieces.find_by(name:"Pawn_black")
      expect(pawn.x_coord).to eq 1
      expect(pawn.y_coord).to eq 2
    end
    it "should create create black rooks at x coord 1,8, and y coord 1"do
      game = FactoryGirl.create(:game)
      rook = game.pieces.find_by(name:"Rook_black")
      expect(rook.x_coord).to eq 1
      expect(rook.y_coord).to eq 1
    end
    it "should create create black knights at x coord 2,7, and y coord 1"do
      game = FactoryGirl.create(:game)
      knight = game.pieces.find_by(name:"Knight_black")
      expect(knight.x_coord).to eq 2
      expect(knight.y_coord).to eq 1
    end
    it "should create create black bishops at x coord 3,6, and y coord 1"do
      game = FactoryGirl.create(:game)
      bishop = game.pieces.find_by(name:"Bishop_black")
      expect(bishop.x_coord).to eq 3
      expect(bishop.y_coord).to eq 1
    end
    it "should create create black king at x coord 5, and y coord 1"do
      game = FactoryGirl.create(:game)
      king = game.pieces.find_by(name:"King_black")
      expect(king.x_coord).to eq 5
      expect(king.y_coord).to eq 1
    end
    it "should create create black queen at x coord 4, and y coord 1"do
      game = FactoryGirl.create(:game)
      queen = game.pieces.find_by(name:"Queen_black")
      expect(queen.x_coord).to eq 4
      expect(queen.y_coord).to eq 1
    end
  end
end
