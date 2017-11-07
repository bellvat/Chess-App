class Piece < ApplicationRecord
  belongs_to :game
  belongs_to :user, required: false

  def color
    white? ? 'white' : 'black'
  end

  def image
    image ||= "#{name}.png"
  end

  def x_distance(new_x_coord)
    (new_x_coord - x_coord).abs
  end

  def y_distance(new_y_coord)
    (new_y_coord - y_coord).abs
  end

end
