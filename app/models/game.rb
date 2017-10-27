class Game < ApplicationRecord
  has_many :user_games
  has_many :users, through: :user_games
  has_many :game_pieces
  has_many :pieces, through: :game_pieces

  after_create :lay_out_board!

  def lay_out_board!
    # WHITE PIECES
      # Pawns
      (1..8).each do |x_coord|
        GamePiece.create(game_id: id, piece: Piece.find_by_name("Pawn"), white?: true, x_coord: x_coord, y_coord: 2)
      end

      # Rooks
      [1, 8].each do |x_coord|
        GamePiece.create(game_id: id, piece: Piece.find_by_name("Rook"), white?: true, x_coord: x_coord, y_coord: 1)
      end

      # Knights
      [2, 7].each do |x_coord|
        GamePiece.create(game_id: id, piece: Piece.find_by_name("Knight"), white?: true, x_coord: x_coord, y_coord: 1)
      end

      #Bishops
      [3, 6].each do |x_coord|
        GamePiece.create(game_id: id, piece: Piece.find_by_name("Bishop"), white?: true, x_coord: x_coord, y_coord: 1)
      end

      #King
      GamePiece.create(game_id: id, piece: Piece.find_by_name("King"), white?: true, x_coord: 5, y_coord: 1)

      #Queen
      GamePiece.create(game_id: id, piece: Piece.find_by_name("Queen"), white?: true, x_coord: 4, y_coord: 1)

    # BLACK PIECES
      # Pawns
      (1..8).each do |x_coord|
        GamePiece.create(game_id: id, piece: Piece.find_by_name("Pawn"), white?: true, x_coord: x_coord, y_coord: 7)
      end

      # Rooks
      [1, 8].each do |x_coord|
        GamePiece.create(game_id: id, piece: Piece.find_by_name("Rook"), white?: true, x_coord: x_coord, y_coord: 8)
      end

      # Knights
      [2, 7].each do |x_coord|
        GamePiece.create(game_id: id, piece: Piece.find_by_name("Knight"), white?: true, x_coord: x_coord, y_coord: 8)
      end

      #Bishops
      [3, 6].each do |x_coord|
        GamePiece.create(game_id: id, piece: Piece.find_by_name("Bishop"), white?: true, x_coord: x_coord, y_coord: 8)
      end

      #King
      GamePiece.create(game_id: id, piece: Piece.find_by_name("King"), white?: true, x_coord: 4, y_coord: 8)

      #Queen
      GamePiece.create(game_id: id, piece: Piece.find_by_name("Queen"), white?: true, x_coord: 5, y_coord: 8)
  end


  def white_player
    User.find_by_id(white_player_user_id)
  end

  def black_player
    User.find_by_id(black_player_user_id)
  end

  def winner
    User.find_by_id(winner_user_id)
  end
end
