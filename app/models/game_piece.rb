class GamePiece < ApplicationRecord
  belongs_to :game
  belongs_to :piece
end
