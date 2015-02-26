class LibrariesController < ApplicationController
	def index 
            
      end
      def show
		@data1 = Array.new

            (1..20).each do |i|
            	arr =[rand(150...200),  rand(50...100)]
            	@data1.push(arr)
            end 


		@data2 = Array.new

            (1..20).each do |i|
            	arr =[rand(150...200),  rand(50...100)]
            	@data2.push(arr)
            end 


            @data3 = Array.new

            (1..10).each do |i|
            	arr =[rand(150...200),  rand(50...100)]
            	@data3.push(arr)
            end 
	end
end
