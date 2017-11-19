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

# -------------- Castling -------------------

  describe "#can_castle" do
    it 'should return true if attempting to castle kingside and can castle' do
      game = Game.create
      king = FactoryGirl.create :king, x_coord: 5, y_coord: 1, game_id: game.id
      rook = FactoryGirl.create :rook, x_coord: 8, y_coord: 1, game_id: game.id
      expect(king.can_castle?(7, 1)).to eq true
    end

     it 'should return true if attempting to castle queenside and can castle' do
      game = Game.create
      king = FactoryGirl.create :king, x_coord: 5, y_coord: 8, game_id: game.id
      rook = FactoryGirl.create :rook, x_coord: 1, y_coord: 8, game_id: game.id
      expect(king.valid_move?(3, 8)).to eq true
    end    
  end

   describe "#castle" do
    it 'should move the correct rook to correct coord when castling kingside' do
      game = Game.create
      king = FactoryGirl.create :king, x_coord: 5, y_coord: 1, game_id: game.id
      rook = FactoryGirl.create :rook, x_coord: 8, y_coord: 1, game_id: game.id
      rook = FactoryGirl.create :rook, x_coord: 1, y_coord: 1, game_id: game.id
      king.update_attributes(7, 0)
      expect(game.pieces.where(x_coord: 5, y_coord: 0).first).to have_attributes(:type => "Rook")
      expect(game.pieces.where(x_coord: 7, y_coord: 0).first).to be nil
      expect(game.pieces.where(x_coord: 0, y_coord: 0).first).to have_attributes(:type => "Rook")
    end

    it 'should move the king to correct coord when castling kingside' do
      game = Game.create(white_user_id: 0, black_user_id: 1)
      king = FactoryGirl.create(x_coord: 4, y_coord: 0, game_id: game.id, user_id: 1 )
      rook = FactoryGirl.create(x_coord: 0, y_coord: 0, game_id: game.id, user_id: 1)
      rook = FactoryGirl.create(x_coord: 7, y_coord: 0, game_id: game.id, user_id: 1)
      king.move_to!(6,0)
      expect(king).to have_attributes(:type => "King", :x_coord => 6, :y_coord => 0 )
    end

    it 'should move the king to correct coord when castling queenside' do
      game = Game.create(white_user_id: 0, black_user_id: 1)
      king = FactoryGirl.create(x_coord: 4, y_coord: 0, game_id: game.id, user_id: 1 )
      rook = FactoryGirl.create(x_coord: 0, y_coord: 0, game_id: game.id, user_id: 1)
      rook = FactoryGirl.create(x_coord: 7, y_coord: 0, game_id: game.id, user_id: 1)
      king.move_to!(2,0)
      expect(king).to have_attributes(:type => "King", :x_coord => 2, :y_coord => 0)
    end

    it 'should move the correct rook to correct coord when castling queenside' do
      game = Game.create(white_user_id: 0, black_user_id: 1)
      king = FactoryGirl.create(x_coord: 4, y_coord: 0, game_id: game.id, user_id: 1 )
      rook = FactoryGirl.create(x_coord: 0, y_coord: 0, game_id: game.id, user_id: 1 )
      rook = FactoryGirl.create(x_coord: 7, y_coord: 0, game_id: game.id, user_id: 1)
      king.move_to!(2,0)
      expect(game.pieces.where(x_coord: 7, y_coord: 0).first).to have_attributes(:type => "Rook")
      expect(game.pieces.where(x_coord: 0, y_coord: 0).first).to be nil
      expect(game.pieces.where(x_coord: 3, y_coord: 0).first).to have_attributes(:type => "Rook")    end
  end
end

