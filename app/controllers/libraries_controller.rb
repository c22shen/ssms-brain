class LibrariesController < ApplicationController
	def index 
            
      end

      def set_location  
            @homestyle='white'

            admin_option = User.find_by_email('admin@ssmsgroup.ca').option

            query_string = (admin_option=='sim') ? "mode='sim'" : "mode!='sim'"

            seats_info = Array.new
            Seat.where(query_string).order( 'uid' ).each do |seat|

                  if seat.status =='free'
                        color = '#468966'
                  elsif seat.status == 'busy'
                        color = '#8E2800'
                  else
                        color = "#FFB03B"
                  end




                  seat_info = Hash.new
                  seat_info[:name]=seat.uid
                  seat_info[:id]=seat.uid
                  seat_info[:color]=color
                  seat_info[:x]=seat.x
                  seat_info[:y]=seat.y
                  # seat_info[:z]=0
                  # seat_info[:lineWidth]=1.5
                  # seat_info[:lineColor]='white'
                  seats_info.push(seat_info)
            
            end
                  @seats_info = seats_info.to_json.html_safe

      end

      def show
            @homestyle='#252020'

            admin_option = User.find_by_email('admin@ssmsgroup.ca').option

            query_string = (admin_option=='sim') ? "mode='sim'" : "mode!='sim'"

            seats_info = Array.new
            seats_info1 = Array.new
            seats_info_floor2 = Array.new
            Seat.where(query_string).order( 'uid' ).each do |seat|

                  if seat.status =='free'
                        color = '#468966'
                  elsif seat.status == 'busy'
                        color = '#8E2800'
                  else
                        color = "#FFB03B"
                  end


                  if seat.z==1

                        seat_info = Hash.new
                        seat_info[:name]=seat.uid
                        seat_info[:id]=seat.uid
                        seat_info[:color]=color
                        seat_info[:x]=seat.x
                        seat_info[:y]=seat.y
                        # seat_info[:z]=seat.z
                        seats_info.push(seat_info)
                  elsif seat.z==2
                        seat_info2 = Hash.new
                        seat_info2[:name]=seat.uid
                        seat_info2[:id]=seat.uid
                        seat_info2[:color]=color
                        seat_info2[:x]=seat.x
                        seat_info2[:y]=seat.y
                        # seat_info2[:z]=seat.z
                        seats_info_floor2.push(seat_info2)
                  end

# for 3d graph
                  seat_info1 = Hash.new
                  seat_info1[:name]=seat.uid
                  seat_info1[:id]=seat.uid
                  seat_info1[:color]=color
                  seat_info1[:x]=seat.x
                  seat_info1[:y]=seat.z
                  seat_info1[:z]=seat.y
                  # seat_info[:lineWidth]=1.5
                  # seat_info[:lineColor]='white'
                  # seats_info.push(seat_info)
                  seats_info1.push(seat_info1)
            

                  

                  @data2 = Array.new
                  @data3 = Array.new

                  # Library Detail Page

                  @busy_seat_count = Seat.where(query_string).where("status='busy'").count
                  @free_seat_count = Seat.where(query_string).where("status='free'").count
                  # @<%= @seats_info %>away_seat_count = Seat.where(mode_query_string).where("status='away'").count
      	
                  @free_count = Array.new 
                  @free_count.push(@free_seat_count)

                  @free_count.push(rand(10..40))
                  # @free_count.push(rand(10..40))

                  @busy_count = Array.new 
                  @busy_count.push(@busy_seat_count)

                  @busy_count.push(rand(10..40))
                  # @busy_count.push(rand(10..40))

                  # @away_count = Array.new 
                  # @away_count.push(@away_seat_count)

                  # @away_count.push(rand(10..40))
                  # @away_count.push(rand(10..40))

                  @free_seat_percentage = @free_seat_count * 100.0/(@busy_seat_count+@free_seat_count) 
            end  
            @seats_info = seats_info.to_json.html_safe 
            @seats_info1 = seats_info1.to_json.html_safe 
            @seats_info_floor2 = seats_info_floor2.to_json.html_safe 
            @z_max= Seat.where(query_string).maximum('y')
      end
end