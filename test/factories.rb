FactoryGirl.define do
  factory :user do
    email "cching@berkeley.edu"
  end

  factory :review do 
  	rating 5
  	movie_id 550
  	user_id 1
  end
end