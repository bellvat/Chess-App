class Piece < ApplicationRecord
  belongs_to :game
  belongs_to :user, required: false

  def is_obstructed(x_start, y_start, x_end, y_end)
    if x_start == x_end # If it's moving vertically
      y_change = (y_start - y_end).abs # Find number of steps --> 7
      obstruction_array = []
      y_change.times do |i| # 7 times do (0..6).each do 
        obstruction_array << [x_start, (y_start - (i + 1))]        
      end
    end

    obstruction_array.each do |square|
      if game.contains_piece?(square[0], square[1]) == false
        return false
      end
    end
  end

  def color
    white? ? 'white' : 'black'
  end

  def image
    image ||= "#{name}.png"
  end
end
