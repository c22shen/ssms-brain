class Library < ActiveRecord::Base
	has_many :seats, :dependent => :destroy
	has_many :articles, :dependent => :destroy
  validates :name, presence: true
  # validates :noise, numericality: true
  validates :latitude,  presence: true
  validates :longitude,  presence: true


 # attr_accessible :address, :latitude, :longitude
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
 #  after_validation :geocode





	def floor_array
    unless floors.nil?
    	return floors.split(',').map(&:to_i)
  	end
    return []
  end

  	def acronym
    	return name.scan(/(\A|\W)(\w)/).collect{|s| s[1]}.join.downcase
  	end



  	def num_free_seats
  		return seats.where("status='free'").count 
  	end

    def popularity
      popularity_arr = Array.new
      Library.all.each do |library| 
        popularity_arr.push(library.articles.count)
      end
      popularity_arr  = popularity_arr.sort.reverse
      hash = Hash[popularity_arr.map.with_index.to_a]
      return hash[articles.count]+1
    end

    def average_rating 
      unless articles.count==0
        return articles.average("rating").round(1)
      end
      return 3
    end
end
