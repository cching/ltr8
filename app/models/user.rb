class User < ActiveRecord::Base
	validates :email, presence: true
	validates_uniqueness_of :email
	validates_format_of :email, :with => /@/, :message => "Invalid email format"

	has_many :reviews, dependent: :destroy
end
 