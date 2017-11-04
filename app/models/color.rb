class Color < GamePiece
  belongs_to :piece

  def Color
    @color = ["white", "black"]
  end
end