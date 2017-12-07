class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:email]

  has_one :username
  has_many :user_games
  has_many :games, through: :user_games
  has_many :pieces

  validates :username,
  :presence => true,
  :uniqueness => {
    :case_sensitive => false
  } 

end
