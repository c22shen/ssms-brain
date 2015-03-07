class LibrariesController < ApplicationController
	def index 
            
      end
      def show
            @homestyle='black'
# 		@data1 = Array.new

#             arr ={"name" => 'pt', 'color' => '#00FF00', 'x'=>1, 'y'=>1 }
#             @data1.push(arr)


#             data: [{
#     name: 'Point 1',
#     color: '#00FF00',
#     y: 0
# }, {
#     name: 'Point 2',
#     color: '#FF00FF',
#     y: 5
# }]


seats_info = Array.new
Seat.all.order( 'uid' ).each do |seat|

      if seat.status =='free'
            color = '#00FF00'
      elsif seat.status == 'busy'
            color = '#DC143C'
      else
            color = "#4682B4"
      end




      seat_info = Hash.new
      seat_info[:name]=seat.uid
      seat_info[:id]=seat.uid
      seat_info[:color]=color
      seat_info[:x]=seat.x
      seat_info[:y]=seat.y
      seat_info[:lineWidth]=1.5
      seat_info[:lineColor]='white'
      seats_info.push(seat_info)
end

@seats_info = seats_info.to_json.html_safe
# @seats_info ='xiao'
# logger.info @seats_info


            # (1..2).each do |i|
            # 	arr =[rand(150...200),  rand(50...100)]
            # 	@data1.push(arr)
            # end 


		@data2 = Array.new

            # (1..2).each do |i|
            # 	arr =[rand(150...200),  rand(50...100)]
            # 	@data2.push(arr)
            # end 


            @data3 = Array.new

 #            (1..200).each do |i|
 #            	arr =[rand(150...200),  rand(50...100)]
 #            	@data3.push(arr)
 #            end 
	end
end
