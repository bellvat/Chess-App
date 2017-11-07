FactoryGirl.define do
  factory :pawn do
    
  end
  factory :king do
   
  end
  factory :queen do
    
  end
  factory :knight do
    
  end
  factory :bishop do
    
  end
  factory :rook do
    
  end
  factory :game_piece do
    
  end
  factory :piece do
  
  end

  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password "secretPassword"
    password_confirmation "secretPassword"
  end
end
