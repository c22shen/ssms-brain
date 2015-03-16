class Article < ActiveRecord::Base
	belongs_to :library
	has_many :comments, dependent: :destroy
	validates :title, presence: true
    validates_presence_of :text
    validates :rating, numericality: true
end
