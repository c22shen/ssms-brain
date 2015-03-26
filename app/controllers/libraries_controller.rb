class LibrariesController < ApplicationController
	def index 
            # city = request.location.city

            # logger.debug country = request.location.country_code

            # Current Location
            # @lat = request.location.latitude
            # @lon = request.location.longitude 

            location_info = request.location
            @latt = location_info.latitude
            @lonn = location_info.longitude
            
            near_libraries = Library.near([location_info.latitude, location_info.longitude],50)
            # @near_libraries.pluck(:id, :name)
            
            @near_library_locations = Array.new 
            # @near_library_locations.push([location_info.latitude, location_info.longitude])

            near_libraries.all.each do |library|
                  @near_library_locations.push([library.latitude, library.longitude])
            end




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
                  @barChartContainerName = ENV['CONTAINER_BAR']
            
      end

      def save_retrieve_comments
            new_article = Article.new 
            new_article.library_id = params[:library_id]
            new_article.title = params[:title]
            new_article.rating = params[:rating]
            new_article.text = params[:text]
            new_article.save!

            library = Library.find_by_id(params[:library_id])
            new_articles = library.articles.where("id>#{params[:recent_article_id]}")
            respond_to do |format| 
                  format.js {render :partial => "libraries/articles", :locals => {:articles => new_articles}} 
            end            
      end


      def update_floor_chart
            seats_floor_array = Array.new
            library = Library.find(params[:library_id])
            library.seats.where("z=#{params[:floor_number]}").each do |seat|
                  seat_info_floor = Hash.new
                  seat_info_floor[:name]=seat.id
                  seat_info_floor[:id]=seat.id
                  seat_info_floor[:color]= getStatusColor(seat.status)
                  seat_info_floor[:x]=seat.x
                  seat_info_floor[:y]=seat.y
                  seats_floor_array.push(seat_info_floor)
            end
            respond_to do |format|
                  format.js {render json: seats_floor_array.to_json}
            end
      end

      def update_volume_chart
            seats_volume_array = Array.new
            library = Library.find(params[:library_id])
            library.seats.where("z=#{params[:floor_number]}").each do |seat|
                  seat_info_volume = Hash.new 
                  seat_info_volume[:name]=seat.status
                  seat_info_volume[:id]=seat.id
                  seat_info_volume[:color]= getVolumeColor(seat.volume)
                  seat_info_volume[:x]=seat.x
                  seat_info_volume[:y]=seat.y
                  seat_info_volume[:z]=seat.volume
                  seats_volume_array.push(seat_info_volume) 
            end
            respond_to do |format|
                  format.js {render json: seats_volume_array.to_json}
            end
      end

      def find_location
        data = Geocoder.search(params[:location_text])
        unless data.count==0
          lng = data[0].geometry["location"]["lng"]
          lat = data[0].geometry["location"]["lat"]
          result = String.new
          result = lng.to_s + ',' + lat.to_s
            
            # result = []
            result=[lat, lng]
          respond_to do |format|
                  format.js {render json: result.to_json}
            end
        end
      end

      def set_location  
            # CLEAN UP LATERRRR
            @homestyle='white'


            seats_info = Array.new
            Library.first.seats.each do |seat|
                  if seat.status =='free'
                        color = '#8DEB95'
                  elsif seat.status == 'busy'
                        color = '#EF5E43'
                  else
                        color = "#FFB03B"
                  end
                  seat_info = Hash.new
                  seat_info[:name]=seat.id
                  seat_info[:id]=seat.id
                  seat_info[:color]=color
                  seat_info[:x]=seat.x
                  seat_info[:y]=seat.y
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
            return color
      end

      def getVolumeColor(volume)
            if volume<100
                  color = ENV['COLOR_LOW']
            elsif volume<200
                  color = ENV['COLOR_MEDIUM']
            else
                  color = ENV['COLOR_HIGH']
            end
            return color
      end

      def create
            @library = Library.new(library_params)
 
  @library.save!
  redirect_to @library

      end

      def show
# Responsible for the very first time display 
            # @homestyle='#252020'
            @homestyle='#526373'

            
            @library = Library.find(params[:id]) 
            seats_floor_array = Array.new
            seats_3d_array = Array.new
            seats_volume_array = Array.new 

            unless @library.floor_array.nil?
                  @displayFloor = @library.floor_array.min
                  @volumeDisplayFloor = @library.floor_array.min
            end
            @currLibraryId =  @library.id

            # z and y are switched in the 3D plot
            unless @library.seats.count == 0 
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

                              seat_info_volume = Hash.new 
                              seat_info_volume[:name]=seat.status
                              seat_info_volume[:id]=seat.id
                              seat_info_volume[:color]= getVolumeColor(seat.volume)
                              seat_info_volume[:x]=seat.x
                              seat_info_volume[:y]=seat.y
                              seat_info_volume[:z]=seat.volume
                              seats_volume_array.push(seat_info_volume) 
                        end

                        # Library Detail Section
                        @busy_seat_count = @library.seats.where("status='busy'").count
                        @free_seat_count = @library.seats.where("status='free'").count
                        @free_seat_percentage = @free_seat_count * 100.0/(@busy_seat_count+@free_seat_count) 


                        # library_free_info_array = Array.new
                        # library_busy_info_array = Array.new
                        # Library.all.each do |library|
                        #       library_free_info_array.push(library.seats.where("status='free'").count)
                        #       library_busy_info_array.push(library.seats.where("status='busy'").count)
                        # end
                        # # Libraries Occupany Comparison
                        # @library_names_array = Library.pluck(:name)
                        # # @library_names = library_names.to_json.html_safe
                        # @library_free_info_array = library_free_info_array
                        # @library_busy_info_array = library_busy_info_array
                  end  
            end

            @seats_floor_array = seats_floor_array
            @seats_3d_array = seats_3d_array
            @seats_volume_array = seats_volume_array

            # container names - Easier to generate in ruby
            @splineChartContainerName = ENV['CONTAINER_SPLINE']+@library.acronym
            @d3ChartContainerName = ENV['CONTAINER_3D']+@library.acronym
            @volumeChartContainerName = ENV['CONTAINER_VOLUME']+@library.acronym

            @barChartContainerName = ENV['CONTAINER_BAR']
            @floorChartContainerName = ENV['CONTAINER_FLOOR']+@library.acronym
            @freeSeatCountLabelName = ENV['LABEL_FREE']+@library.acronym
            @busySeatCountLabelName = ENV['LABEL_BUSY']+@library.acronym
            @freeSeatPercentChartName = ENV['CHART_PERCENT']+@library.acronym
            @occupancyMsgContainerName = ENV['CONTAINER_OCCUPANCY_MSG']+@library.acronym
             
            @library_welcome_msg = "Welcome to " + @library.name + " Library"

      end


      private
  def library_params
    params.require(:library).permit(:name, :description, :kind, :plug, :table, :noise, :lat, :lon,:latitude, :longitude, :coffee, :wifi, :plug)
  end
end