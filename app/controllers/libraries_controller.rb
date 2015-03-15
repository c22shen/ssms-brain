class LibrariesController < ApplicationController
	def index 
            
      end

      def set_location  
            # CLEAN UP LATERRRR
            @homestyle='white'

            # admin_option = User.find_by_email('admin@ssmsgroup.ca').option

            # query_string = (admin_option=='sim') ? "mode='sim'" : "mode!='sim'"

            seats_info = Array.new
            Seat.where("mode='live'").order( 'uid' ).each do |seat|

                  if seat.status =='free'
                        color = '#8DEB95'
                  elsif seat.status == 'busy'
                        color = '#EF5E43'
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

      def getStatusColor(status)
            if status =='free'
                  color = ENV['COLOR_FREE']
            else
                  color = ENV['COLOR_BUSY']
            end
      end

      def show
# Responsible for the very first time display 
            @homestyle='#252020'
            @library = Library.find(params[:id]) 
            seats_floor_array = Array.new
            seats_3d_array = Array.new
            @displayFloor = @library.floor_array.min


            # z and y are switched in the 3D plot
            @plot_3d_z_max = @library.seats.maximum("y")
            @plot_3d_y_max = @library.seats.maximum("z")+1
            @library.seats.each do |seat|
                  color = getStatusColor(seat.status)
                  seat_info_3d = Hash.new
                  seat_info_3d[:name]=seat.id
                  seat_info_3d[:id]=seat.id
                  seat_info_3d[:color]= color
                  # Change display orientation, switched on purpose
                  seat_info_3d[:x]=seat.x
                  seat_info_3d[:y]=seat.z
                  seat_info_3d[:z]=seat.y
                  seats_3d_array.push(seat_info_3d)

                  if seat.z == @displayFloor
                        seat_info_floor = Hash.new
                        seat_info_floor[:name]=seat.id
                        seat_info_floor[:id]=seat.id
                        seat_info_floor[:color]=color
                        seat_info_floor[:x]=seat.x
                        seat_info_floor[:y]=seat.y
                        seats_floor_array.push(seat_info_floor)
                  end

                  # Library Detail Section
                  @busy_seat_count = @library.seats.where("status='busy'").count
                  @free_seat_count = @library.seats.where("status='free'").count
                  @free_seat_percentage = @free_seat_count * 100.0/(@busy_seat_count+@free_seat_count) 


                  library_free_info_array = Array.new
                  library_busy_info_array = Array.new
                  Library.all.each do |library|
                        library_free_info_array.push(library.seats.where("status='free'").count)
                        library_busy_info_array.push(library.seats.where("status='busy'").count)
                  end
                  # Libraries Occupany Comparison
                  @library_names_array = Library.pluck(:name)
                  # @library_names = library_names.to_json.html_safe
                  @library_free_info_array = library_free_info_array
                  @library_busy_info_array = library_busy_info_array
            end  

            @seats_floor_array = seats_floor_array
            @seats_3d_array = seats_3d_array

            # container names - Easier to generate in ruby
            @splineChartContainerName = ENV['CONTAINER_SPLINE']+@library.acronym
            @d3ChartContainerName = ENV['CONTAINER_3D']+@library.acronym
            @barChartContainerName = ENV['CONTAINER_BAR']+@library.acronym
            @floorChartContainerName = ENV['CONTAINER_FLOOR']+@library.acronym

            @freeSeatCountLabelName = ENV['LABEL_FREE']+@library.acronym
            @busySeatCountLabelName = ENV['LABEL_BUSY']+@library.acronym
            @freeSeatPercentChartName = ENV['CHART_PERCENT']+@library.acronym
            @occupancyMsgContainerName = ENV['CONTAINER_OCCUPANCY_MSG']+@library.acronym
             
            @library_welcome_msg = "Welcome to " + @library.name + " Library"

      end
end