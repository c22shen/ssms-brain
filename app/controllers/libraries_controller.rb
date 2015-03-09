class LibrariesController < ApplicationController
	def index 
            
      end
      def show
            @homestyle='black'

            admin_option = User.find_by_email('admin@ssmsgroup.ca').option

            query_string = (admin_option=='sim') ? "mode='sim'" : "mode!='sim'"

            seats_info = Array.new
            Seat.where(query_string).order( 'uid' ).each do |seat|

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
                  # seat_info[:lineWidth]=1.5
                  # seat_info[:lineColor]='white'
                  seats_info.push(seat_info)
            

                  @seats_info = seats_info.to_json.html_safe

                  @data2 = Array.new
                  @data3 = Array.new

                  # Library Detail Page

                  option = User.find_by_email('admin@ssmsgroup.ca').option

                  mode_query_string = (option == 'live') ? "mode='live'" : "mode='sim'"

                  @busy_seat_count = Seat.where(mode_query_string).where("status='busy'").count
                  @free_seat_count = Seat.where(mode_query_string).where("status='free'").count
                  @away_seat_count = Seat.where(mode_query_string).where("status='away'").count
      	

                  @free_seat_percentage = @free_seat_count * 100.0/(@busy_seat_count+@free_seat_count+@away_seat_count) 
            end   
      end
end