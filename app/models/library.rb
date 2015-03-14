class Library < ActiveRecord::Base
	has_many :seats, :dependent => :destroy

	def floor_array
    	return floors.split(',').map(&:to_i)
  	end

  	def acronym
    	return name.scan(/(\A|\W)(\w)/).collect{|s| s[1]}.join.downcase
  	end
end
