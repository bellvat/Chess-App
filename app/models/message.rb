class Message < ApplicationRecord
  after_create :send_to_firebase

  belongs_to :game
  belongs_to :user

  def send_to_firebase
    FIREBASE.push("game_message", { id: self.id, body: self.body, user_id: self.user_id, game_id: self.game_id, '.priority': 1 })
  end
end
