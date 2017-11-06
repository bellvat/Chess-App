class Piece < ApplicationRecord
  belongs_to :game
  belongs_to :user, required: false

  def color
    white? ? 'white' : 'black'
  end

  def image
    image ||= "#{name}.png"
  end
end
