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
 describe "#check?" do
   #diagonal capture will pass once merged. It is failing for now because lacking diagonal logic
   it "should return true for pawn to put king in check" do
     user = FactoryGirl.create :user
     game = Game.create turn_user_id: user.id
     king = FactoryGirl.create :king, x_coord: 3, y_coord: 3, game_id: game.id
     pawn = FactoryGirl.create :pawn, x_coord: 2, y_coord: 4, game_id: game.id, user_id: user.id
     expect(king.check?(king.x_coord, king.y_coord)).to eq(true)
    end

   it "should return false to put king in check" do
     user = FactoryGirl.create :user
     game = Game.create turn_user_id: user.id
     king = FactoryGirl.create :king, x_coord: 3, y_coord: 3, game_id: game.id
     rook = FactoryGirl.create :rook, x_coord: 7, y_coord: 4, game_id: game.id, user_id: user.id
     expect(king.check?(king.x_coord, king.y_coord)).to eq(false)
    end

    it "should return true for rook to put king in check" do
     user = FactoryGirl.create :user
     game = Game.create turn_user_id: user.id
     king = FactoryGirl.create :king, x_coord: 3, y_coord: 3, game_id: game.id
     rook = FactoryGirl.create :rook, x_coord: 3, y_coord: 7, game_id: game.id, user_id: user.id
     expect(king.check?(king.x_coord, king.y_coord)).to eq(true)
    end
 end

 describe "#find_threat_and_determine_checkmate" do
   it "should return true if checkmate is true" do
     game = Game.create turn_user_id: 1
     black_king = game.pieces.find_by(name:"King_black")
     black_king.update_attributes(x_coord:1, y_coord: 4, user_id: 1)
     white_pawn = game.pieces.where(name: "Pawn_white")
     white_pawn.delete_all
     black_pawn = game.pieces.where(name: "Pawn_black")
     black_pawn.update_all(user_id: 1)
     rook = game.pieces.find_by(name: "Rook_white")
     rook.update_attributes(x_coord:1, y_coord: 8, user_id: 2)
     black_piece1 = FactoryGirl.create(:pawn,user_id: 1,x_coord:1, y_coord: 3, game_id: game.id, white:false)
     black_piece2 = FactoryGirl.create(:pawn,user_id: 1,x_coord:2, y_coord: 3, game_id: game.id, white:false)
     black_piece3 = FactoryGirl.create(:pawn,user_id: 1,x_coord:2, y_coord: 4, game_id: game.id, white:false)
     black_piece4 = FactoryGirl.create(:pawn,user_id: 1,x_coord:2, y_coord: 5, game_id: game.id, white:false)
     expect(black_king.find_threat_and_determine_checkmate(black_king)).to eq true
   end
 end

 describe "#check_mate?" do
   it "should return false if the king has valid_moves left" do
     game = Game.create turn_user_id: 1
     black_king = game.pieces.find_by(name:"King_black")
     black_king.update_attributes(x_coord:1, y_coord: 4, user_id: 1)
     white_pawn = game.pieces.where(name: "Pawn_white")
     white_pawn.delete_all
     black_pawn = game.pieces.where(name: "Pawn_black")
     black_pawn.update_all(user_id: 1)
     rook = game.pieces.find_by(name: "Rook_white")
     rook.update_attributes(x_coord:1, y_coord: 8, user_id: 2)
     expect(black_king.check_mate?(black_king, rook)).to eq false
   end

   it "should return false if any other piece(knight example) can help block king" do
     game = Game.create turn_user_id: 1
     black_king = game.pieces.find_by(name:"King_black")
     black_king.update_attributes(x_coord:1, y_coord: 4, user_id: 1)
     white_pawn = game.pieces.where(name: "Pawn_white")
     white_pawn.delete_all
     black_pawn = game.pieces.where(name: "Pawn_black")
     black_pawn.update_all(user_id: 1)
     rook = game.pieces.find_by(name: "Rook_white")
     rook.update_attributes(x_coord:1, y_coord: 8, user_id: 2)
     black_knight = game.pieces.find_by(name:"Knight_black")
     black_knight.update_attributes(x_coord:2, y_coord:5, user_id: 1)
     expect(black_king.check_mate?(black_king, rook)).to eq false
   end

   it "should return true if the king has no valid moves, no piece can help block and king cannot capture threat" do
     game = Game.create turn_user_id: 1
     black_king = game.pieces.find_by(name:"King_black")
     black_king.update_attributes(x_coord:1, y_coord: 4, user_id: 1)
     white_pawn = game.pieces.where(name: "Pawn_white")
     white_pawn.delete_all
     black_pawn = game.pieces.where(name: "Pawn_black")
     black_pawn.update_all(user_id: 1)
     rook = game.pieces.find_by(name: "Rook_white")
     rook.update_attributes(x_coord:1, y_coord: 8, user_id: 2)
     black_piece1 = FactoryGirl.create(:pawn,user_id: 1,x_coord:1, y_coord: 3, game_id: game.id, white:false)
     black_piece2 = FactoryGirl.create(:pawn,user_id: 1,x_coord:2, y_coord: 3, game_id: game.id, white:false)
     black_piece3 = FactoryGirl.create(:pawn,user_id: 1,x_coord:2, y_coord: 4, game_id: game.id, white:false)
     black_piece4 = FactoryGirl.create(:pawn,user_id: 1,x_coord:2, y_coord: 5, game_id: game.id, white:false)
     expect(black_king.check_mate?(black_king, rook)).to eq true
   end
 end

end
